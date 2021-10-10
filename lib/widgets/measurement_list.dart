import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:keystone/config.dart';
import 'package:keystone/models/enterprise_model.dart';
import 'package:keystone/utils/equation_utils.dart';
import 'package:keystone/utils/measurement_utils.dart';
import 'package:keystone/widgets/measure_tile.dart';

class MeasurementList extends StatefulWidget {
  MeasurementList({Key? key, required this.enterprise}) : super(key: key);

  final EnterpriseModel enterprise;

  @override
  State<MeasurementList> createState() => _MeasurementListState();
}

class _MeasurementListState extends State<MeasurementList> {
  late EquationUtils equationUtils;
  late User currentUser;

  @override
  void initState() {
    super.initState();
    equationUtils = EquationUtils(equation: widget.enterprise.equation);
    currentUser = Config.getInstance().firebaseAuth.currentUser!;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Config.getInstance()
          .firebaseFirestore
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
              MeasureTile(
                canRemove: (measure.data()['user'] == currentUser.uid ||
                    currentUser.uid == widget.enterprise.owner),
                date: (measure.data()['date'] as Timestamp).toDate(),
                flowRate: flowRate,
                level: measure.data()['measure'],
                onRemove: () => MeasurementUtils.removeMeasure(measure),
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
