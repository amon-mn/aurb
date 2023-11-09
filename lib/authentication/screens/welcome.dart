import 'package:aurb/authentication/screens/login_screen.dart';
import 'package:aurb/authentication/screens/register_screen.dart';
import 'package:aurb/components/card.dart';
import 'package:aurb/components/my_text_button.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 69, 69, 69),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 148),
                const Text(
                  'AURB',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 46,
                      color: Colors.white),
                ),
                const SizedBox(height: 18),
                Container(
                  width: 184,
                  alignment: Alignment.center,
                  child: const Column(
                    children: [
                      Text(
                        'Auditorias em',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      Text(
                        'Mobilidade Urbana',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 74),
                MyCard(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height - 264,
                  child: Column(
                    children: [
                      Container(
                        width: 300,
                        height: 300,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 202, 202, 202),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(200),
                              topRight: Radius.circular(200),
                              bottomRight: Radius.circular(200)),
                        ),
                        padding: const EdgeInsets.all(24.0),
                        child: Image(
                          image: AssetImage('lib/assets/traffic_lane.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 16),
                      MyTextButton(
                        onTap: () {
                          // Use o Navigator para navegar para a página home.dart
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        text: 'Entrar',
                        textSize: 36,
                      ),
                      MyTextButton(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterScreen()));
                        },
                        text: 'Cadastrar',
                        textSize: 16,
                      ),
                      SizedBox(height: 16),
                      MyTextButton(
                        onTap: () {},
                        text: 'Notificação Anônima',
                        textSize: 16,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
