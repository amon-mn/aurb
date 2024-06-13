import 'package:aurb/authentication/screens/about_screen.dart';
import 'package:aurb/authentication/screens/welcome.dart';
import 'package:aurb/authentication/services/auth_service.dart';
import 'package:aurb/screens/control_panel_screen.dart';
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
import 'package:aurb/authentication/screens/user_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NavigationDrawerWidget extends StatefulWidget {
  final User user;
  const NavigationDrawerWidget({super.key, required this.user});

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  Map<String, dynamic> _userData = {};

  @override
  void initState() {
    super.initState();
    fetchUserDataFromFirebase();
  }

  Future<void> fetchUserDataFromFirebase() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (snapshot.exists) {
      setState(() {
        _userData = snapshot.data()!;
      });
    }
  }

  final padding = const EdgeInsets.symmetric(horizontal: 20);

  final AuthService authService = AuthService();

  Future<void> handleLogout(BuildContext context) async {
    try {
      // Faz logout usando o AuthService
      await authService.logout().then(
        ((value) {
          // Após o logout ser concluído, navega para a tela WelcomeScreen()
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
          );
        }),
      );
    } catch (e) {
      // Trata qualquer erro que possa ocorrer durante o logout
      print('Erro ao fazer logout: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    String name = _userData['name'] ?? '';
    String email = widget.user.email!;
    String urlImage = 'lib/assets/perfil2.png';
    String cel = _userData['phone'] ?? '';
    String cep = _userData['cep'] ?? '';
    String endereco = _userData['street'] ?? '';
    String bairro = _userData['neighborhood'] ?? '';
    String cidadeEstado = "${_userData['city']}, ${_userData['state']}";

    return Drawer(
      child: Material(
        color: Colors.grey[100],
        child: ListView(
          children: <Widget>[
            buildHeader(
              urlImage: urlImage,
              name: name,
              email: email,
              onClicked: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserScreen(
                  name: name,
                  urlImage: urlImage,
                  email: email,
                  cel: cel,
                  cep: cep,
                  endereco: endereco,
                  bairro: bairro,
                  cidadeEstado: cidadeEstado,
                ),
              )),
            ),
            Container(
              padding: padding,
              child: Column(
                children: [
                  buildMenuItem(
                    text: 'Notificação - Sinalização',
                    icon: Icons.notifications,
                    onClicked: () => selectedItem(context, 0),
                  ),
                  const SizedBox(height: 8),
                  buildMenuItem(
                    text: 'Notificação - Calçadas',
                    icon: Icons.notifications,
                    onClicked: () => selectedItem(context, 1),
                  ),
                  const SizedBox(height: 8),
                  buildMenuItem(
                    text: 'Notificação - Ruas e Avenidas',
                    icon: Icons.notifications,
                    onClicked: () => selectedItem(context, 2),
                  ),
                  const SizedBox(height: 8),
                  buildMenuItem(
                    text: 'Notificação - Acessibilidade',
                    icon: Icons.notifications,
                    onClicked: () => selectedItem(context, 3),
                  ),
                  const SizedBox(height: 8),
                  buildMenuItem(
                    text: 'Notificação - Terminais de Onibus',
                    icon: Icons.notifications,
                    onClicked: () => selectedItem(context, 4),
                  ),
                  const SizedBox(height: 8),
                  buildMenuItem(
                    text: 'Notificação - Transporte Público',
                    icon: Icons.notifications,
                    onClicked: () => selectedItem(context, 5),
                  ),
                  const SizedBox(height: 8),
                  buildMenuItem(
                    text: 'Notificação - Obras Públicas',
                    icon: Icons.notifications,
                    onClicked: () => selectedItem(context, 6),
                  ),
                  const SizedBox(height: 8),
                  buildMenuItem(
                    text: 'Notificação - Obstruções Temporárias',
                    icon: Icons.notifications,
                    onClicked: () => selectedItem(context, 7),
                  ),
                  const SizedBox(height: 8),
                  buildMenuItem(
                    text: 'Notificação - Uso do Espaço Público',
                    icon: Icons.notifications,
                    onClicked: () => selectedItem(context, 8),
                  ),
                  const SizedBox(height: 8),
                  buildMenuItem(
                    text: 'Outras Notificações',
                    icon: Icons.notifications,
                    onClicked: () => selectedItem(context, 9),
                  ),
                  const SizedBox(height: 8),
                  buildMenuItem(
                    text: 'Painel de análise da mobilidade',
                    icon: Icons.account_tree_outlined,
                    onClicked: () => selectedItem(context, 10),
                  ),
                  const SizedBox(height: 8),
                  buildMenuItem(
                    text: 'Remover conta',
                    icon: Icons.delete,
                    onClicked: () => selectedItem(context, 11),
                  ),
                  const SizedBox(height: 8),
                  buildMenuItem(
                      text: 'Sair',
                      icon: Icons.logout,
                      futureOnClicked: () => handleLogout(context)),
                  const SizedBox(height: 8),
                  buildMenuItem(
                    text: 'Sobre',
                    icon: Icons.info_outlined,
                    onClicked: () => selectedItem(context, 13),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) {
    return InkWell(
      onTap: onClicked,
      child: Container(
        padding: padding.add(const EdgeInsets.symmetric(vertical: 40)),
        child: Row(
          children: [
            CircleAvatar(radius: 30, backgroundImage: AssetImage(urlImage)),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _truncateText(name, 20), // Limita o nome a 20 caracteres
                    style: TextStyle(fontSize: 20, color: Colors.grey[900]),
                  ),
                  const SizedBox(height: 4),
                  Tooltip(
                    message: email, // Exibe o e-mail completo ao passar o mouse
                    child: Text(
                      _truncateText(
                          email, 30), // Limita o e-mail a 30 caracteres
                      style: TextStyle(fontSize: 14, color: Colors.grey[900]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    }
    return text;
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
    VoidCallback? futureOnClicked,
  }) {
    final color = Colors.grey[900];
    const hoverColor = Colors.black;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked ?? futureOnClicked,
    );
  }

  void selectedItem(BuildContext context, int index) {
    Navigator.of(context).pop();

    switch (index) {
      case 0:
        String title = 'Sinalização';
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SinalizationPage(tipo: title),
        ));
        break;
      case 1:
        String title = 'Calçamento';
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SidewalksPage(tipo: title),
        ));
        break;
      case 2:
        String title = 'Ruas e Avenidas';
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StreetsPage(tipo: title),
        ));
        break;
      case 3:
        String title = 'Acessibilidade';
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AccessibilityPage(tipo: title),
        ));
        break;
      case 4:
        String title = 'Terminais de Ônibus';
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BusTerminalPage(tipo: title),
        ));
        break;
      case 5:
        String title = 'Transporte Público';
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PublicTransportPage(tipo: title),
        ));
        break;
      case 6:
        String title = 'Obras';
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ConstructionPage(tipo: title),
        ));
        break;
      case 7:
        String title = 'Obstruções Temporárias';
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ObstructionsPage(tipo: title),
        ));
        break;
      case 8:
        String title = 'Uso do Espaço Público';
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PublicSpacePage(tipo: title),
        ));
        break;
      case 9:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const OtherNotificationsPage(),
        ));
        break;
      case 10:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ControlPanelPage(),
        ));
        break;
      case 11:
        () {};
        break;
      case 12:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ));
        break;
      case 13:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const AboutScreen(),
        ));
        break;
    }
  }
}
