// import 'package:final_project/MapPage.dart';
import 'package:final_project/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:final_project/map/MapPage.dart';
import 'package:final_project/map/Map.dart';
import 'LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
//
// Future<void> main() async {
//   //initialize firebase database
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform
//   );
//   runApp(const MyApp());
// }


Future<void> main()async {
  //initialize firebase database
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('language') ?? 'en'; // Anglais

  runApp(MyApp(languageCode));
}

class MyApp extends StatelessWidget {
  final String initialLanguageCode;
  MyApp(this.initialLanguageCode);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
      builder: FlutterI18n.rootAppBuilder(),
      localizationsDelegates: [
        FlutterI18nDelegate(
          translationLoader: FileTranslationLoader(
            basePath: 'assets/i18n',
            fallbackFile: 'en',
          ),
        ),
      ],
      supportedLocales: [Locale('en'), Locale('fr')],
      locale: Locale(initialLanguageCode),
    );
  }
}

