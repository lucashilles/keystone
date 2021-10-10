import 'package:flutter/material.dart';

class MeasureTile extends StatelessWidget {
  const MeasureTile(
      {Key? key,
      required this.level,
      required this.flowRate,
      required this.date,
      required this.canRemove,
      required this.onRemove})
      : super(key: key);

  final double level;
  final double flowRate;
  final DateTime date;
  final bool canRemove;
  final Function onRemove;

  void _deletMeasureDialog(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          key: GlobalKey(),
          title: Text('Excluir medição?'),
          content: Text('Esta ação não poderá ser desfeita!'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Excluir'),
              onPressed: () async {
                onRemove();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
          'Nível: ${level.toStringAsFixed(2)} m - Vazão: ${flowRate.toStringAsFixed(3)} m³/s'),
      subtitle: Text(date.toString()),
      trailing: canRemove ? Icon(Icons.delete) : null,
      onLongPress: () {
        if (canRemove) {
          _deletMeasureDialog(context);
        }
      },
    );
  }
}
