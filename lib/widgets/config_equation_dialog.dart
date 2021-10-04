import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:folly_fields/fields/date_field.dart';
import 'package:folly_fields/fields/decimal_field.dart';
import 'package:folly_fields/fields/string_field.dart';
import 'package:folly_fields/util/decimal.dart';
import 'package:folly_fields/widgets/waiting_message.dart';
import 'package:keystone/models/enterprise_model.dart';
import 'package:keystone/screens/enterprise_report_screen.dart';
import 'package:keystone/utils/equation_utils.dart';

class ConfigEquationDialog extends StatefulWidget {
  const ConfigEquationDialog(
      {Key? key, required this.equation, required this.onOk})
      : super(key: key);

  @override
  _ConfigEquationDialogState createState() => new _ConfigEquationDialogState();

  final String equation;

  final Function onOk;
}

class _ConfigEquationDialogState extends State<ConfigEquationDialog> {
  TextEditingController keyCurve = TextEditingController();

  DecimalEditingController variable = DecimalEditingController(
    Decimal(initialValue: 0, precision: 2),
  );

  double flowRate = 0;

  EquationUtils? equationUtils;

  @override
  void initState() {
    super.initState();
    keyCurve.text = widget.equation;
  }

  String cleanEquationString(String equation) {
    String cleanedStr = equation.replaceAll(',', '.');
    cleanedStr = cleanedStr.replaceAll('H', 'h');
    return cleanedStr.replaceAll(' ', '');
  }

  void _calculateFlow() {
    String cleanedStr = cleanEquationString(keyCurve.text.replaceAll(',', '.'));

    equationUtils = EquationUtils(equation: cleanedStr);
    setState(() {
      keyCurve.text = cleanedStr;
      flowRate = equationUtils!.getFlowRate(variable.decimal.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: GlobalKey(),
      title: Text('Configurar curva chave'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: const Text(
                'Entre a equação da curva chave na forma linear (como é introduzida nas calculadoras Cásio), o nível deve ser representado pela variável "h".',
                textAlign: TextAlign.justify,
              ),
            ),
            StringField(
              label: 'Curva chave',
              controller: keyCurve,
            ),
            DecimalField(
              label: 'Valor para teste',
              controller: variable,
              validator: (Decimal value) =>
                  value.value == 0 ? 'Informe o valor de teste.' : null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: RichText(
                      text: TextSpan(
                        text: 'Vazão: ',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                '${flowRate != 0 ? flowRate.toStringAsFixed(3) : '0.000'} m³/s',
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextButton(onPressed: _calculateFlow, child: Text('Testar')),
                ],
              ),
            ),
          ],
        ),
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
            widget.onOk(cleanEquationString(keyCurve.text));
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
