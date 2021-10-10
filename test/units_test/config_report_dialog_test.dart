import 'package:flutter_test/flutter_test.dart';
import 'package:folly_fields/fields/date_field.dart';
import 'package:keystone/widgets/config_report_dialog.dart';
import '../helpers/pump_app.dart';

void main() {
  group('Config report dialog', () {
    testWidgets('Happy day', (WidgetTester tester) async {
      await tester.pumpApp(
        ConfigReportDialog(
          onAccept: (initialDate, finalDate) {},
        ),
      );

      expect(find.byType(DateField), findsNWidgets(2));
      expect(find.text('Cancelar'), findsOneWidget);
      expect(find.text('Gerar'), findsOneWidget);
    });

    testWidgets('Filling with data', (WidgetTester tester) async {
      var initialDateTime, finalDateTime;
      await tester.pumpApp(
        ConfigReportDialog(
          onAccept: (initialDate, finalDate) {
            initialDateTime = initialDate;
            finalDateTime = finalDate;
          },
        ),
      );

      await tester.tap(find.text('Gerar'));
      await tester.pumpAndSettle();

      var today = DateTime.parse(
          DateTime.now().toIso8601String().split('T')[0] + ' 00:00:00');

      expect(initialDateTime, today);
      expect(
        finalDateTime,
        today.add(Duration(hours: 23, minutes: 59)),
      );
    });

    testWidgets('Cancelling', (WidgetTester tester) async {
      await tester.pumpApp(
        ConfigReportDialog(
          onAccept: (initialDate, finalDate) {},
        ),
      );

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.byType(ConfigReportDialog), findsNothing);
    });
  });
}
