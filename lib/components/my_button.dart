import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final VoidCallback onTap;
  final String textButton;
  final bool isRed; // Novo parâmetro
  final double textSize;
  final Color colorButton;
  final double? paddingButton;

  const MyButton({
    Key? key,
    required this.onTap,
    required this.textButton,
    required this.textSize,
    required this.colorButton,
    this.paddingButton,
    this.isRed = false, // Valor padrão para isRed
  }) : super(key: key);

  @override
  _MyButtonState createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  bool _isPressed = false;

  Color? getButtonColor() {
    if (_isPressed) {
      return widget.isRed ? Colors.red[700] : widget.colorButton;
    } else {
      return widget.isRed ? Colors.red[800] : widget.colorButton;
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth,
      child: Container(
        padding: widget.paddingButton != null
            ? EdgeInsets.all(widget.paddingButton!)
            : const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: getButtonColor(),
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    offset: const Offset(0, 4),
                    blurRadius: 8,
                  ),
                ]
              : [],
        ),
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: (_) {
            setState(() {
              _isPressed = true;
            });
          },
          onTapCancel: () {
            setState(() {
              _isPressed = false;
            });
          },
          onTapUp: (_) {
            setState(() {
              _isPressed = false;
            });
          },
          child: Center(
            child: Text(
              widget.textButton,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: widget.textSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}