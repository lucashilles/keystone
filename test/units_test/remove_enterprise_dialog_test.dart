import 'package:flutter_test/flutter_test.dart';
import 'package:keystone/widgets/remove_enterprise_dialog.dart';
import '../helpers/pump_app.dart';

void main() {
  group('Remove enterprise dialog', () {
    testWidgets('Happy day', (WidgetTester tester) async {
      await tester.pumpApp(
        RemoveEnterpriseDialog(
          onAccept: () {},
        ),
      );

      expect(find.byType(RemoveEnterpriseDialog), findsOneWidget);
    });

    testWidgets('Confirm removal', (WidgetTester tester) async {
      bool removed = false;
      await tester.pumpApp(
        RemoveEnterpriseDialog(
          onAccept: () => removed = true,
        ),
      );

      await tester.tap(find.text('Excluir'));
      await tester.pumpAndSettle();

      expect(removed, true);
      expect(find.byType(RemoveEnterpriseDialog), findsNothing);
    });

    testWidgets('Cancelling', (WidgetTester tester) async {
      await tester.pumpApp(
        RemoveEnterpriseDialog(
          onAccept: () {},
        ),
      );

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.byType(RemoveEnterpriseDialog), findsNothing);
    });
  });
}
