import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:folly_fields/fields/date_field.dart';
import 'package:folly_fields/fields/date_time_field.dart';
import 'package:folly_fields/fields/decimal_field.dart';
import 'package:folly_fields/fields/string_field.dart';
import 'package:folly_fields/util/decimal.dart';
import 'package:folly_fields/widgets/waiting_message.dart';
import 'package:keystone/models/enterprise_model.dart';
import 'package:keystone/screens/enterprise_report_screen.dart';
import 'package:keystone/utils/equation_utils.dart';

class AddMeasureDialog extends StatefulWidget {
  const AddMeasureDialog({Key? key, required this.enterpriseId})
      : super(key: key);

  @override
  _AddMeasureDialogState createState() => new _AddMeasureDialogState();

  final String enterpriseId;
}

class _AddMeasureDialogState extends State<AddMeasureDialog> {
  DecimalEditingController controller = DecimalEditingController(
    Decimal(initialValue: 0, precision: 2),
  );
  DateTimeEditingController measureDate =
      DateTimeEditingController(dateTime: DateTime.now());

  Future<void> _addMeasure(double value, DateTime date) async {
    await FirebaseFirestore.instance
        .collection('enterprises')
        .doc(widget.enterpriseId)
        .collection('measurements')
        .add(
      {
        'measure': value,
        'date': date,
        'user': FirebaseAuth.instance.currentUser!.uid,
      },
    );
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
            onFieldSubmitted: (value) async {
              await _addMeasure(
                  controller.decimal.value, measureDate.dateTime!);
              Navigator.pop(context);
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
          onPressed: () async {
            await _addMeasure(controller.decimal.value, measureDate.dateTime!);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
