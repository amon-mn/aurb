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
  const RegisterScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmationController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  // Global Keys
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 69, 69, 69),
      body: SafeArea(
        child: ListView(children: [
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
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height + 98,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 16),
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
                        SizedBox(height: 24),
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
                        SizedBox(height: 12),
                        MyTextFieldWrapper(
                          hintText: 'Telefone',
                          controller: _phoneController,
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "O campo logradouro deve ser preenchido";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 12),
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
                        SizedBox(height: 12),
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
                        SizedBox(height: 12),
                        MyTextFieldWrapper(
                          hintText: 'Confirmação de senha',
                          controller: _confirmationController,
                          obscureText: false,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "O campo logradouro deve ser preenchido";
                            } else if (_passwordController.text !=
                                _confirmationController.text) {
                              return "As senhas  devem ser iguais";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        MyTextFieldWrapper(
                          inputFormatter: MaskTextInputFormatter(
                            mask: '#####-###',
                            filter: {"#": RegExp(r'[0-9]')},
                            type: MaskAutoCompletionType.lazy,
                          ),
                          suffixIcon: Icons.search,
                          //onSuffixIconPressed: () => _autoFillAddress(context),
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
                            textSize: 18),
                        const SizedBox(height: 16),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text:
                                "Ao clicar em 'Cadastrar' você concorda com nossos ",
                            style: TextStyle(
                                color: Color.fromRGBO(120, 131, 137, 1)),
                            children: [
                              TextSpan(
                                //recognizer: ,
                                text: "Termos de Uso",
                                style: TextStyle(
                                  color: Colors.amber[800],
                                ),
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
        ]),
      ),
    );
  }

  void _signUserUp() async {
    final TextEditingController nameController = _nameController;
    final TextEditingController emailController = _emailController;
    final TextEditingController passwordController = _passwordController;
    final TextEditingController cepController = _cepController;
    final TextEditingController streetController = _streetController;
    final TextEditingController neighborhoodController =
        _neighborhoodController;
    final TextEditingController cityController = _cityController;
    final TextEditingController stateController = _stateController;
    final TextEditingController phoneController =
        _phoneController; // Novo campo
    final TextEditingController genderController =
        _genderController; // Novo campo

    final GlobalKey<FormState> formKey = _formKey;

    if (formKey.currentState != null) {
      if (formKey.currentState!.validate()) {
        _createUser(
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text,
          cep: cepController.text,
          state: stateController.text,
          city: cityController.text,
          street: streetController.text,
          neighborhood: neighborhoodController.text,
          phone: phoneController.text, // Passando o valor do telefone
        ).then((String? error) {
          if (error != null) {
            showSnackBar(context: context, mensagem: error);
          } else {
            final User? currentUser = FirebaseAuth.instance.currentUser;
            if (currentUser != null) {
              showSnackBar(
                context: context,
                mensagem: 'Cadastro realizado com sucesso!',
                isErro: false,
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(user: currentUser),
                ),
              );
            } else {
              showSnackBar(
                context: context,
                mensagem: 'Erro ao obter usuário após o cadastro.',
                isErro: true,
              );
            }
          }
        });
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
    required String phone, // Novo parâmetro
  }) async {
    try {
      final AuthService authService = AuthService();

      return await authService.registerUser(
        email: email,
        password: password,
        name: name,
        cep: cep,
        state: state,
        city: city,
        street: street,
        neighborhood: neighborhood,
        phone: phone, // Passando o valor do telefone
      );
    } catch (error) {
      return error.toString();
    }
  }
}
