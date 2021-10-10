import 'package:flutter/material.dart';
import 'package:folly_fields/fields/date_field.dart';

class ConfigReportDialog extends StatefulWidget {
  const ConfigReportDialog({Key? key, required this.onAccept})
      : super(key: key);

  @override
  _ConfigReportDialogState createState() => new _ConfigReportDialogState();

  final Function(DateTime initialDate, DateTime finalDate) onAccept;
}

class _ConfigReportDialogState extends State<ConfigReportDialog> {
  DateEditingController initialDate =
      DateEditingController(dateTime: DateTime.now());
  DateEditingController finalDate =
      DateEditingController(dateTime: DateTime.now());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: GlobalKey(),
      title: Text('Gerar relatório'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DateField(
            label: 'Data inicial',
            lastDate: DateTime.now(),
            controller: initialDate,
          ),
          DateField(
            label: 'Data final',
            lastDate: DateTime.now(),
            controller: finalDate,
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
          child: Text('Gerar'),
          onPressed: () async {
            widget.onAccept(initialDate.date!,
                finalDate.date!.add(Duration(hours: 23, minutes: 59)));
            // Navigator.of(context).popAndPushNamed(
            //   EnterpriseReportScreen.name,
            //   arguments: {
            //     'enterprise': widget.enterprise,
            //     'initialDate': initialDate.date,
            //     'finalDate':
            //         finalDate.date!.add(Duration(hours: 23, minutes: 59)),
            //   },
            // );
          },
        ),
      ],
    );
  }
}
