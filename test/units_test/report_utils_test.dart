import 'package:keystone/models/enterprise_model.dart';
import 'package:keystone/utils/report_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Report Utils', () {
    var enterpriseModel = EnterpriseModel.fromJson({
      'clientName': 'Josnei',
      'city': 'Sinop/MT',
      'river': 'Teles Pires',
      'latitude': '55.11',
      'longitude': '12.69',
      'distance': 0.5,
      'id': '1a2b3c4d5e6f7g8h9i',
      'owner': 'Fake user',
      'password': '1234',
      'active': true,
    });

    Map<int, List<double>> stats = {
      1: [4, 8, 7],
      2: [3, 6, 4],
      3: [2, 4, 3],
      4: [3, 5, 4],
      5: [6, 6, 7],
      6: [7, 9, 8],
      7: [9, 9, 8],
      8: [8, 8, 5],
      9: [5, 7, 6],
      10: [3, 5, 4],
      11: [2, 1, 5],
      12: [1, 2, 3],
    };

    test('Report Utils', () async {
      var generateReport =
          await ReportUtils.generateReport(enterpriseModel, stats, 2019, 2021);

      expect(generateReport.length, 4164);
    });
  });
}
