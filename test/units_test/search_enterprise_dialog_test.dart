import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:folly_fields/fields/string_field.dart';
import 'package:keystone/models/enterprise_model.dart';
import 'package:keystone/widgets/search_enterprise_dialog.dart';
import '../helpers/pump_app.dart';

void main() {
  group('Search enterprise dialog', () {
    var userMock = MockUser(
      isAnonymous: false,
      displayName: 'Test User',
      email: 'user@test.com',
      uid: 'UserMock',
    );
    var enterpriseModel = EnterpriseModel.fromJson({
      'clientName': 'Josnei',
      'city': 'Sinop/MT',
      'river': 'Teles Pires',
      'latitude': '55.11',
      'longitude': '12.69',
      'distance': 0.5,
      'id': '1a2b3c4d5e6f7g8h9i',
      'owner': userMock.uid,
      'password': '1234',
      'active': true,
    });

    testWidgets('Happy day', (WidgetTester tester) async {
      final firestore = FakeFirebaseFirestore();
      var documentReference = await firestore
          .collection('enterprises')
          .add(enterpriseModel.toMap());

      await tester.pumpApp(
        SearchEnterpriseDialog(
          enterpriseDoc: documentReference.get(),
          onSave: () {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SearchEnterpriseDialog), findsOneWidget);
      expect(find.text('Teles Pires'), findsOneWidget);
    });

    testWidgets('Enterprise not found', (WidgetTester tester) async {
      final firestore = FakeFirebaseFirestore();
      await tester.pumpApp(
        SearchEnterpriseDialog(
          enterpriseDoc: firestore
              .collection('enterprises')
              .doc('a1b2c3d4e5g6h7i8j9')
              .get(),
          onSave: () {},
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(SearchEnterpriseDialog), findsOneWidget);
      expect(find.text('Não foi possível encontrar o empreendimento.'),
          findsOneWidget);
    });

    testWidgets('Wrong password', (WidgetTester tester) async {
      final firestore = FakeFirebaseFirestore();
      var documentReference = await firestore
          .collection('enterprises')
          .add(enterpriseModel.toMap());

      bool saved = false;
      await tester.pumpApp(
        SearchEnterpriseDialog(
          enterpriseDoc: documentReference.get(),
          onSave: () => saved = true,
        ),
      );

      await tester.pumpAndSettle();

      await tester.enterText(find.byType(StringField), '4321');
      await tester.tap(find.text('Adicionar'));

      await tester.pumpAndSettle();

      expect(find.byType(SearchEnterpriseDialog), findsOneWidget);
      expect(saved, false);
    });

    testWidgets('Correct password', (WidgetTester tester) async {
      final firestore = FakeFirebaseFirestore();
      var documentReference = await firestore
          .collection('enterprises')
          .add(enterpriseModel.toMap());

      bool saved = false;
      await tester.pumpApp(
        SearchEnterpriseDialog(
          enterpriseDoc: documentReference.get(),
          onSave: () => saved = true,
        ),
      );

      await tester.pumpAndSettle();

      await tester.enterText(find.byType(StringField), '1234');
      await tester.tap(find.text('Adicionar'));

      await tester.pumpAndSettle();

      expect(find.byType(SearchEnterpriseDialog), findsNothing);
      expect(saved, true);
    });

    testWidgets('Cancelling', (WidgetTester tester) async {
      final firestore = FakeFirebaseFirestore();
      var documentReference = await firestore
          .collection('enterprises')
          .add(enterpriseModel.toMap());

      await tester.pumpApp(
        SearchEnterpriseDialog(
          enterpriseDoc: documentReference.get(),
          onSave: () {},
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.byType(SearchEnterpriseDialog), findsNothing);
    });
  });
}
