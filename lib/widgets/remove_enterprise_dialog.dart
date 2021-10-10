import 'package:flutter/material.dart';

class RemoveEnterpriseDialog extends StatefulWidget {
  const RemoveEnterpriseDialog({Key? key, required this.onAccept})
      : super(key: key);

  @override
  _RemoveEnterpriseDialogState createState() =>
      new _RemoveEnterpriseDialogState();

  final Function onAccept;
}

class _RemoveEnterpriseDialogState extends State<RemoveEnterpriseDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: GlobalKey(),
      title: Text('Excluir este empreendimento?'),
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
            widget.onAccept();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
