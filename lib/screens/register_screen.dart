import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folly_fields/fields/cpj_cnpj_field.dart';
import 'package:folly_fields/fields/dropdown_field.dart';
import 'package:folly_fields/fields/email_field.dart';
import 'package:folly_fields/fields/password_field.dart';
import 'package:folly_fields/fields/string_field.dart';
import 'package:keystone/config.dart';
import 'package:keystone/models/user_model.dart';
import 'package:keystone/models/user_type_model.dart';
import 'package:http/http.dart' as http;

import 'enterprise_list_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String name = '/Register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordVerifyController =
      TextEditingController();

  UserModel model = UserModel();

  void _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Passa os dados dos campos para a model
      _formKey.currentState!.save();

      http.Response response = await http.post(
        Uri.parse('http://localhost:8080/api/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(model.toMap()),
      );

      if (response.statusCode == 204) {
        String encode =
            base64.encode('${model.email}:${model.password}'.codeUnits);

        Config().authorization = encode;

        await Navigator.of(context)
            .pushReplacementNamed(EnterpriseListScreen.name);

        return;
      } else {
        // Tela de erro
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                StringField(
                  label: 'Nome',
                  initialValue: model.name,
                  onSaved: (String value) => model.name = value,
                  validator: (String value) =>
                      value.isEmpty ? 'Informe o seu nome.' : null,
                ),
                EmailField(
                  label: 'E-mail',
                  initialValue: model.email,
                  onSaved: (String value) => model.email = value,
                ),
                CpfCnpjField(
                  label: 'CPF ou CNPJ',
                  initialValue: model.cpfcnpj,
                  onSaved: (String? newValue) => model.cpfcnpj = newValue!,
                  required: true,
                ),
                DropdownField<UserType>(
                  label: 'Tipo de usuário',
                  initialValue: model.userType.value,
                  items: UserTypeModel.getItems(),
                  onChanged: (UserType? value) {
                    setState(() {
                      model.userType.value = value!;
                    });
                  },
                  onSaved: (UserType? newValue) =>
                      model.userType.value = newValue!,
                  validator: (UserType? value) =>
                      value == null || value == UserType.UNKNOWN
                          ? 'Selecione uma opção.'
                          : null,
                ),
                Visibility(
                  visible: model.userType.value == UserType.ENGINEER,
                  child: StringField(
                    enabled: model.userType.value == UserType.ENGINEER,
                    label: 'CREA',
                    initialValue: model.professionalRegister,
                    onSaved: (String value) =>
                        model.professionalRegister = value,
                    validator: (String value) =>
                        value.isEmpty ? 'Informe o seu registro.' : null,
                  ),
                ),
                Visibility(
                  visible: model.userType.value == UserType.ENGINEER,
                  child: StringField(
                    enabled: model.userType.value == UserType.ENGINEER,
                    label: 'Registro SEMA',
                    initialValue: model.semaRegister,
                    onSaved: (String value) => model.semaRegister = value,
                    validator: (String value) =>
                        value.isEmpty ? 'Informe o seu registro.' : null,
                  ),
                ),
                PasswordField(
                  label: 'Senha',
                  controller: _passwordController,
                  onSaved: (String value) => model.password = value,
                  validator: (String value) =>
                      value.isEmpty ? 'Informe a senha' : null,
                ),
                PasswordField(
                  label: 'Confirme a senha',
                  controller: _passwordVerifyController,
                  validator: (String value) =>
                      value.isEmpty ? 'Informe a senha' : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ElevatedButton(
                    onPressed: () => _register(context),
                    child: Text('REGISTRAR'),
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

// String cpfcnpj = '';
// String email = '';
// String name = '';
// String registerNumber = '';
// UserTypeModel type;
