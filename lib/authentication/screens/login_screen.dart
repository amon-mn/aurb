import 'package:aurb/components/card.dart';
import 'package:aurb/components/my_button.dart';
import 'package:aurb/components/my_textfield.dart';
import 'package:aurb/components/square_tile.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
                const SizedBox(height: 64),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 120,
                            child: Text(
                              'AURB',
                              style: TextStyle(
                                fontSize: 46,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 182,
                            child: Text(
                              'Auditorias em Mobilidade Urbana',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 232),
                MyCard(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height - 364,
                  child: Column(
                    children: [
                      Form(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 16),
                            Container(
                              alignment: Alignment.center,
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[900],
                                ),
                              ),
                            ),
                            SizedBox(height: 24),
                            MyTextFieldWrapper(
                              hintText: 'Email',
                              controller: _emailController,
                              obscureText: false,
                            ),
                            SizedBox(height: 16),
                            MyTextFieldWrapper(
                              hintText: 'Senha',
                              controller: _passwordController,
                              obscureText: false,
                            ),
                            SizedBox(height: 16),
                            MyButton(
                                colorButton:
                                    const Color.fromARGB(255, 69, 69, 69),
                                paddingButton: 12,
                                onTap: () {},
                                textButton: 'Entrar',
                                textSize: 18),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: const Color.fromARGB(255, 69, 69, 69),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(
                                'Ou continue com',
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 69, 69, 69),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 0.5,
                                color: const Color.fromARGB(255, 69, 69, 69),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // google / facebook / yahoo sign in buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // google button
                          GestureDetector(
                            onTap: () {},
                            child: const SquareTite(
                                content: 'lib/assets/google.png'),
                          ),

                          const SizedBox(width: 15),

                          // facebook button
                          GestureDetector(
                            onTap: () {},
                            child: const SquareTite(
                                content: 'lib/assets/facebook.png'),
                          ),

                          const SizedBox(width: 15),

                          // yahoo button
                          const SquareTite(content: 'lib/assets/yahoo.png'),
                        ],
                      )
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
