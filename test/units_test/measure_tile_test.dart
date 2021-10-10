import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:keystone/widgets/measure_tile.dart';
import '../helpers/pump_app.dart';

void main() {
  var today = DateTime.parse(
      DateTime.now().toIso8601String().split('T')[0] + ' 00:00:00');

  group('Measure tile', () {
    testWidgets('Happy day can remove', (WidgetTester tester) async {
      await tester.pumpApp(
        Material(
          child: MeasureTile(
            canRemove: true,
            date: today,
            flowRate: 5.4321,
            level: 1.2345,
            onRemove: () {},
          ),
        ),
      );

      expect(find.byType(MeasureTile), findsOneWidget);
      expect(find.widgetWithIcon(ListTile, Icons.delete), findsOneWidget);
    });

    testWidgets('Happy day cant remove', (WidgetTester tester) async {
      await tester.pumpApp(
        Material(
          child: MeasureTile(
            canRemove: false,
            date: today,
            flowRate: 5.4321,
            level: 1.2345,
            onRemove: () {},
          ),
        ),
      );

      expect(find.byType(MeasureTile), findsOneWidget);
      expect(find.widgetWithIcon(ListTile, Icons.delete), findsNothing);
    });

    testWidgets('Long press to remove', (WidgetTester tester) async {
      await tester.pumpApp(
        Material(
          child: MeasureTile(
            canRemove: true,
            date: today,
            flowRate: 5.4321,
            level: 1.2345,
            onRemove: () {},
          ),
        ),
      );

      await tester.longPress(find.byType(ListTile));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });
  });
}
