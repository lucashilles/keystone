import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:folly_fields/fields/cpj_cnpj_field.dart';
import 'package:folly_fields/fields/string_field.dart';
import 'package:folly_fields/fields/decimal_field.dart';
import 'package:folly_fields/util/decimal.dart';
import 'package:keystone/config.dart';
import 'package:keystone/models/enterprise_model.dart';
import 'package:keystone/widgets/config_equation_dialog.dart';

class EnterpriseCreateScreen extends StatefulWidget {
  const EnterpriseCreateScreen({Key? key}) : super(key: key);
  static const String name = '/EnterpriseCreate';

  @override
  _EnterpriseCreateScreenState createState() => _EnterpriseCreateScreenState();
}

class _EnterpriseCreateScreenState extends State<EnterpriseCreateScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController equationController = TextEditingController();

  EnterpriseModel model = EnterpriseModel();

  Future<void> _register(BuildContext context, bool? editing) async {
    User? currentUser = Config.getInstance().firebaseAuth.currentUser;

    if (_formKey.currentState!.validate() && currentUser != null) {
      _formKey.currentState!.save();
      model.owner = currentUser.uid;

      try {
        if (editing == true) {
          await Config.getInstance()
              .firebaseFirestore
              .collection('enterprises')
              .doc(model.id)
              .update(model.toMap());
        } else {
          DocumentReference<Map<String, dynamic>> enterpriseReference =
              await Config.getInstance()
                  .firebaseFirestore
                  .collection('enterprises')
                  .add(model.toMap());

          DocumentSnapshot<Map<String, dynamic>> userSnapshot =
              await Config.getInstance()
                  .firebaseFirestore
                  .collection('users')
                  .doc(currentUser.uid)
                  .get();

          var enterpriseList =
              userSnapshot.data()!['enterprises'] as List<dynamic>;
          enterpriseList.add(enterpriseReference.id);

          userSnapshot.reference.update({'enterprises': enterpriseList});
        }
        Navigator.of(context).pop();
      } catch (e) {
        print('Register error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var args = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map<String, dynamic>;

    if (args['editing'] == true) {
      model = args['enterprise'];
    }

    equationController.text = model.equation;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${args['editing'] == true ? 'Editar empreendimento' : 'Novo empreendimento'}'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 8, 4),
                  child: Text(
                    'Empreendimento',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontSize: 18),
                  ),
                ),
                StringField(
                  label: 'Nome',
                  initialValue: model.clientName,
                  onSaved: (String value) => model.clientName = value,
                  validator: (String value) => value.isEmpty
                      ? 'Informe o nome do empreendimento.'
                      : null,
                ),
                CpfCnpjField(
                    label: 'CPF ou CNPJ',
                    initialValue: model.clientCpfCnpj,
                    onSaved: (String? newValue) =>
                        model.clientCpfCnpj = newValue!),
                StringField(
                  label: 'Rio',
                  initialValue: model.river,
                  onSaved: (String value) => model.river = value,
                  validator: (String value) =>
                      value.isEmpty ? 'Informe o nome do rio.' : null,
                ),
                StringField(
                  label: 'Bacia',
                  initialValue: model.basin,
                  onSaved: (String value) => model.basin = value,
                  validator: (String value) =>
                      value.isEmpty ? 'Informe a bacia.' : null,
                ),
                StringField(
                  label: 'Sub-bacia',
                  initialValue: model.subBasin,
                  onSaved: (String value) => model.subBasin = value,
                  validator: (String value) =>
                      value.isEmpty ? 'Informe a sub-bacia.' : null,
                ),
                StringField(
                  label: 'Latitude',
                  initialValue: model.latitude,
                  onSaved: (String value) => model.latitude = value,
                  validator: (String value) =>
                      value.isEmpty ? 'Informe a latitude.' : null,
                ),
                StringField(
                  label: 'Longitude',
                  initialValue: model.longitude,
                  onSaved: (String value) => model.longitude = value,
                  validator: (String value) =>
                      value.isEmpty ? 'Informe a longitude.' : null,
                ),
                DecimalField(
                  label: 'Distância da foz (km)',
                  initialValue:
                      Decimal(doubleValue: model.distance, precision: 3),
                  onSaved: (Decimal value) => model.distance = value.value,
                  validator: (Decimal value) =>
                      value.value == 0 ? 'Informe a distância da foz.' : null,
                ),
                StringField(
                  label: 'Município/UF',
                  initialValue: model.city,
                  onSaved: (String value) => model.city = value,
                  validator: (String value) =>
                      value.isEmpty ? 'Informe o município/UF.' : null,
                ),
                IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: TextFormField(
                            onSaved: (String? value) => model.equation = value!,
                            validator: (String? value) => value!.isEmpty
                                ? 'Informe a curva chave.'
                                : null,
                            enabled: false,
                            controller: equationController,
                            decoration: InputDecoration(
                              label: const Text('Curva Chave'),
                              border: const OutlineInputBorder().copyWith(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  topLeft: Radius.circular(5),
                                ),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(5),
                                topRight: Radius.circular(5),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (context) {
                                return ConfigEquationDialog(
                                  equation: model.equation,
                                  onOk: (String value) {
                                    setState(() {
                                      model.equation = value;
                                      equationController.text = value;
                                    });
                                  },
                                );
                              },
                            );
                          },
                          child: Icon(
                              args['editing'] == true ? Icons.edit : Icons.add),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 8, 4),
                  child: Text(
                    'Responsável Técnico',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontSize: 18),
                  ),
                ),
                StringField(
                  label: 'Nome',
                  initialValue: model.engineer,
                  onSaved: (String value) => model.engineer = value,
                  validator: (String value) =>
                      value.isEmpty ? 'Informe a nome.' : null,
                ),
                CpfCnpjField(
                    label: 'CPF ou CNPJ',
                    initialValue: model.engineerCpfCnpj,
                    onSaved: (String? newValue) =>
                        model.engineerCpfCnpj = newValue!),
                StringField(
                  label: 'Registro técnico',
                  initialValue: model.engineerRegistry,
                  onSaved: (String value) => model.engineerRegistry = value,
                  validator: (String value) =>
                      value.isEmpty ? 'Informe o registro.' : null,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 8, 4),
                  child: Text(
                    'Compartilhamento',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontSize: 18),
                  ),
                ),
                StringField(
                  label: 'Senha',
                  initialValue: model.password,
                  onSaved: (String value) => model.password = value,
                  validator: (String value) =>
                      value.isEmpty ? 'Informe a senha.' : null,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
                  child: ElevatedButton(
                    onPressed: () => _register(context, args['editing']),
                    child: const Text(
                      'Salvar',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
