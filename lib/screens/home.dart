import 'package:aurb/authentication/screens/sections/header.dart';
import 'package:aurb/components/menu_card.dart';
import 'package:aurb/components/navigation_drawer.dart';
import 'package:aurb/firestore_notifications/screens/notifications/accessibility_screen.dart';
import 'package:aurb/firestore_notifications/screens/notifications/bus_terminal_screen.dart';
import 'package:aurb/firestore_notifications/screens/notifications/construction_screen.dart';
import 'package:aurb/firestore_notifications/screens/notifications/obstructions_screen.dart';
import 'package:aurb/firestore_notifications/screens/notifications/other_notifications.dart';
import 'package:aurb/firestore_notifications/screens/notifications/public_space.dart';
import 'package:aurb/firestore_notifications/screens/notifications/public_transport_screen.dart';
import 'package:aurb/firestore_notifications/screens/notifications/sidewalks_screen.dart';
import 'package:aurb/firestore_notifications/screens/notifications/sinalization_screen.dart';
import 'package:aurb/firestore_notifications/screens/notifications/streets_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:aurb/authentication/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = AuthService();

  Future<bool> _checkVerification() async {
    bool isProfileComplete =
        await _authService.isProfileComplete(widget.user.uid);
    if (!isProfileComplete) {
      _showVerificationDialog();
    }
    return isProfileComplete;
  }

  void _showVerificationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Verificação necessária'),
          content: const Text(
              'Por favor, verifique seu e-mail e cadastre um telefone na página de perfil do usuário.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => SafeArea(
        child: Scaffold(
          drawer: NavigationDrawerWidget(user: widget.user),
          appBar: const PreferredSize(
            preferredSize: Size.fromHeight(64.0),
            child: SafeArea(
                child: Header(
              customIconRight: Icons.mail,
            )),
          ),
          body: GridView.builder(
            itemCount: 10,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              if (index == 0) {
                String title = 'Sinalização';
                return MenuCard(
                    imagePath: 'lib/assets/sinalization.png',
                    title: 'Sinalização',
                    onTap: () async {
                      if (await _checkVerification()) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SinalizationPage(
                            tipo: title,
                          ),
                        ));
                      }
                    });
              }
              if (index == 1) {
                String title = 'Calçamento';
                return MenuCard(
                    imagePath: 'lib/assets/sidewalk.png',
                    title: title,
                    onTap: () async {
                      if (await _checkVerification()) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SidewalksPage(
                            tipo: title,
                          ),
                        ));
                      }
                    });
              }
              if (index == 2) {
                String title = 'Ruas e Avenidas';
                return MenuCard(
                    imagePath: 'lib/assets/street.png',
                    title: title,
                    onTap: () async {
                      if (await _checkVerification()) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => StreetsPage(
                            tipo: title,
                          ),
                        ));
                      }
                    });
              }
              if (index == 3) {
                String title = 'Acessibilidade';
                return MenuCard(
                    imagePath: 'lib/assets/accessibility.png',
                    title: title,
                    onTap: () async {
                      if (await _checkVerification()) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AccessibilityPage(
                            tipo: title,
                          ),
                        ));
                      }
                    });
              }
              if (index == 4) {
                String title = 'Terminais de Ônibus';
                return MenuCard(
                    imagePath: 'lib/assets/bus_stop.png',
                    title: 'Terminais de Ônibus',
                    onTap: () async {
                      if (await _checkVerification()) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BusTerminalPage(
                            tipo: title,
                          ),
                        ));
                      }
                    });
              }
              if (index == 5) {
                String title = 'Transporte Público';
                return MenuCard(
                    imagePath: 'lib/assets/bus.png',
                    title: title,
                    onTap: () async {
                      if (await _checkVerification()) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PublicTransportPage(
                            tipo: title,
                          ),
                        ));
                      }
                    });
              }
              if (index == 6) {
                String title = 'Obras';
                return MenuCard(
                    imagePath: 'lib/assets/asphalt.png',
                    title: title,
                    onTap: () async {
                      if (await _checkVerification()) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ConstructionPage(
                            tipo: title,
                          ),
                        ));
                      }
                    });
              }
              if (index == 7) {
                String title = 'Obstruções Temporárias';
                return MenuCard(
                    imagePath: 'lib/assets/traffic_guard.png',
                    title: title,
                    onTap: () async {
                      if (await _checkVerification()) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ObstructionsPage(
                            tipo: title,
                          ),
                        ));
                      }
                    });
              }
              if (index == 8) {
                String title = 'Uso do Espaço Público';
                return MenuCard(
                    imagePath: 'lib/assets/construction.png',
                    title: title,
                    onTap: () async {
                      if (await _checkVerification()) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PublicSpacePage(
                            tipo: title,
                          ),
                        ));
                      }
                    });
              }
              if (index == 9) {
                return MenuCard(
                    imagePath: 'lib/assets/traffic_accident.png',
                    title: 'Outras Notificações',
                    onTap: () async {
                      if (await _checkVerification()) {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const OtherNotificationsPage(),
                        ));
                      }
                    });
              }
              return null;
            },
          ),
        ),
      );
}
