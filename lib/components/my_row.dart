import 'package:flutter/material.dart';

class MyRow extends StatelessWidget {
  final String title, value;
  final IconData? icon;

  const MyRow({
    super.key,
    required this.title,
    this.icon,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FractionallySizedBox(
          widthFactor: 0.9, // Define a largura relativa desejada (80% do pai)
          child: Container(
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(12.0), // Defina o raio da borda
              color: Colors.white, // Adicione uma cor de fundo se necessário
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.all(0), // Remove o preenchimento padrão
              leading: Icon(icon),
              title: Text(
                title,
                style: const TextStyle(fontSize: 16),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}
