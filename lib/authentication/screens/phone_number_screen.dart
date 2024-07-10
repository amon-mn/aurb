import 'package:aurb/authentication/screens/phone_verification_screen.dart';
import 'package:aurb/components/my_button.dart';
import 'package:aurb/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterPhoneScreen extends StatefulWidget {
  @override
  _RegisterPhoneScreenState createState() => _RegisterPhoneScreenState();
}

class _RegisterPhoneScreenState extends State<RegisterPhoneScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _phoneFormatter = MaskTextInputFormatter(
    mask: '+55 (##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _verifyPhoneNumber() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhoneVerificationScreen(
            phoneNumber: _phoneController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 69, 69, 69),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Verificação de Telefone',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16),
                MyTextFieldWrapper(
                  controller: _phoneController,
                  hintText: 'Telefone',
                  obscureText: false,
                  inputFormatter: _phoneFormatter,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "O campo telefone deve ser preenchido";
                    }
                    if (!_phoneFormatter.isFill()) {
                      return "O telefone deve estar completo";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                MyButton(
                  colorButton: const Color.fromARGB(255, 69, 69, 69),
                  paddingButton: 12,
                  onTap: _verifyPhoneNumber,
                  textButton: 'Enviar Código',
                  textSize: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
