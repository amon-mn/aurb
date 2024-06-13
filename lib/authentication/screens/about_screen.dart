import 'package:aurb/authentication/screens/sections/header.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Header(
                  customIcon: Icons.arrow_back,
                  customOnPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'Idealização:',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 72.0),
                  child: Divider(),
                ),
                const Text(
                  'Prof. Marcos Castro de Lima',
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Prof. Jaisson Miyosi Oka',
                  style: TextStyle(fontSize: 16.0),
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'Parceria:',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 72.0),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'lib/assets/ufam_logo.png', // Substitua pelo caminho da primeira imagem
                      width: 70,
                      height: 70,
                    ),
                    const SizedBox(width: 32),
                    Image.asset(
                      'lib/assets/tce_logo.png', // Substitua pelo caminho da segunda imagem
                      width: 75,
                      height: 75,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  'Desenvolvimento:',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 72.0),
                  child: Divider(),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.0),
                  child: ProfileCard(
                    urlImage: 'lib/assets/profile_amaotech.jpg',
                    title: 'AMAO Tech',
                    subTitle: 'Startup P, D & I',
                    description:
                        'Somos uma startup de Pesquisa e Desenvolvimento focada em utilizar tecnologia de ponta para otimizar processos e soluções na região amazônica',
                    icons: [FontAwesomeIcons.instagram],
                    redirectUrls: ['https://www.instagram.com/amao.tech/'],
                    iconColors: [Color.fromARGB(255, 188, 42, 141)],
                  ),
                ),
                /*
                CarouselSlider(
                  options: CarouselOptions(
                    height: 475,
                    enlargeCenterPage: true,
                    viewportFraction: 0.8,
                  ),
                  items: [
                    
                    ProfileCard(
                      urlImage: 'lib/assets/profile_henriquebarkett.jpg',
                      title: 'Henrique Barkett',
                      subTitle: 'Mobile Developer',
                      description:
                          'Quero crescer e evoluir como desenvolvedor de software, contribuindo para projetos inovadores e fazendo a diferença no mundo da tecnologia. Busco oportunidades para aplicar minha paixão pela programação e criar soluções que impactem positivamente a vida das pessoas.',
                      icons: [
                        FontAwesomeIcons.github,
                        FontAwesomeIcons.linkedin
                      ],
                      redirectUrls: [
                        'https://github.com/henriquebarkett/',
                        'https://www.linkedin.com/in/henriquebarkett/'
                      ],
                      iconColors: [Colors.black, Colors.blue],
                    ),
                    ProfileCard(
                      urlImage: 'lib/assets/profile_amonmn.jpg',
                      title: 'Amon Menezes',
                      subTitle: 'Mobile Developer',
                      description:
                          'Desenvolvedor Android com 3 anos de experiência em Java e Flutter, focado em criar aplicativos inovadores. Comprometido em aprender novas tecnologias, resolver desafios e contribuir para uma equipe que busca constantemente soluções excepcionais.',
                      icons: [
                        FontAwesomeIcons.github,
                        FontAwesomeIcons.linkedin
                      ],
                      redirectUrls: [
                        'https://github.com/amon-mn/',
                        'https://www.linkedin.com/in/amonmenezesnegreiros/'
                      ],
                      iconColors: [Colors.black, Colors.blue],
                    ),
                    
                  ],
                ),
                */
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String urlImage;
  final String title;
  final String subTitle;
  final String description;
  final List<String> redirectUrls;
  final List<Color> iconColors;
  final List<IconData> icons; // Adicionado o parâmetro para os ícones

  const ProfileCard({super.key, 
    required this.urlImage,
    required this.title,
    required this.subTitle,
    required this.description,
    required this.redirectUrls,
    required this.iconColors,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: Colors.white.withOpacity(0.90),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CircleAvatar(
              radius: 60.0,
              backgroundImage: AssetImage(urlImage),
            ),
            const SizedBox(height: 16.0),
            Text(
              title,
              style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
            ),
            Text(
              subTitle,
              style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5),
            ),
            const SizedBox(height: 16.0),
            Text(
              description,
              style: const TextStyle(fontSize: 11.0),
              textAlign: TextAlign.justify,
            ),
            const Divider(),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                if (icons.isNotEmpty)
                  RoundedSocialIcon(
                    icon: icons[0],
                    backgroundColor: iconColors[0],
                    redirectUrl: redirectUrls[0],
                  ),
                if (icons.length == 2)
                  RoundedSocialIcon(
                    icon: icons[1],
                    backgroundColor: iconColors[1],
                    redirectUrl: redirectUrls[1],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class RoundedSocialIcon extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final String redirectUrl;

  const RoundedSocialIcon({super.key, 
    required this.icon,
    required this.backgroundColor,
    required this.redirectUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _launchURL(redirectUrl);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
