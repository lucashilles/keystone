import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:folly_fields/widgets/waiting_message.dart';
import 'package:keystone/config.dart';
import 'package:keystone/models/enterprise_model.dart';
import 'package:keystone/models/measurement_model.dart';
import 'package:keystone/utils/equation_utils.dart';
import 'package:keystone/utils/report_utils.dart';
import 'package:printing/printing.dart';

class EnterpriseReportScreen extends StatefulWidget {
  const EnterpriseReportScreen({Key? key}) : super(key: key);
  static const String name = '/EnterpriseReport';

  @override
  _EnterpriseReportScreenState createState() => _EnterpriseReportScreenState();
}

class _EnterpriseReportScreenState extends State<EnterpriseReportScreen> {
  late EnterpriseModel enterprise;
  late DateTime initialDate;
  late DateTime finalDate;
  int firstYear = 9999;
  int lastYear = 0;

  Future<List<MeasurementModel>> _getData() async {
    var querySnapshot = await Config.getInstance()
        .firebaseFirestore
        .collection('enterprises')
        .doc(enterprise.id)
        .collection('measurements')
        .orderBy('date', descending: false)
        .where('date',
            isGreaterThanOrEqualTo: initialDate, isLessThanOrEqualTo: finalDate)
        .get();

    if (querySnapshot.docs.length == 0) {
      throw Exception('Nenhum registro encontrado para o período selecionado.');
    }

    return querySnapshot.docs
        .map((measure) => MeasurementModel.fromJson({
              'measure': measure.data()['measure'],
              'date': (measure.data()['date'] as Timestamp).toDate(),
            }))
        .toList();
  }

  Future<Map<int, List<double>>> _generateStats() async {
    List<MeasurementModel> measureList = await _getData();

    /// Média, Mínimo e Máximo
    Map<int, List<double>> statsByMonth = {};

    var equationUtils = EquationUtils(equation: enterprise.equation);

    for (int month in List<int>.generate(12, (i) => i + 1)) {
      var where = measureList.where((element) => element.date!.month == month);
      double sum = 0;
      double min = double.infinity;
      double max = double.negativeInfinity;

      where.forEach((element) {
        sum += element.measure;

        if (element.date!.year < firstYear) {
          firstYear = element.date!.year;
        }

        if (element.date!.year > lastYear) {
          lastYear = element.date!.year;
        }

        if (element.measure < min) {
          min = element.measure;
        }

        if (element.measure > max) {
          max = element.measure;
        }
      });

      double average = sum / where.length.toDouble();

      statsByMonth.addAll({
        month: [
          average > 0 ? equationUtils.getFlowRate(average) : 0.0,
          min != double.infinity ? equationUtils.getFlowRate(min) : 0.0,
          max != double.negativeInfinity ? equationUtils.getFlowRate(max) : 0.0,
        ]
      });
    }

    return statsByMonth;
  }

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    enterprise = args['enterprise'];
    initialDate = args['initialDate'];
    finalDate = args['finalDate'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório'),
      ),
      body: FutureBuilder<Map<int, List<double>>>(
          future: _generateStats(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Nenhum registro encontrado!'));
            }

            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return PdfPreview(
                  canChangeOrientation: false,
                  canChangePageFormat: false,
                  canDebug: false,
                  build: (format) => ReportUtils.generateReport(
                    enterprise,
                    snapshot.data!,
                    firstYear,
                    lastYear,
                  ),
                );
              }
            }

            return Center(
              child: WaitingMessage(
                message: 'Preparando relatório...',
              ),
            );
          }),
    );
  }
}
