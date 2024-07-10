import 'dart:io';

import 'package:aurb/authentication/components/profile_pic.dart';
import 'package:aurb/authentication/screens/phone_number_screen.dart';
import 'package:aurb/authentication/screens/sections/header.dart';
import 'package:aurb/authentication/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserScreen extends StatefulWidget {
  final String name;
  final String email;
  final String cel;
  final String cep;
  final String endereco;
  final String bairro;
  final String cidadeEstado;

  const UserScreen({
    super.key,
    required this.name,
    required this.email,
    required this.cel,
    required this.cep,
    required this.endereco,
    required this.bairro,
    required this.cidadeEstado,
  });

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  String urlImage = 'lib/assets/perfil2.png';
  bool isPhoneVerified = false;
  bool isEmailVerified = false;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _checkPhoneVerification();
    _checkEmailVerification();
  }

  Future<void> _loadProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images/${user.uid}.jpg');
      try {
        String url = await ref.getDownloadURL();
        setState(() {
          urlImage = url;
        });
      } catch (e) {
        // Caso o usuário não tenha foto de perfil
        setState(() {
          urlImage = 'lib/assets/perfil2.png';
        });
      }
    }
  }

  Future<void> _uploadProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('profile_images/${user.uid}.jpg');
        await ref.putFile(file);
        _loadProfileImage();
      }
    }
  }

  Future<void> _checkPhoneVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        isPhoneVerified = userDoc.get('phone') != "";
      });
      _updateProfileCompletion(); // Verifica após cada atualização
    }
  }

  Future<void> _checkEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      setState(() {
        isEmailVerified = user.emailVerified;
      });
      _updateProfileCompletion(); // Verifica após cada atualização
    }
  }

  // Método para atualizar o estado de perfil completo
  void _updateProfileCompletion() {
    if (isPhoneVerified && isEmailVerified) {
      _markProfileAsCompleted(); // Marca o perfil como completo
    } else {
      print("Perfil incompleto");
    }
  }

  // Método para marcar o perfil como completo
  void _markProfileAsCompleted() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await _authService.markProfileAsCompleted(user.uid);
      } catch (error) {
        print("Erro ao marcar perfil como completo: $error");
      }
    }
  }

  Future<void> _refresh() async {
    await _loadProfileImage();
    await _checkPhoneVerification();
    await _checkEmailVerification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(), // Adicione isso para garantir que o refresh funcione mesmo quando o conteúdo não preencher a tela
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Header(
                  customIconLeft: Icons.arrow_back,
                  customOnPressed: () {
                    Navigator.pop(context);
                  },
                  customIconRight: Icons.phone,
                  customOnPressedRight: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterPhoneScreen()));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ProfilePic(
                        urlImage: urlImage,
                        width: 80,
                        height: 80,
                        onPressed: _uploadProfileImage,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.email,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 2),
                  child: RichTextRow(textSpan: 'Cel:', text: widget.cel),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 2),
                  child: RichTextRow(textSpan: 'CEP:', text: widget.cep),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 2),
                  child:
                      RichTextRow(textSpan: 'Endereço:', text: widget.endereco),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 2),
                  child: RichTextRow(textSpan: 'Bairro:', text: widget.bairro),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 2),
                  child: RichTextRow(
                      textSpan: 'Cidade/Estado:', text: widget.cidadeEstado),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 2),
                  child: RowWithIconAndText(
                    icon: Icons.check_circle,
                    text: "Verificação de e-mail",
                    iconColor: isEmailVerified ? Colors.green : Colors.grey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 2),
                  child: RowWithIconAndText(
                    icon: Icons.check_circle,
                    text: "Verificação de telefone",
                    iconColor: isPhoneVerified ? Colors.green : Colors.grey,
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

class RichTextRow extends StatelessWidget {
  final String textSpan;
  final String text;

  const RichTextRow({super.key, required this.text, required this.textSpan});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: textSpan,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 2,
        ),
        Text(
          text,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

class RowWithIconAndText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;

  const RowWithIconAndText({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ],
    );
  }
}
