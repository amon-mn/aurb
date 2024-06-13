import 'package:flutter/material.dart';

class GoogleSignInButton extends StatelessWidget {
  final Function()? onPressed;

  const GoogleSignInButton({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[700]!, // Cor da borda
          ),
          borderRadius: BorderRadius.circular(5.0), // Borda arredondada
        ),
        padding: const EdgeInsets.all(10.0), // Espaçamento interno
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'lib/assets/google.png', // Substitua pelo caminho para o seu próprio logotipo do Google
              height: 24.0, // Altura do logotipo
            ),
            const SizedBox(width: 10.0), // Espaçamento entre o logotipo e o texto
            Text(
              'Entre com o Google', // Texto do botão
              style: TextStyle(
                fontSize: 16.0, // Tamanho do texto
                color: Colors.grey[700], // Cor do texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
