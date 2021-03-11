import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:folly_fields/fields/cpj_cnpj_field.dart';
import 'package:folly_fields/fields/dropdown_field.dart';
import 'package:folly_fields/fields/email_field.dart';
import 'package:folly_fields/fields/password_field.dart';
import 'package:folly_fields/fields/string_field.dart';
import 'package:keystone/models/user_model.dart';
import 'package:keystone/models/user_type_model.dart';

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

      try {
        // Tenta criar o usuário
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: model.email, password: _passwordController.text);

        // TODO: Salva usuário no firestore

        // TODO: Navega para a tela de empreendimentos

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.toString()),
          ));
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
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
                  initialValue: model.type.value,
                  items: UserTypeModel.getItems(),
                  onChanged: (UserType? value) {
                    setState(() {
                      model.type.value = value!;
                    });
                  },
                  onSaved: (UserType? newValue) => model.type.value = newValue!,
                  validator: (UserType? value) =>
                      value == null || value == UserType.UNKNOWN
                          ? 'Selecione uma opção.'
                          : null,
                ),
                Visibility(
                  visible: model.type.value == UserType.ENGINEER,
                  child: StringField(
                    enabled: model.type.value == UserType.ENGINEER,
                    label: 'CREA',
                    initialValue: model.registerNumber,
                    onSaved: (String value) => model.registerNumber = value,
                    validator: (String value) =>
                        value.isEmpty ? 'Informe o seu registro.' : null,
                  ),
                ),
                PasswordField(
                  label: 'Senha',
                  controller: _passwordController,
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
