import 'package:aurb/components/my_button.dart';
import 'package:aurb/components/my_textfield.dart';
import 'package:aurb/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PhoneVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const PhoneVerificationScreen({Key? key, required this.phoneNumber})
      : super(key: key);

  @override
  _PhoneVerificationScreenState createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _verificationId = '';
  final TextEditingController _codeController = TextEditingController();
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _verifyPhoneNumber();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _codeController.dispose();
    super.dispose();
  }

  void _verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _signInOrLinkWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!_isDisposed) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(e.message ?? 'Verification failed')));
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        if (!_isDisposed) {
          setState(() {
            _verificationId = verificationId;
          });
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        if (!_isDisposed) {
          setState(() {
            _verificationId = verificationId;
          });
        }
      },
    );
  }

  void _signInWithPhoneNumber() async {
    final code = _codeController.text.trim();
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId,
      smsCode: code,
    );
    await _signInOrLinkWithCredential(credential);
  }

  Future<void> _signInOrLinkWithCredential(
      PhoneAuthCredential credential) async {
    User? currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        await currentUser.linkWithCredential(credential);
        await _addPhoneNumberToUser(currentUser);
      } on FirebaseAuthException catch (e) {
        if (!_isDisposed) {
          if (e.code == 'provider-already-linked') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'This phone number is already linked to your account.')));
          } else if (e.code == 'credential-already-in-use') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    'This phone number is already associated with another account.')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Failed to link phone number: ${e.message}')));
          }
        }
      } catch (e) {
        if (!_isDisposed) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to link phone number: $e')));
        }
      }
    } else {
      try {
        UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        await _addPhoneNumberToUser(userCredential.user);
      } catch (e) {
        if (!_isDisposed) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Failed to sign in: $e')));
        }
      }
    }
  }

  Future<void> _addPhoneNumberToUser(User? user) async {
    if (user != null) {
      try {
        await _firestore.collection('users').doc(user.uid).update({
          'phone': widget.phoneNumber,
        });
        _navigateToHomeScreen(user);
      } catch (e) {
        if (!_isDisposed) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to update phone number: $e')));
        }
      }
    }
  }

  void _navigateToHomeScreen(User user) {
    if (!_isDisposed) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              HomeScreen(user: user), // Redireciona para HomeScreen
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
              Text(
                'Enviamos um código para ${widget.phoneNumber}. Insira o código abaixo:',
                style: TextStyle(
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              MyTextFieldWrapper(
                controller: _codeController,
                hintText: 'Código de Verificação',
                obscureText: false,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              MyButton(
                onTap: _signInWithPhoneNumber,
                textButton: 'Verificar',
                textSize: 18,
                colorButton: const Color.fromARGB(255, 69, 69, 69),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
