import 'package:aurb/authentication/screens/about_screen.dart';
import 'package:aurb/authentication/screens/welcome.dart';
import 'package:aurb/authentication/services/auth_service.dart';
import 'package:aurb/screens/control_panel_screen.dart';
import 'package:aurb/screens/notifications/accessibility_screen.dart';
import 'package:aurb/screens/notifications/bus_terminal_screen.dart';
import 'package:aurb/screens/notifications/construction_screen.dart';
import 'package:aurb/screens/notifications/obstructions_screen.dart';
import 'package:aurb/screens/notifications/other_notifications.dart';
import 'package:aurb/screens/notifications/public_space.dart';
import 'package:aurb/screens/notifications/public_transport_screen.dart';
import 'package:aurb/screens/notifications/sidewalks_screen.dart';
import 'package:aurb/screens/notifications/sinalization_screen.dart';
import 'package:aurb/screens/notifications/streets_screen.dart';
import 'package:aurb/authentication/screens/user_screen.dart';
import 'package:flutter/material.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20);
  final AuthService authService = AuthService();

  Future<void> handleLogout(BuildContext context) async {
    try {
      // Faz logout usando o AuthService
      await authService.logout().then(
        ((value) {
          // Após o logout ser concluído, navega para a tela WelcomeScreen()
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => WelcomeScreen()),
          );
        }),
      );
    } catch (e) {
      // Trata qualquer erro que possa ocorrer durante o logout
      print('Erro ao fazer logout: $e');
    }
  }

  NavigationDrawerWidget({super.key});
  @override
  Widget build(BuildContext context) {
    const name = 'Nome do Usuário';
    const email = 'usuario@gmail.com';
    const urlImage = 'lib/assets/perfil2.png';
    const cel = '(xx) x xxxx-xxxx';
    const genero = 'Masculino';
    const cep = 'xxxxxx-xxx';
    const endereco = 'Rua ou avenida, número';
    const bairro = 'Santa Terezinha';
    const cidadeEstado = 'Manaus, Amazonas';

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
                builder: (context) => const UserScreen(
                  name: name,
                  urlImage: urlImage,
                  email: email,
                  cel: cel,
                  cep: cep,
                  genero: genero,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 20, color: Colors.grey[900]),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: TextStyle(fontSize: 14, color: Colors.grey[900]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SinalizationPage(),
        ));
        break;
      case 1:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SidewalksPage(),
        ));
        break;
      case 2:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => StreetsPage(),
        ));
        break;
      case 3:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AccessibilityPage(),
        ));
        break;
      case 4:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BusTerminalPage(),
        ));
        break;
      case 5:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PublicTransportPage(),
        ));
        break;
      case 6:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ConstructionPage(),
        ));
        break;
      case 7:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ObstructionsPage(),
        ));
        break;
      case 8:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PublicSpacePage(),
        ));
        break;
      case 9:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => OtherNotificationsPage(),
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
          builder: (context) => WelcomeScreen(),
        ));
        break;
      case 13:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AboutScreen(),
        ));
        break;
    }
  }
}
