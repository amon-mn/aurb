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

class HomeScreen extends StatefulWidget {
  final User user;
  HomeScreen({super.key, required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) => Scaffold(
        drawer: NavigationDrawerWidget(user: widget.user),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(64.0),
          child: SafeArea(child: Header()),
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
              return MenuCard(
                  imagePath: 'lib/assets/sinalization.png',
                  title: 'Sinalização',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SinalizationPage(),
                    ));
                  });
            }
            if (index == 1) {
              return MenuCard(
                  imagePath: 'lib/assets/sidewalk.png',
                  title: 'Calçamento',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SidewalksPage(),
                    ));
                  });
            }
            if (index == 2) {
              return MenuCard(
                  imagePath: 'lib/assets/street.png',
                  title: 'Ruas e Avenidas',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => StreetsPage(),
                    ));
                  });
            }
            if (index == 3) {
              return MenuCard(
                  imagePath: 'lib/assets/accessibility.png',
                  title: 'Acessibilidade',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => AccessibilityPage(),
                    ));
                  });
            }
            if (index == 4) {
              return MenuCard(
                  imagePath: 'lib/assets/bus_stop.png',
                  title: 'Terminais de Ônibus',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => BusTerminalPage(),
                    ));
                  });
            }
            if (index == 5) {
              return MenuCard(
                  imagePath: 'lib/assets/bus.png',
                  title: 'Transporte Público',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PublicTransportPage(),
                    ));
                  });
            }
            if (index == 6) {
              return MenuCard(
                  imagePath: 'lib/assets/asphalt.png',
                  title: 'Obras',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ConstructionPage(),
                    ));
                  });
            }
            if (index == 7) {
              return MenuCard(
                  imagePath: 'lib/assets/traffic_guard.png',
                  title: 'Obstruções Temporárias',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ObstructionsPage(),
                    ));
                  });
            }
            if (index == 8) {
              return MenuCard(
                  imagePath: 'lib/assets/construction.png',
                  title: 'Uso do Espaço Público',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PublicSpacePage(),
                    ));
                  });
            }
            if (index == 9) {
              return MenuCard(
                  imagePath: 'lib/assets/traffic_accident.png',
                  title: 'Outras Notificações',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => OtherNotificationsPage(),
                    ));
                  });
            }
            return null;
          },
        ),
      );
}
