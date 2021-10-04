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

class RemoveEnterpriseDialog extends StatefulWidget {
  const RemoveEnterpriseDialog(
      {Key? key, required this.enterprise, required this.onOk})
      : super(key: key);

  @override
  _RemoveEnterpriseDialogState createState() =>
      new _RemoveEnterpriseDialogState();

  final EnterpriseModel enterprise;

  final Function onOk;
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
            widget.onOk(widget.enterprise);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
