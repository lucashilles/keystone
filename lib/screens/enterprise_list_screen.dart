import 'package:flutter/material.dart';

class EnterpriseListScreen extends StatefulWidget {
  static const String name = '/EnterpriseList';

  @override
  _EnterpriseListScreenState createState() => _EnterpriseListScreenState();
}

class _EnterpriseListScreenState extends State<EnterpriseListScreen> {
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
