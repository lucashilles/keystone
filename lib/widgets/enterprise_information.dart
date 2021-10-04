import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keystone/models/enterprise_model.dart';
import 'package:keystone/screens/enterprise_create_screen.dart';
import 'package:keystone/widgets/config_report_dialog.dart';
import 'package:keystone/widgets/info_tile.dart';
import 'package:keystone/widgets/qr_reference.dart';

class EnterpriseInformation extends StatelessWidget {
  const EnterpriseInformation({Key? key, required this.enterprise})
      : super(key: key);

  final EnterpriseModel enterprise;

  void _editEnterprise(BuildContext context) {
    Navigator.of(context).pushNamed(
      EnterpriseCreateScreen.name,
      arguments: {
        'editing': true,
        'enterprise': enterprise,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            QrReference(
              reference: enterprise.id!,
              password: enterprise.password,
            ),
            InfoTile(
              title: 'Rio',
              subtitle: enterprise.river,
            ),
            InfoTile(
              title: 'Bacia',
              subtitle: enterprise.basin,
            ),
            InfoTile(
              title: 'Sub-bacia',
              subtitle: enterprise.subBasin,
            ),
            InfoTile(
              title: 'Coordenadas',
              subtitle: '${enterprise.latitude}, ${enterprise.longitude}',
            ),
            InfoTile(
              title: 'Distância da foz (km)',
              subtitle: enterprise.distance.toString(),
            ),
            InfoTile(
              title: 'Município/UF',
              subtitle: enterprise.city,
            ),
            InfoTile(
              title: 'Curva chave',
              subtitle: enterprise.equation,
            ),
            Visibility(
              visible:
                  enterprise.owner == FirebaseAuth.instance.currentUser?.uid,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: ElevatedButton(
                  onPressed: () => _editEnterprise(context),
                  child: const Text('EDITAR'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) {
                    return ConfigReportDialog(enterprise: enterprise);
                  },
                ),
                child: const Text('RELATÓRIO'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
