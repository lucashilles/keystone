import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keystone/config.dart';
import 'package:keystone/models/enterprise_model.dart';
import 'package:keystone/screens/enterprise_create_screen.dart';
import 'package:keystone/screens/enterprise_report_screen.dart';
import 'package:keystone/widgets/config_report_dialog.dart';
import 'package:keystone/widgets/info_tile.dart';
import 'package:keystone/widgets/qr_reference.dart';

class InformationTab extends StatefulWidget {
  const InformationTab({Key? key, required this.enterprise, this.currentUser})
      : super(key: key);

  final EnterpriseModel enterprise;
  final User? currentUser;

  @override
  State<InformationTab> createState() => _InformationTabState();
}

class _InformationTabState extends State<InformationTab> {
  User? user;

  void _editEnterprise(BuildContext context) {
    Navigator.of(context).pushNamed(
      EnterpriseCreateScreen.name,
      arguments: {
        'editing': true,
        'enterprise': widget.enterprise,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    user = widget.currentUser ?? Config.getInstance().firebaseAuth.currentUser;
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            QrReference(
              reference: widget.enterprise.id!,
              password: widget.enterprise.password,
            ),
            InfoTile(
              title: 'Rio',
              subtitle: widget.enterprise.river,
            ),
            InfoTile(
              title: 'Bacia',
              subtitle: widget.enterprise.basin,
            ),
            InfoTile(
              title: 'Sub-bacia',
              subtitle: widget.enterprise.subBasin,
            ),
            InfoTile(
              title: 'Coordenadas',
              subtitle:
                  '${widget.enterprise.latitude}, ${widget.enterprise.longitude}',
            ),
            InfoTile(
              title: 'Distância da foz (km)',
              subtitle: widget.enterprise.distance.toString(),
            ),
            InfoTile(
              title: 'Município/UF',
              subtitle: widget.enterprise.city,
            ),
            InfoTile(
              title: 'Curva chave',
              subtitle: widget.enterprise.equation,
            ),
            Visibility(
              visible: widget.enterprise.owner == user!.uid,
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
                    return ConfigReportDialog(
                      onAccept: (initialDate, finalDate) =>
                          Navigator.of(context).popAndPushNamed(
                        EnterpriseReportScreen.name,
                        arguments: {
                          'enterprise': widget.enterprise,
                          'initialDate': initialDate,
                          'finalDate': finalDate,
                        },
                      ),
                    );
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
