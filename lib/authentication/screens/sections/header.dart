import 'package:aurb/firestore_notifications/screens/notification_screen.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final IconData? customIcon;
  final Function()? customOnPressed;

  const Header({super.key, this.customIcon, this.customOnPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 64,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              customIcon ??
                  Icons
                      .menu_rounded, // Usa o ícone personalizado ou o ícone padrão
              color: Colors.black,
              size: 28,
            ),
            onPressed: customOnPressed ??
                () {
                  Scaffold.of(context)
                      .openDrawer(); // Usa a função personalizada ou a função padrão
                },
          ),
          Expanded(
            child: Center(
              child: Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 42,
                          height: 42,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 120,
                          child: Text(
                            'AURB',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: Text(
                            'Auditorias Urbanas em Mobilidade',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.mail,
              color: Colors.black,
              size: 28,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
