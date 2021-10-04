import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:folly_fields/fields/string_field.dart';
import 'package:folly_fields/widgets/waiting_message.dart';
import 'package:keystone/screens/enterprise_list_screen.dart';
import 'package:keystone/widgets/info_tile.dart';

class SearchEnterpriseDialog extends StatefulWidget {
  const SearchEnterpriseDialog({Key? key, required this.enterprisePath})
      : super(key: key);

  @override
  _SearchEnterpriseDialogState createState() =>
      new _SearchEnterpriseDialogState();

  final String enterprisePath;
}

class _SearchEnterpriseDialogState extends State<SearchEnterpriseDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget content = IntrinsicHeight(
    child: WaitingMessage(
      message: 'Buscando Empreendimento',
    ),
  );

  List<Widget> actions = [];

  Future<void> _saveEnterprise() async {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get();

    var enterpriseList = userSnapshot.data()!['enterprises'] as List<dynamic>;
    if (!enterpriseList.contains(widget.enterprisePath)) {
      enterpriseList.add(widget.enterprisePath);
    }

    userSnapshot.reference.update({'enterprises': enterpriseList});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection('enterprises')
          .doc(widget.enterprisePath)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data!.exists && snapshot.hasData) {
            content = SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InfoTile(
                      title: 'Nome',
                      subtitle: snapshot.data!['clientName'],
                    ),
                    InfoTile(
                      title: 'Município/UF',
                      subtitle: snapshot.data!['city'],
                    ),
                    InfoTile(
                      title: 'Rio',
                      subtitle: snapshot.data!['river'],
                    ),
                    InfoTile(
                      title: 'Coordenadas',
                      subtitle:
                          '${snapshot.data!['latitude']}, ${snapshot.data!['longitude']}',
                    ),
                    StringField(
                      label: 'Senha',
                      validator: (String value) {
                        if (value != snapshot.data!['password']) {
                          return 'Senha incorreta!';
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),
            );
            actions = <Widget>[
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text('Adicionar'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _saveEnterprise();
                    Navigator.popUntil(context,
                        ModalRoute.withName(EnterpriseListScreen.name));
                  } else {}
                },
              ),
            ];
          } else {
            content = Text(
              'Não foi possível encontrar o empreendimento.',
            );
            actions = <Widget>[
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ];
          }
        }

        return AlertDialog(
          key: GlobalKey(),
          title: Text('Empreendimento'),
          content: content,
          actions: actions,
        );
      },
    );
  }
}
