import 'package:flutter/material.dart';
import 'package:folly_fields/fields/date_time_field.dart';
import 'package:folly_fields/fields/decimal_field.dart';
import 'package:folly_fields/util/decimal.dart';
import 'package:keystone/models/measurement_model.dart';

class AddMeasureDialog extends StatefulWidget {
  const AddMeasureDialog({Key? key, required this.onAccept}) : super(key: key);

  @override
  _AddMeasureDialogState createState() => new _AddMeasureDialogState();

  final Function(MeasurementModel measure) onAccept;
}

class _AddMeasureDialogState extends State<AddMeasureDialog> {
  DecimalEditingController controller = DecimalEditingController(
    Decimal(initialValue: 0, precision: 2),
  );

  DateTimeEditingController measureDate =
      DateTimeEditingController(dateTime: DateTime.now());

  void _addMeasure() {
    widget.onAccept(
      MeasurementModel().fromJson(
        {
          'measure': controller.decimal.value,
          'date': measureDate.dateTime!,
        },
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    controller.dispose();
    measureDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: GlobalKey(),
      title: Text('Adicionar medição'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecimalField(
            label: 'Nível (m)',
            controller: controller,
            onFieldSubmitted: (value) {
              _addMeasure();
            },
          ),
          DateTimeField(
            label: 'Data da medição',
            lastDate: DateTime.now(),
            controller: measureDate,
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancelar'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text('Salvar'),
          onPressed: () {
            _addMeasure();
          },
        ),
      ],
    );
  }
}
