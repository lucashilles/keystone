import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:folly_fields/fields/email_field.dart';
import 'package:folly_fields/fields/password_field.dart';
import 'package:folly_fields/widgets/waiting_message.dart';
import 'package:keystone/screens/enterprise_list_screen.dart';
import 'package:keystone/screens/register_screen.dart';

enum LoginStatus {
  INIT,
  FORM,
  AUTH,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String name = '/';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StreamController<LoginStatus> _controller =
      StreamController<LoginStatus>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.add(LoginStatus.FORM);
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        Navigator.of(context).pushReplacementNamed(EnterpriseListScreen.name);
      } else {
        _controller.add(LoginStatus.FORM);
      }
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);

      await Navigator.of(context)
          .pushReplacementNamed(EnterpriseListScreen.name);

      return;
    } catch (e) {
      print('Login error: $e');
    }

    _controller.add(LoginStatus.FORM);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SafeArea(
        child: StreamBuilder<LoginStatus>(
          stream: _controller.stream,
          initialData: LoginStatus.INIT,
          builder: (BuildContext context, AsyncSnapshot<LoginStatus> snapshot) {
            switch (snapshot.data) {
              case LoginStatus.INIT:
                return const WaitingMessage();
              case LoginStatus.AUTH:
                return const WaitingMessage();
              case LoginStatus.FORM:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Card(
                        margin: const EdgeInsets.all(8),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              EmailField(
                                controller: _emailController,
                                label: 'E-mail',
                              ),
                              PasswordField(
                                controller: _passwordController,
                                label: 'Senha',
                                validator: (String value) =>
                                    value.isEmpty ? 'Informe a senha!' : null,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: ElevatedButton(
                                  onPressed: _login,
                                  // style: ,
                                  child: const Text(
                                    'Entrar',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: TextButton(
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed(RegisterScreen.name),
                                  child: const Text(
                                    'Nova Conta',
                                    style: TextStyle(fontSize: 22),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              default:
                return Container();
            }
          },
        ),
      ),
    );
  }
}
