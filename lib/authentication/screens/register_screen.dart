import 'package:aurb/authentication/services/auth_service.dart';
import 'package:aurb/components/card.dart';
import 'package:aurb/components/my_button.dart';
import 'package:aurb/components/my_textfield.dart';
import 'package:aurb/components/show_snackbar.dart';
import 'package:aurb/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmationController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  void _signUserUp() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      final String? error = await _createUser(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        cep: _cepController.text,
        state: _stateController.text,
        phone: "",
        city: _cityController.text,
        street: _streetController.text,
        neighborhood: _neighborhoodController.text,
        userType: 'User',
      );

      if (!mounted) return;
      if (error != null) {
        showSnackBar(context: context, mensagem: error);
      } else {
        final User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          await currentUser.sendEmailVerification();
          showSnackBar(
            context: context,
            mensagem:
                'Cadastro realizado com sucesso! Verifique seu e-mail para confirmar o cadastro.',
            isErro: false,
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(user: currentUser),
            ),
          );

          // Verificar se o perfil está completo
          bool isComplete =
              await _authService.isProfileComplete(currentUser.uid);
          if (isComplete) {
            await _authService.markProfileAsCompleted(currentUser.uid);
          }
        } else {
          showSnackBar(
            context: context,
            mensagem: 'Erro ao obter usuário após o cadastro.',
            isErro: true,
          );
        }
      }
    } else {
      showSnackBar(
        context: context,
        mensagem: 'Erro: Formulário não inicializado corretamente.',
        isErro: true,
      );
    }
  }

  Future<String?> _createUser({
    required String email,
    required String password,
    required String name,
    required String cep,
    required String state,
    required String city,
    required String street,
    required String neighborhood,
    required String phone,
    required String userType,
  }) async {
    try {
      return await _authService.registerUser(
        email: email,
        password: password,
        name: name,
        cep: cep,
        state: state,
        city: city,
        street: street,
        neighborhood: neighborhood,
        phone: phone,
        userType: userType,
      );
    } catch (error) {
      return error.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 69, 69, 69),
      body: SafeArea(
        child: ListView(
          children: [
            Center(
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
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.amber,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        const Column(
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
                  const SizedBox(height: 136),
                  MyCard(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height + 98,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              'Cadastro',
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[900],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          MyTextFieldWrapper(
                            hintText: 'Nome',
                            controller: _nameController,
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "O campo logradouro deve ser preenchido";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          MyTextFieldWrapper(
                            hintText: 'Email',
                            controller: _emailController,
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "O campo logradouro deve ser preenchido";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          MyTextFieldWrapper(
                            hintText: 'Senha',
                            controller: _passwordController,
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "O campo logradouro deve ser preenchido";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          MyTextFieldWrapper(
                            hintText: 'Confirmação de senha',
                            controller: _confirmationController,
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "O campo logradouro deve ser preenchido";
                              } else if (_passwordController.text !=
                                  _confirmationController.text) {
                                return "As senhas devem ser iguais";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          MyTextFieldWrapper(
                            inputFormatter: MaskTextInputFormatter(
                              mask: '#####-###',
                              filter: {"#": RegExp(r'[0-9]')},
                              type: MaskAutoCompletionType.lazy,
                            ),
                            suffixIcon: Icons.search,
                            controller: _cepController,
                            hintText: 'CEP',
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "O CEP deve ser preenchido";
                              }
                              if (value.length != 9) {
                                return "O CEP deve ter exatamente 9 dígitos";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          MyTextFieldWrapper(
                            controller: _streetController,
                            hintText: 'Logradouro',
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "O campo logradouro deve ser preenchido";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          MyTextFieldWrapper(
                            controller: _neighborhoodController,
                            hintText: 'Bairro',
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "O campo bairro deve ser preenchido";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          MyTextFieldWrapper(
                            controller: _cityController,
                            hintText: 'Cidade',
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "O campo cidade deve ser preenchido";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          MyTextFieldWrapper(
                            controller: _stateController,
                            hintText: 'Estado',
                            obscureText: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "O campo estado deve ser preenchido";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          MyButton(
                            colorButton: const Color.fromARGB(255, 69, 69, 69),
                            paddingButton: 12,
                            onTap: _signUserUp,
                            textButton: 'Cadastrar',
                            textSize: 18,
                          ),
                          const SizedBox(height: 16),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text:
                                  "Ao clicar em 'Cadastrar' você concorda com nossos ",
                              style: const TextStyle(
                                  color: Color.fromRGBO(120, 131, 137, 1)),
                              children: [
                                TextSpan(
                                  //recognizer: ,
                                  text: "Termos de Uso",
                                  style: TextStyle(color: Colors.amber[800]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
