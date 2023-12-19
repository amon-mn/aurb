import 'package:aurb/components/card.dart';
import 'package:aurb/components/my_button.dart';
import 'package:aurb/components/my_textfield.dart';
import 'package:flutter/material.dart';

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
                const SizedBox(height: 136),
                MyCard(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height - 236,
                  child: Form(
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
                        ),
                        SizedBox(height: 16),
                        MyTextFieldWrapper(
                          hintText: 'Telefone',
                          controller: _phoneController,
                          obscureText: false,
                        ),
                        SizedBox(height: 16),
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
                        MyTextFieldWrapper(
                          hintText: 'Confirmação de senha',
                          controller: _confirmationController,
                          obscureText: false,
                        ),
                        SizedBox(height: 16),
                        MyButton(
                            colorButton: const Color.fromARGB(255, 69, 69, 69),
                            paddingButton: 12,
                            onTap: () {},
                            textButton: 'Cadastrar',
                            textSize: 18),
                        SizedBox(height: 16),
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
        ),
      ),
    );
  }
}
