import 'package:keystone/utils/equation_utils.dart';
import 'package:test/test.dart';

void main() {
  group('Equation Utils', () {
    test('Happy day', () {
      final equationUtils = EquationUtils(equation: 'h+5');
      expect(equationUtils.getFlowRate(1), 6);
    });

    test('Equation string cleanup', () {
      final equationUtils = EquationUtils(equation: '0,17 * H ^2 + 5');
      expect(equationUtils.getFlowRate(1), 5.17);
    });

    test('Wrong variable', () {
      expect(() => EquationUtils(equation: '0,28 * X ^4 + 2.15'),
          throwsStateError);
    });
  });
}
