import 'package:aurb/authentication/screens/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String title = 'AURB';

  static const MaterialColor customGrayColor = MaterialColor(
    0xFF666666, // Replace with your desired primary gray color
    <int, Color>{
      50: Color(0xFFE0E0E0), // Lightest shade
      100: Color(0xFFE0E0E0),
      200: Color(0xFFB3B3B3),
      300: Color(0xFFB3B3B3),
      400: Color(0xFFB3B3B3), // Primary gray color
      500: Color(0xFFB3B3B3),
      600: Color(0xFFB3B3B3),
      700: Color(0xFFB3B3B3),
      800: Color(0xFFB3B3B3),
      900: Color(0xFFB3B3B3), // Darkest shade
    },
  );

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: customGrayColor),
        home: const WelcomeScreen(),
      );
}
