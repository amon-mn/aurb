import 'package:aurb/authentication/components/profile_pic.dart';
import 'package:aurb/screens/sections/header.dart';
import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  final String name;
  final String urlImage;
  final String email;
  final String cel;
  final String genero;
  final String cep;
  final String endereco;
  final String bairro;
  final String cidadeEstado;

  const UserScreen({
    Key? key,
    required this.name,
    required this.urlImage,
    required this.email,
    required this.cel,
    required this.genero,
    required this.cep,
    required this.endereco,
    required this.bairro,
    required this.cidadeEstado,
  }) : super(key: key);

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
                      urlImage: urlImage,
                      width: 80,
                      height: 80,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            email,
                            style: TextStyle(
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
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 2),
                child: RichTextRow(textSpan: 'Cel:', text: cel),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 2),
                child: RichTextRow(textSpan: 'Genero:', text: genero),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 2),
                child: RichTextRow(textSpan: 'CEP:', text: cep),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 2),
                child: RichTextRow(textSpan: 'Endereço:', text: endereco),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 2),
                child: RichTextRow(textSpan: 'Bairro:', text: bairro),
              ),
              SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 2),
                child:
                    RichTextRow(textSpan: 'Cidade/Estado:', text: cidadeEstado),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 2),
                child: RowWithIconAndText(
                  icon: Icons.check_circle,
                  text: "Verificação de e-mail",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 2),
                child: RowWithIconAndText(
                  icon: Icons.check_circle,
                  text: "Verificação de rede social",
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 2),
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

  RichTextRow({required this.text, required this.textSpan});

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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 2,
        ),
        Text(
          text,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

class RowWithIconAndText extends StatelessWidget {
  final IconData icon;
  final String text;

  RowWithIconAndText({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
        ),
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ],
    );
  }
}
