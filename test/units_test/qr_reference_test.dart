import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
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

  group('QR Reference', () {
    testWidgets('Happy day', (WidgetTester tester) async {
      await tester.pumpApp(
        QrReference(
          password: '1234',
          reference: '1a2b3c4d5e6f7g8h9i',
        ),
      );

      expect(find.byType(QrReference), findsOneWidget);
      expect(find.text('Senha: 1234'), findsOneWidget);
    });

    testWidgets('Copy reference', (WidgetTester tester) async {
      await tester.pumpApp(
        QrReference(
          password: '1234',
          reference: '1a2b3c4d5e6f7g8h9i',
        ),
      );

      await tester.tap(find.byType(QrReference));
      await tester.pumpAndSettle();

      expect(clip, '1a2b3c4d5e6f7g8h9i');
    });
  });
}
