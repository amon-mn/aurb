import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:aurb/authentication/screens/welcome.dart';
import 'package:aurb/screens/adm_home.dart';
import 'package:aurb/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:provider/provider.dart'; // Add this import
import 'package:aurb/firestore_notifications/models/notification_location_controller.dart'; // Adjust the import path as needed
import 'firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(
      fileName: ".env"); // Certifique-se de que o nome do arquivo está correto
  await FlutterConfig.loadEnvVariables();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => NotificationLocationController(),
      child: const MyApp(),
    ),
  );
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

  const MyApp({Key? key});

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

            // Verifica o tipo de usuário imediatamente após a autenticação
            getUserType(user.uid).then((userType) {
              if (userType == 'ADM') {
                // Redirecionar para a tela de super usuário (AdmPage).
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdmPage(
                      user: FirebaseAuth.instance.currentUser!,
                    ),
                  ),
                );
              } else if (userType == 'User') {
                // Redirecionar para a tela regular do usuário (HomePage).
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(user: user),
                  ),
                );
              } else {
                // Se o tipo de usuário não for encontrado, redirecione para a página inicial
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(user: user),
                  ),
                );
              }
            });

            return Container(); // Você pode remover este Container
          } else {
            return const WelcomeScreen();
          }
        }
      },
    );
  }

  Future<String> getUserType(String userId) async {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic> userData =
          userSnapshot.data() as Map<String, dynamic>;
      return userData['userType'];
    } else {
      // Se o documento não existir, retorne um valor padrão
      return 'default';
    }
  }
}
