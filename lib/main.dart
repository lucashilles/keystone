import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:folly_fields/folly_fields.dart';
import 'package:keystone/config.dart';
import 'package:keystone/screens/home_screen.dart';

void main() {
  bool debug = false;

  assert(debug = true);

  WidgetsFlutterBinding.ensureInitialized();

  FollyFields.start(Config(), debug: debug);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: Firebase.initializeApp(),
      builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
            home: Center(
              child: Text('Ocorreu um erro...'),
            ),
          );
        }

        if (snapshot.hasData) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: HomeScreen.name,
            routes: <String, Widget Function(BuildContext context)>{
              HomeScreen.name: (BuildContext context) => HomeScreen(),
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

        return Container(child: Text('Carregando...'));
      },
    );
  }
}
