import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:folly_fields/fields/string_field.dart';
import 'package:keystone/config.dart';
import 'package:keystone/models/enterprise_model.dart';
import 'package:keystone/models/user_model.dart';
import 'package:keystone/screens/enterprise_from_code_screen.dart';
import 'package:keystone/screens/enterprise_list_screen.dart';
import 'package:keystone/widgets/info_tile.dart';

import '../helpers/pump_app.dart';

void main() {
  group('Enterprise list screen', () {
    var today = DateTime.parse(
        DateTime.now().toIso8601String().split('T')[0] + ' 00:00:00');

    final enterprise1 = EnterpriseModel.fromJson({
      'clientName': 'Josnei',
      'distance': 0.5,
      'password': '1234',
      'equation': 'h+2',
      'owner': 'Joberval',
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

    final enterprise2 = EnterpriseModel.fromJson({
      'clientName': 'Fazenda',
      'distance': 0.5,
      'password': '1234',
      'equation': 'h+3',
      'basin': 'Bacia',
      'city': 'Sinop/MT',
      'clientCpfCnpj': '81844976017',
      'engineer': 'Thomé',
      'engineerCpfCnpj': '81844976017',
      'engineerRegistry': 'Mt123456',
      'latitude': '55.00',
      'longitude': '12.00',
      'river': 'Teles Pires',
      'subBasin': 'sub-bacia',
      'active': true,
    });

    var userModel = UserModel.fromJson({
      'email': 'user@test.com',
      'name': 'Test User',
      'enterprises': null,
    });

    testWidgets('Happy day', (WidgetTester tester) async {
      final firestore = FakeFirebaseFirestore();
      var userRef = await firestore.collection('users').add(userModel.toMap());

      final user = MockUser(
        isAnonymous: false,
        displayName: userModel.name,
        email: userModel.email,
        uid: userRef.id,
      );

      final auth = MockFirebaseAuth(signedIn: true, mockUser: user);

      var documentReference1 =
          await firestore.collection('enterprises').add(enterprise1.toMap());
      enterprise1.id = documentReference1.id;

      await firestore
          .collection('enterprises')
          .doc(documentReference1.id)
          .update({'__name__': documentReference1.id});

      enterprise2.owner = userRef.id;

      var documentReference2 =
          await firestore.collection('enterprises').add(enterprise2.toMap());
      enterprise2.id = documentReference2.id;

      await firestore
          .collection('enterprises')
          .doc(documentReference2.id)
          .update({'__name__': documentReference2.id});

      userModel.enterprises = <String>[
        documentReference1.id,
        documentReference2.id
      ];

      await firestore
          .collection('users')
          .doc(userRef.id)
          .update(userModel.toMap());

      Config(auth, firestore);

      final GlobalKey<NavigatorState> navigatorKey =
          GlobalKey<NavigatorState>();
      await tester.pumpApp(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Navigator(
            key: navigatorKey,
            onGenerateRoute: (setting) {
              if (setting.name == EnterpriseFromCodeScreen.name) {
                return MaterialPageRoute(
                  builder: (context) => const EnterpriseFromCodeScreen(),
                  settings: RouteSettings(
                    arguments: {},
                  ),
                );
              }
              return MaterialPageRoute(
                builder: (context) => const EnterpriseListScreen(),
                settings: RouteSettings(
                  name: EnterpriseListScreen.name,
                  arguments: {},
                ),
              );
            },
          ),
        ),
      );

      // Wait stream flow start and screen render
      await tester.idle();
      await tester.pumpAndSettle();

      // Must find 2 enterprises
      expect(find.byType(ListTile), findsNWidgets(2));

      // Remove an enterprise that this user dont owns
      await tester.longPress(find.text('Josnei'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Excluir'));
      await tester.pumpAndSettle();
      expect(find.byType(ListTile), findsOneWidget);

      // Add an enterprise from another user
      await tester.tap(find.widgetWithIcon(SpeedDial, Icons.add));
      await tester.pumpAndSettle();
      await tester
          .tap(find.widgetWithIcon(FloatingActionButton, Icons.qr_code));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), documentReference1.id);
      await tester.tap(find.text('ADICIONAR'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(InfoTile, 'Josnei'), findsOneWidget);
      await tester.enterText(find.byType(StringField), '1234');
      await tester.tap(find.text('Adicionar'));
      await tester.idle();
      await tester.pumpAndSettle();
    });
  });
}
