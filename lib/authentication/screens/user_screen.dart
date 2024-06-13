import 'package:aurb/authentication/components/profile_pic.dart';
import 'package:aurb/authentication/screens/sections/header.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  final String name;
  final String urlImage;
  final String email;
  final String cel;
  final String cep;
  final String endereco;
  final String bairro;
  final String cidadeEstado;

  const UserScreen({
    super.key,
    required this.name,
    required this.urlImage,
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                customIcon: Icons.arrow_back,
                customOnPressed: () {
                  Navigator.pop(context);
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfilePic(
                      urlImage: widget.urlImage,
                      width: 80,
                      height: 80,
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
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 2),
                child: RowWithIconAndText(
                  icon: Icons.check_circle,
                  text: "Verificação de e-mail",
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 2),
                child: RowWithIconAndText(
                  icon: Icons.check_circle,
                  text: "Verificação de rede social",
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 2),
                child: RowWithIconAndText(
                  icon: Icons.check_circle,
                  text: "Verificação de telefone",
                ),
              ),
            ],
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
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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

  const RowWithIconAndText({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
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
