import 'package:math_expressions/math_expressions.dart';

class EquationUtils {
  late Expression _expression;

  EquationUtils({required String equation}) {
    _expression = Parser().parse(_cleanEquationString(equation));
  }

  double getFlowRate(double level) {
    final ContextModel _contextModel = ContextModel();

    _contextModel.bindVariable(
      Variable('h'),
      Number(level),
    );

    return _expression.evaluate(
      EvaluationType.REAL,
      _contextModel,
    );
  }

  String _cleanEquationString(String equation) {
    if (!equation.contains('h') && !equation.contains('H')) {
      throw StateError('A equação precisa utilizar a variável "h".');
    }

    String cleanedStr = equation.replaceAll(',', '.');
    cleanedStr = cleanedStr.replaceAll('H', 'h');
    return cleanedStr.replaceAll(' ', '');
  }
}
