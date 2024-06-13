import 'dart:async';

import 'package:aurb/authentication/screens/welcome.dart';
import 'package:aurb/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_config/flutter_config.dart';

import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        home: const AuthPage(),
      );
}

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            final user = snapshot.data!;
            return HomeScreenNavigator(user: user);
          } else {
            return const WelcomeScreen();
          }
        }
      },
    );
  }
}

class HomeScreenNavigator extends StatelessWidget {
  final User user;

  const HomeScreenNavigator({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
        (route) => false,
      );
    });

    // Retorna um contêiner vazio, pois a navegação ocorrerá fora do fluxo de construção do widget
    return Container();
  }
}
