import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:folly_fields/fields/decimal_field.dart';
import 'package:folly_fields/fields/string_field.dart';
import 'package:keystone/widgets/add_measure_dialog.dart';
import 'package:keystone/widgets/config_equation_dialog.dart';
import '../helpers/pump_app.dart';

void main() {
  group('Config equation dialog', () {
    testWidgets('Happy day', (WidgetTester tester) async {
      await tester.pumpApp(
        ConfigEquationDialog(
          equation: '',
          onOk: (value) {},
        ),
      );
    });

    testWidgets('Start passing equation', (WidgetTester tester) async {
      await tester.pumpApp(
        ConfigEquationDialog(
          equation: 'h+5',
          onOk: (value) {},
        ),
      );

      expect(find.text('h+5'), findsOneWidget);
    });

    testWidgets('Equation cleanup', (WidgetTester tester) async {
      await tester.pumpApp(
        ConfigEquationDialog(
          equation: '',
          onOk: (value) {},
        ),
      );

      await tester.enterText(find.byType(StringField), '1,75* H - 0.69');
      await tester.enterText(find.byType(DecimalField), '314');

      await tester.tap(find.text('Testar'));
      await tester.pumpAndSettle();

      expect(find.text('1.75*h-0.69'), findsOneWidget);
    });

    testWidgets('Testing equation', (WidgetTester tester) async {
      await tester.pumpApp(
        ConfigEquationDialog(
          equation: '',
          onOk: (value) {},
        ),
      );

      await tester.enterText(find.byType(StringField), '1,75* H - 0.69');
      await tester.enterText(find.byType(DecimalField), '100');

      await tester.tap(find.text('Testar'));
      await tester.pumpAndSettle();

      expect(
          find.byWidgetPredicate((Widget widget) =>
              widget is RichText &&
              widget.text.toPlainText() == 'Vazão: 1.060 m³/s'),
          findsOneWidget);
    });

    testWidgets('Saving equation', (WidgetTester tester) async {
      var equation;
      await tester.pumpApp(
        ConfigEquationDialog(
          equation: 'h+5',
          onOk: (value) => equation = value,
        ),
      );

      await tester.enterText(find.byType(StringField), '1,75* H - 0.69');
      await tester.enterText(find.byType(DecimalField), '100');

      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      expect(equation, '1.75*h-0.69');
    });

    testWidgets('Cancelling', (WidgetTester tester) async {
      await tester.pumpApp(
        ConfigEquationDialog(
          equation: '',
          onOk: (value) {},
        ),
      );

      await tester.enterText(find.byType(StringField), '1,75* H - 0.69');
      await tester.enterText(find.byType(DecimalField), '314');

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.byType(AddMeasureDialog), findsNothing);
    });
  });
}
