import 'package:aurb/components/card.dart';
import 'package:aurb/components/my_button.dart';
import 'package:aurb/components/my_textfield.dart';
import 'package:aurb/components/show_snackbar.dart';
import 'package:aurb/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aurb/authentication/components/sign_with_google.dart'; // Importe o widget do botão de login com o Google
import 'package:aurb/authentication/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  AuthService authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber,
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 160,
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
                  height: MediaQuery.sizeOf(context).height - 350,
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 16),
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
                            const SizedBox(height: 24),
                            MyTextFieldWrapper(
                              hintText: 'Email',
                              controller: _emailController,
                              obscureText: false,
                            ),
                            const SizedBox(height: 16),
                            MyTextFieldWrapper(
                              hintText: 'Senha',
                              controller: _passwordController,
                              obscureText: false,
                            ),
                            const SizedBox(height: 16),
                            MyButton(
                              colorButton:
                                  const Color.fromARGB(255, 69, 69, 69),
                              paddingButton: 12,
                              onTap: _signUserIn,
                              textButton: 'Entrar',
                              textSize: 18,
                            ),
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
                            onTap: () async {
                              final authService = AuthService();
                              final success =
                                  await authService.signInWithGoogle();

                              if (success) {
                                // Login bem-sucedido, navegue para a HomeScreen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                            user: FirebaseAuth
                                                .instance.currentUser!,
                                          )),
                                );
                              } else {
                                // Trate o caso em que o login falhou
                                // Por exemplo, exibindo uma mensagem de erro para o usuário
                              }
                            },
                            child:
                                GoogleSignInButton(), // ou o widget que representa seu botão de login do Google
                          ),
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

  // sign user in method
  void _signUserIn() async {
    String email = _emailController.text;
    String pass = _passwordController.text;

    if (_formKey.currentState!.validate()) {
      try {
        /*
        setState(() {
          _isLoading = true;
        });
        */

        String? erro =
            await authService.loginUser(email: email, password: pass);

        if (erro != null) {
          showSnackBar(context: context, mensagem: erro);
        } else {
          // Redirecione para a tela regular do usuário (HomePage).
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(user: FirebaseAuth.instance.currentUser!),
            ),
          );
        }
      } catch (e) {
        // Trate exceções, se necessário
        print("Erro durante o login: $e");
        showSnackBar(context: context, mensagem: "Erro durante o login");
      } finally {
        /*setState(() {
          _isLoading = false;
        });
        */
      }
    }
  }
}
