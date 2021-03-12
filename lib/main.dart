import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:folly_fields/folly_fields.dart';
import 'package:keystone/config.dart';
import 'package:keystone/screens/enterprise_list_screen.dart';
import 'package:keystone/screens/home_screen.dart';
import 'package:keystone/screens/register_screen.dart';

void main() async {
  bool debug = false;

  assert(debug = true);

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  FollyFields.start(Config(), debug: debug);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: HomeScreen.name,
      routes: <String, Widget Function(BuildContext context)>{
        HomeScreen.name: (BuildContext context) => HomeScreen(),
        RegisterScreen.name: (BuildContext context) => RegisterScreen(),
        EnterpriseListScreen.name: (BuildContext context) =>
            EnterpriseListScreen(),
      },
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('pt', 'BR'),
      ],
    );
  }
}
