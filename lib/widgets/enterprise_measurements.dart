import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keystone/models/enterprise_model.dart';
import 'package:keystone/utils/equation_utils.dart';
import 'package:math_expressions/math_expressions.dart';

class EnterpriseMeasurements extends StatefulWidget {
  EnterpriseMeasurements({Key? key, required this.enterprise})
      : super(key: key);

  final EnterpriseModel enterprise;

  @override
  State<EnterpriseMeasurements> createState() => _EnterpriseMeasurementsState();
}

class _EnterpriseMeasurementsState extends State<EnterpriseMeasurements> {
  late EquationUtils equationUtils;
  late User currentUser;

  @override
  void initState() {
    super.initState();
    equationUtils = EquationUtils(equation: widget.enterprise.equation);
    currentUser = FirebaseAuth.instance.currentUser!;
  }

  void _deletMeasureDialog(
      QueryDocumentSnapshot<Map<String, dynamic>> measure) async {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          key: GlobalKey(),
          title: Text('Excluir medição?'),
          content: Text('Esta ação não poderá ser desfeita!'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Excluir'),
              onPressed: () async {
                await measure.reference.delete();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('enterprises')
          .doc(widget.enterprise.id!)
          .collection('measurements')
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.hasError) {
          return const Text("Erro ao carregar usuário");
        }

        if (snapshot.hasData) {
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Nenhuma medição encontrada.'));
          }

          List<Widget> tiles = [];

          for (var measure in snapshot.data!.docs) {
            double flowRate =
                equationUtils.getFlowRate(measure.data()['measure']);

            tiles.add(
              ListTile(
                title: Text(
                    'Nível: ${measure.data()['measure']} m - Vazão: ${flowRate.toStringAsFixed(3)} m³/s'),
                subtitle: Text(
                    '${(measure.data()['date'] as Timestamp).toDate().toString()}'),
                trailing: measure.data()['user'] == currentUser.uid
                    ? Icon(Icons.delete)
                    : null,
                onTap: () {
                  if (measure.data()['user'] == currentUser.uid ||
                      currentUser.uid == widget.enterprise.owner) {
                    _deletMeasureDialog(measure);
                  }
                },
              ),
            );
          }

          return ListView(
            children: tiles,
          );
        }

        return Center(child: Text('Nenhuma medição encontrada.'));
      },
    );
  }
}
