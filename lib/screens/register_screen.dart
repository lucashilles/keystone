import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:folly_fields/fields/cpj_cnpj_field.dart';
import 'package:folly_fields/fields/email_field.dart';
import 'package:folly_fields/fields/password_field.dart';
import 'package:folly_fields/fields/string_field.dart';
import 'package:keystone/config.dart';
import 'package:keystone/models/user_model.dart';

import 'package:keystone/screens/enterprise_list_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
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

  Future<void> _register(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      // Passa os dados dos campos para a model
      _formKey.currentState!.save();

      try {
        UserCredential userCredential = await Config.getInstance()
            .firebaseAuth
            .createUserWithEmailAndPassword(
                email: model.email, password: model.password);

        CollectionReference<Map<String, dynamic>> users =
            Config.getInstance().firebaseFirestore.collection('users');

        await users
            .doc(userCredential.user?.uid)
            .set(model.toMap())
            .then((void value) => print('User Added'))
            .catchError((dynamic error) => print('Failed to add user: $error'));

        await Navigator.of(context)
            .pushReplacementNamed(EnterpriseListScreen.name);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Senha muito fraca!')));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('E-mail já utilizado!')));
        }
      } catch (e) {
        print('Register error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova conta'),
      ),
      body: Form(
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
                  onSaved: (String? newValue) => model.cpfcnpj = newValue!),
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
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ElevatedButton(
                  onPressed: () => _register(context),
                  child: const Text('REGISTRAR'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
