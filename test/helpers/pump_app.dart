import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    Route<dynamic>? Function(RouteSettings)? onGenerateRoute,
  }) async {
    return pumpWidget(
      MaterialApp(
        onGenerateRoute: onGenerateRoute,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const <Locale>[
          Locale('pt', 'BR'),
        ],
        home: widget,
      ),
    );
  }
}
