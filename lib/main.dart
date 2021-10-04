import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:folly_fields/folly_fields.dart';
import 'package:keystone/config.dart';
import 'package:keystone/screens/enterprise_create_screen.dart';
import 'package:keystone/screens/enterprise_report_screen.dart';
import 'package:keystone/screens/enterprise_screen.dart';
import 'package:keystone/screens/enterprise_from_code_screen.dart';
import 'package:keystone/screens/enterprise_list_screen.dart';
import 'package:keystone/screens/home_screen.dart';
import 'package:keystone/screens/register_screen.dart';

void main() async {
  bool debug = false;
  assert(debug = true, 'Enable debug');

  WidgetsFlutterBinding.ensureInitialized();
  FollyFields.start(Config(), debug: debug);

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keystone',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: HomeScreen.name,
      routes: <String, Widget Function(BuildContext context)>{
        HomeScreen.name: (BuildContext context) => const HomeScreen(),
        RegisterScreen.name: (BuildContext context) => const RegisterScreen(),
        EnterpriseListScreen.name: (BuildContext context) =>
            const EnterpriseListScreen(),
        EnterpriseCreateScreen.name: (BuildContext context) =>
            const EnterpriseCreateScreen(),
        EnterpriseScreen.name: (BuildContext context) =>
            const EnterpriseScreen(),
        EnterpriseFromCodeScreen.name: (BuildContext context) =>
            const EnterpriseFromCodeScreen(),
        EnterpriseReportScreen.name: (BuildContext context) =>
            const EnterpriseReportScreen(),
      },
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('pt', 'BR'),
      ],
    );
  }
}
