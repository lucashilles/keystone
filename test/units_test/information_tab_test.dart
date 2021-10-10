import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keystone/models/enterprise_model.dart';
import 'package:keystone/widgets/information_tab.dart';
import 'package:keystone/widgets/qr_reference.dart';
import '../helpers/pump_app.dart';

void main() {
  String clip = '';

  (TestWidgetsFlutterBinding.ensureInitialized() as TestWidgetsFlutterBinding)
      .defaultBinaryMessenger
      .setMockMethodCallHandler(SystemChannels.platform, (methodCall) {
    if (methodCall.method == 'Clipboard.setData') {
      clip = methodCall.arguments['text'];
    }
  });

  group('Enterprise Information', () {
    var userMock = MockUser(
      isAnonymous: false,
      displayName: 'Test User',
      email: 'user@test.com',
      uid: 'UserMock',
    );
    var enterpriseModel = EnterpriseModel.fromJson({
      'clientName': 'Josnei',
      'distance': 0.5,
      'id': '1a2b3c4d5e6f7g8h9i',
      'owner': userMock.uid,
    });

    testWidgets('Happy day', (WidgetTester tester) async {
      await tester.pumpApp(
        InformationTab(
          enterprise: enterpriseModel,
          currentUser: userMock,
        ),
      );

      expect(find.byType(InformationTab), findsOneWidget);
      expect(find.text('EDITAR'), findsOneWidget);
    });

    testWidgets('Non admin user', (WidgetTester tester) async {
      userMock = MockUser(
        isAnonymous: false,
        displayName: 'Test User',
        email: 'user@test.com',
        uid: 'UserMock2',
      );
      await tester.pumpApp(
        InformationTab(
          enterprise: enterpriseModel,
          currentUser: userMock,
        ),
      );

      expect(find.text('EDITAR'), findsNothing);
    });

    testWidgets('Copy enterprise address', (WidgetTester tester) async {
      await tester.pumpApp(
        InformationTab(
          enterprise: enterpriseModel,
          currentUser: userMock,
        ),
      );

      await tester.tap(find.byType(QrReference));
      await tester.pumpAndSettle();

      expect(clip, enterpriseModel.id);
    });
  });
}
