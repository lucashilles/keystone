import 'package:flutter_test/flutter_test.dart';
import 'package:folly_fields/fields/date_time_field.dart';
import 'package:folly_fields/fields/decimal_field.dart';
import 'package:keystone/models/measurement_model.dart';
import 'package:keystone/widgets/add_measure_dialog.dart';
import '../helpers/pump_app.dart';

// class UserMock extends Mock implements User {
//   // final String _uid;
//   //
//   // UserMock({
//   //   String uid = 'UserMock',
//   // }) : _uid = uid;
// }
//
// class FirebaseAuthMock extends Mock implements FirebaseAuth {
//   // @override
//   // User? get currentUser {
//   //   return UserMock();
//   // }
// }

void main() {
  group('Add measure dialog', () {
    testWidgets('Happy day', (WidgetTester tester) async {
      await tester.pumpApp(
        AddMeasureDialog(
          onAccept: (measure) {},
        ),
      );
    });

    testWidgets('Filling with data', (WidgetTester tester) async {
      var value;
      await tester.pumpApp(
        AddMeasureDialog(
          onAccept: (measure) => value = measure,
        ),
      );

      await tester.enterText(find.byType(DecimalField), '314');
      await tester.enterText(find.byType(DateTimeField), '01/01/2021 12:00');
      await tester.pump();

      await tester.tap(find.text('Salvar'));

      expect(
        value,
        MeasurementModel().fromJson(
          {
            'measure': 3.14,
            'date': DateTime.parse('2021-01-01 12:00:00'),
          },
        ),
      );
    });

    testWidgets('Cancelling', (WidgetTester tester) async {
      var value;
      await tester.pumpApp(
        AddMeasureDialog(
          onAccept: (measure) => value = measure,
        ),
      );

      await tester.enterText(find.byType(DecimalField), '314');
      await tester.enterText(find.byType(DateTimeField), '01/01/2021 12:00');

      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();

      expect(find.byType(AddMeasureDialog), findsNothing);
    });
  });
}
