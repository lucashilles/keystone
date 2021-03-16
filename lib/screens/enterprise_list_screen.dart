import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:keystone/config.dart';

class EnterpriseListScreen extends StatefulWidget {
  static const String name = '/EnterpriseList';

  @override
  _EnterpriseListScreenState createState() => _EnterpriseListScreenState();
}

class _EnterpriseListScreenState extends State<EnterpriseListScreen> {
  @override
  void initState() async {
    super.initState();

    http.Response response = await http.get(
      Uri.parse('http://localhost:8080/api/user'),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: 'Basic ${Config().authorization}'
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Empreendimentos'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Teste'),
            subtitle: Text('Teste'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
