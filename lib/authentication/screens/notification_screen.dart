import 'package:flutter/material.dart';
import 'package:aurb/authentication/screens/sections/header.dart';

class NotificationPage extends StatelessWidget {
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
              SizedBox(height: 25), // Espaço entre o header e o conteúdo
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Text(
                      'Minhas Ocorrências:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        _buildCard(
                          title: 'Sinalização 001',
                          subtitle: 'Placa apagada - Em Andamento',
                        ),
                        _buildCard(
                          title: 'Sinalização 002',
                          subtitle: 'Ausência de sinal. vertical - Concluído',
                        ),
                        _buildCard(
                          title: 'Acessibilidade 001',
                          subtitle: 'Falta de rampa de acesso calçadas - Não Iniciado',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required String subtitle}) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
      ),
    );
  }
}
