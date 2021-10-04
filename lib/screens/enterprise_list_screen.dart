import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:folly_fields/widgets/waiting_message.dart';
import 'package:keystone/models/enterprise_model.dart';
import 'package:keystone/models/user_model.dart';
import 'package:keystone/screens/enterprise_create_screen.dart';
import 'package:keystone/screens/enterprise_screen.dart';
import 'package:keystone/widgets/remove_enterprise_dialog.dart';

import 'enterprise_from_code_screen.dart';

class EnterpriseListScreen extends StatefulWidget {
  const EnterpriseListScreen({Key? key}) : super(key: key);
  static const String name = '/EnterpriseList';

  @override
  _EnterpriseListScreenState createState() => _EnterpriseListScreenState();
}

class _EnterpriseListScreenState extends State<EnterpriseListScreen> {
  late UserModel user;

  final Stream<DocumentSnapshot<Map<String, dynamic>>> _usersStream =
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .snapshots();

  Future<void> _removeEnterprise(EnterpriseModel enterprise) async {
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .get();

    var enterpriseList = userSnapshot.data()!['enterprises'] as List<dynamic>;
    enterpriseList.remove(enterprise.id);

    await userSnapshot.reference.update({'enterprises': enterpriseList});

    if (enterprise.owner == FirebaseAuth.instance.currentUser?.uid) {
      await FirebaseFirestore.instance
          .collection('enterprises')
          .doc(enterprise.id)
          .update({'active': false});
    }
  }

  List<Widget> _getUserEnterprises(List<dynamic> array) {
    List<Widget> enterpriseTiles = [];

    for (var doc in array) {
      var enterprise = EnterpriseModel.fromJson(doc.data());
      enterprise.id = doc.id;

      if (!enterprise.active) {
        _removeEnterprise(enterprise);
        continue;
      }

      var listTile = ListTile(
        title: Text('${enterprise.clientName}'),
        subtitle: Text('${enterprise.city}'),
        onTap: () {
          Navigator.of(context).pushNamed(EnterpriseScreen.name,
              arguments: {'enterprise': enterprise});
        },
        onLongPress: () async {
          showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => RemoveEnterpriseDialog(
              enterprise: enterprise,
              onOk: _removeEnterprise,
            ),
          );
        },
      );

      enterpriseTiles.add(listTile);
    }

    return enterpriseTiles;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Empreendimentos'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: _usersStream,
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasError) {
              return const Text("Erro ao carregar usuário");
            }

            if (snapshot.hasData) {
              return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection('enterprises')
                    .where(
                      '__name__',
                      whereIn: snapshot.data!.data()!['enterprises'],
                    )
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Erro ao carregar empreendimentos");
                  }

                  if (snapshot.hasData) {
                    return Container(
                      color: Colors.white,
                      child: ListView(
                        children: _getUserEnterprises(snapshot.data!.docs),
                      ),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: Text('Nenhum empreendimento encontrado.'),
                    );
                  }

                  return WaitingMessage(
                    message: 'Carregando empreendimentos...',
                  );
                },
              );
            }

            return WaitingMessage(
              message: 'Carregando dados do usuário...',
            );
          }),
      floatingActionButton: SpeedDial(
        closeManually: false,
        activeForegroundColor: Colors.white,
        activeBackgroundColor: Colors.red,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        icon: Icons.add,
        activeIcon: Icons.close,
        tooltip: 'Adicionar Empreendimento',
        renderOverlay: false,
        children: <SpeedDialChild>[
          SpeedDialChild(
            child: const Icon(Icons.edit),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            label: 'Cadastrar',
            onTap: () =>
                Navigator.of(context).pushNamed(EnterpriseCreateScreen.name),
          ),
          SpeedDialChild(
            child: const Icon(Icons.qr_code),
            backgroundColor: Colors.amber,
            // foregroundColor: Colors.white,
            label: 'Código QR',
            onTap: () =>
                Navigator.of(context).pushNamed(EnterpriseFromCodeScreen.name),
          ),
        ],
      ),
    );
  }
}
