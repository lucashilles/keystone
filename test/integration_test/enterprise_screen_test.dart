import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:folly_fields/fields/date_time_field.dart';
import 'package:folly_fields/fields/decimal_field.dart';
import 'package:folly_fields/fields/string_field.dart';
import 'package:keystone/config.dart';
import 'package:keystone/models/enterprise_model.dart';
import 'package:keystone/screens/enterprise_create_screen.dart';
import 'package:keystone/screens/enterprise_screen.dart';
import 'package:keystone/widgets/measure_tile.dart';
import '../helpers/pump_app.dart';

void main() {
  group('Enterprise screen', () {
    var today = DateTime.parse(
        DateTime.now().toIso8601String().split('T')[0] + ' 00:00:00');

    final user = MockUser(
      isAnonymous: false,
      displayName: 'Test User',
      email: 'user@test.com',
      uid: 'UserMock',
    );

    final enterpriseModel = EnterpriseModel.fromJson({
      'clientName': 'Josnei',
      'distance': 0.5,
      'id': '1a2b3c4d5e6f7g8h9i',
      'password': '1234',
      'equation': 'h+2',
      'owner': user.uid,
      'basin': 'Bacia',
      'city': 'Sinop/MT',
      'clientCpfCnpj': '81844976017',
      'engineer': 'Joberval',
      'engineerCpfCnpj': '81844976017',
      'engineerRegistry': 'Mt123456',
      'latitude': '55.00',
      'longitude': '12.00',
      'river': 'rio',
      'subBasin': 'sub-bacia',
      'active': true,
    });

    var measurementList = [
      {
        'measure': 5.154,
        'date': today,
        'user': 'alguem',
      },
      {
        'measure': 2.69,
        'date': today.subtract(Duration(hours: 2)),
        'user': 'alguem',
      },
      {
        'measure': 4.205,
        'date': today.subtract(Duration(hours: 5)),
        'user': user.uid,
      },
    ];

    testWidgets('Happy day admin', (WidgetTester tester) async {
      final auth = MockFirebaseAuth(signedIn: true, mockUser: user);

      final firestore = FakeFirebaseFirestore();
      var documentReference = await firestore
          .collection('enterprises')
          .add(enterpriseModel.toMap());
      enterpriseModel.id = documentReference.id;

      var measurements = firestore
          .collection('enterprises')
          .doc(documentReference.id)
          .collection('measurements');

      measurementList.forEach((element) {
        measurements.add(element);
      });

      Config(auth, firestore);

      final GlobalKey<NavigatorState> navigatorKey =
          GlobalKey<NavigatorState>();
      await tester.pumpApp(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Navigator(
            key: navigatorKey,
            onGenerateRoute: (setting) {
              if (setting.name == EnterpriseCreateScreen.name) {
                return MaterialPageRoute(
                  builder: (context) => const EnterpriseCreateScreen(),
                  settings: RouteSettings(
                    arguments: {
                      'editing': true,
                      'enterprise': enterpriseModel,
                    },
                  ),
                );
              }
              return MaterialPageRoute(
                builder: (context) => const EnterpriseScreen(),
                settings: RouteSettings(
                  arguments: {
                    'enterprise': enterpriseModel,
                  },
                ),
              );
            },
          ),
        ),
      );

      // Wait stream flow start and screen render
      await tester.idle();
      await tester.pumpAndSettle();

      // Must find 3 measurements that can be removed
      expect(find.byType(MeasureTile), findsNWidgets(3));
      expect(find.widgetWithIcon(ListTile, Icons.delete), findsNWidgets(3));

      // Verify if the values os measurements are correct
      // (5.15m, 7.15m3/s) (2.69m, 4.69m3/s) (4.20m, 6.20m3/s)
      expect(find.text('Nível: 5.15 m - Vazão: 7.154 m³/s'), findsOneWidget);
      expect(find.text('Nível: 2.69 m - Vazão: 4.690 m³/s'), findsOneWidget);
      expect(find.text('Nível: 4.21 m - Vazão: 6.205 m³/s'), findsOneWidget);

      // Remove the last measurement
      await tester.longPress(find.text('Nível: 4.21 m - Vazão: 6.205 m³/s'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Excluir'));
      await tester.pumpAndSettle();
      expect(find.byType(MeasureTile), findsNWidgets(2));

      // Add a new measurement
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(DecimalField), '111');
      await tester.enterText(find.byType(DateTimeField), '01/01/2021 12:00');
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();
      expect(find.byType(MeasureTile), findsNWidgets(3));
      expect(find.text('Nível: 1.11 m - Vazão: 3.110 m³/s'), findsOneWidget);

      // Show enterprise information
      // It's expected to find a QR_Reference and an edit button
      await tester.tap(find.widgetWithText(Tab, 'Informações'));
      await tester.pumpAndSettle();
      expect(find.text('${documentReference.id}'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byType(ElevatedButton).first,
        500.0,
        scrollable: find.descendant(
            of: find.byType(SingleChildScrollView),
            matching: find.byType(Scrollable)),
      );
      await tester.tap(find.byType(ElevatedButton).first);
      await tester.pumpAndSettle();

      // Edit enterprise name
      expect(find.text('Editar empreendimento'), findsOneWidget);
      await tester.enterText(find.byType(StringField).first, '123');
      await tester.scrollUntilVisible(
        find.widgetWithText(ElevatedButton, 'Salvar'),
        500.0,
        scrollable: find
            .descendant(
                of: find.byType(SingleChildScrollView),
                matching: find.byType(Scrollable))
            .last,
      );
      await tester.tap(find.widgetWithText(ElevatedButton, 'Salvar'));
      await tester.pumpAndSettle();
      await tester.idle();
      expect(find.text('123'), findsOneWidget);
    });

    testWidgets('Happy day common user', (WidgetTester tester) async {
      final auth = MockFirebaseAuth(signedIn: true, mockUser: user);

      final firestore = FakeFirebaseFirestore();
      enterpriseModel.owner = 'Joberval';
      var documentReference = await firestore
          .collection('enterprises')
          .add(enterpriseModel.toMap());
      enterpriseModel.id = documentReference.id;

      var measurements = firestore
          .collection('enterprises')
          .doc(documentReference.id)
          .collection('measurements');

      measurementList.forEach((element) {
        measurements.add(element);
      });

      Config(auth, firestore);

      final GlobalKey<NavigatorState> navigatorKey =
          GlobalKey<NavigatorState>();
      await tester.pumpApp(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Navigator(
            key: navigatorKey,
            onGenerateRoute: (setting) {
              if (setting.name == EnterpriseCreateScreen.name) {
                return MaterialPageRoute(
                  builder: (context) => const EnterpriseCreateScreen(),
                  settings: RouteSettings(
                    arguments: {
                      'editing': true,
                      'enterprise': enterpriseModel,
                    },
                  ),
                );
              }
              return MaterialPageRoute(
                builder: (context) => const EnterpriseScreen(),
                settings: RouteSettings(
                  arguments: {
                    'enterprise': enterpriseModel,
                  },
                ),
              );
            },
          ),
        ),
      );

      // Wait stream flow start and screen render
      await tester.idle();
      await tester.pumpAndSettle();

      // Must find 3 measurements that can be removed
      expect(find.byType(MeasureTile), findsNWidgets(3));
      expect(find.widgetWithIcon(ListTile, Icons.delete), findsNWidgets(1));

      // Verify if the values os measurements are correct
      // (5.15m, 7.15m3/s) (2.69m, 4.69m3/s) (4.20m, 6.20m3/s)
      expect(find.text('Nível: 5.15 m - Vazão: 7.154 m³/s'), findsOneWidget);
      expect(find.text('Nível: 2.69 m - Vazão: 4.690 m³/s'), findsOneWidget);
      expect(find.text('Nível: 4.21 m - Vazão: 6.205 m³/s'), findsOneWidget);

      // Remove the last measurement
      await tester.longPress(find.text('Nível: 4.21 m - Vazão: 6.205 m³/s'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Excluir'));
      await tester.pumpAndSettle();
      expect(find.byType(MeasureTile), findsNWidgets(2));

      // Add a new measurement
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(DecimalField), '111');
      await tester.enterText(find.byType(DateTimeField), '01/01/2021 12:00');
      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();
      expect(find.byType(MeasureTile), findsNWidgets(3));
      expect(find.text('Nível: 1.11 m - Vazão: 3.110 m³/s'), findsOneWidget);

      // Show enterprise information
      // It's expected to find a QR_Reference and an edit button
      await tester.tap(find.widgetWithText(Tab, 'Informações'));
      await tester.pumpAndSettle();
      expect(find.text('${documentReference.id}'), findsOneWidget);
      await tester.scrollUntilVisible(
        find.byType(ElevatedButton).first,
        500.0,
        scrollable: find.descendant(
            of: find.byType(SingleChildScrollView),
            matching: find.byType(Scrollable)),
      );

      expect(find.widgetWithText(ElevatedButton, 'EDITAR'), findsNothing);
    });
  });
}
