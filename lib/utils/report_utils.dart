import 'dart:typed_data';
import 'package:folly_fields/validators/cpf_cnpj_validator.dart';
import 'package:keystone/models/enterprise_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

class ReportUtils {
  static Future<Uint8List> generateReport(EnterpriseModel enterprise,
      Map<int, List<double>> stats, int firstYear, int lastYear) {
    List<double> averages = stats.values.map((e) => e[0]).toList();
    List<double> lowests = stats.values.map((e) => e[1]).toList();
    List<double> highests = stats.values.map((e) => e[2]).toList();

    double max = highests.reduce((v, e) => e > v ? e : v);

    const months = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez'
    ];

    final document = pw.Document();

    final chart = pw.Chart(
      bottom: pw.ChartLegend(
          direction: pw.Axis.horizontal, position: pw.Alignment.center),
      grid: pw.CartesianGrid(
        xAxis: pw.FixedAxis(
          List<int>.generate(12, (i) => i),
          buildLabel: (v) =>
              pw.Text(DateFormat('MMM').format(DateTime(0, v.toInt() + 1))),
        ),
        yAxis: pw.FixedAxis(
          List<double>.generate(
              6,
              (i) => double.parse((((i.toDouble()) / 5.0) * max.ceil())
                  .toStringAsPrecision(2))),
          divisions: false,
        ),
      ),
      datasets: [
        pw.LineDataSet(
          legend: 'Média',
          drawSurface: false,
          isCurved: true,
          drawPoints: false,
          color: PdfColors.blue,
          data: List<pw.LineChartValue>.generate(
            stats.length,
            (i) {
              final v = stats[i + 1]![0];
              return pw.LineChartValue(i.toDouble(), v.toDouble());
            },
          ),
        ),
        pw.LineDataSet(
          legend: 'Mínima',
          drawSurface: false,
          isCurved: true,
          drawPoints: false,
          color: PdfColors.red,
          data: List<pw.LineChartValue>.generate(
            stats.length,
            (i) {
              final v = stats[i + 1]![1];
              return pw.LineChartValue(i.toDouble(), v.toDouble());
            },
          ),
        ),
        pw.LineDataSet(
          legend: 'Máxima',
          drawSurface: false,
          isCurved: true,
          drawPoints: false,
          color: PdfColors.green,
          data: List<pw.LineChartValue>.generate(
            stats.length,
            (i) {
              final v = stats[i + 1]![2];
              return pw.LineChartValue(i.toDouble(), v.toDouble());
            },
          ),
        ),
      ],
    );

    final table = pw.Table.fromTextArray(
      cellStyle: pw.TextStyle(fontSize: 3.25 * PdfPageFormat.mm),
      headers: ['', ...months, 'Méd'],
      data: [
        [
          'Méd',
          ...averages.map((e) => e.toStringAsFixed(2)).toList(),
          (averages.reduce((v, e) => v + e) / 12.0).toStringAsFixed(2),
        ],
        [
          'Mín',
          ...lowests.map((e) => e.toStringAsFixed(2)).toList(),
          (lowests.reduce((v, e) => v + e) / 12.0).toStringAsFixed(2),
        ],
        [
          'Máx',
          ...highests.map((e) => e.toStringAsFixed(2)).toList(),
          (highests.reduce((v, e) => v + e) / 12.0).toStringAsFixed(2),
        ],
      ],
      headerStyle: pw.TextStyle(
        fontWeight: pw.FontWeight.bold,
      ),
      cellAlignment: pw.Alignment.center,
    );

    document.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20 * PdfPageFormat.mm),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Text('FICHA TÉCNICA', textAlign: pw.TextAlign.center),
            pw.SizedBox(height: 2 * PdfPageFormat.mm),
            pw.Container(
              padding: pw.EdgeInsets.all(1.1 * PdfPageFormat.mm),
              child: pw.Row(
                children: [
                  pw.Text('CLIENTE: ',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text(
                      '${enterprise.clientName} - ${CpfCnpjValidator().format(enterprise.clientCpfCnpj)}'),
                ],
              ),
              foregroundDecoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black),
              ),
            ),
            pw.Row(
              mainAxisSize: pw.MainAxisSize.max,
              children: [
                _Box(
                  child: _Info(title: 'RIO', content: '${enterprise.river}'),
                ),
                _Box(
                  child: _Info(
                      title: 'SUB-BACIA', content: '${enterprise.subBasin}'),
                ),
                _Box(
                  child: _Info(title: 'BACIA', content: '${enterprise.basin}'),
                ),
              ],
            ),
            pw.Row(
              mainAxisSize: pw.MainAxisSize.max,
              children: [
                _Box(
                  child: _Info(
                      title: 'COORDENADAS',
                      content:
                          '${enterprise.latitude}, ${enterprise.longitude}'),
                ),
                _Box(
                  child: _Info(
                      title: 'DISTÂNCIA DA FOZ',
                      content: '${enterprise.distance} km'),
                ),
              ],
            ),
            pw.SizedBox(height: 10 * PdfPageFormat.mm),
            pw.Text('TABELA 1 - VAZÃO MÉDIA MENSAL (m³/s)',
                textAlign: pw.TextAlign.center),
            pw.SizedBox(height: 2 * PdfPageFormat.mm),
            pw.Container(
              padding: pw.EdgeInsets.all(1.1 * PdfPageFormat.mm),
              child: pw.Text('Período: $firstYear à $lastYear',
                  textAlign: pw.TextAlign.center),
              foregroundDecoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black),
              ),
            ),
            table,
            pw.SizedBox(height: 10 * PdfPageFormat.mm),
            pw.Text('FIGURA 1 - MÉDIAS, MÍNIMAS E MÁXIMAS (m³/s)',
                textAlign: pw.TextAlign.center),
            pw.SizedBox(height: 2 * PdfPageFormat.mm),
            pw.SizedBox(child: chart, height: 55 * PdfPageFormat.mm),
          ],
        ),
      ),
    );

    return document.save();
  }

  static pw.Widget _Box({required pw.Widget child}) {
    return pw.Expanded(
      child: pw.Container(
        child: child,
        padding: pw.EdgeInsets.all(1.1 * PdfPageFormat.mm),
        foregroundDecoration: pw.BoxDecoration(
          border: pw.Border.all(color: PdfColors.black),
        ),
      ),
    );
  }

  static pw.Widget _Info({required String title, required String content}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.Padding(
            padding: pw.EdgeInsets.fromLTRB(
              5 * PdfPageFormat.mm,
              0.5 * PdfPageFormat.mm,
              0,
              0,
            ),
            child: pw.Text(content)),
      ],
    );
  }
}
