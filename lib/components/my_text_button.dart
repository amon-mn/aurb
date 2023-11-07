import 'package:flutter/material.dart';

class MyTextButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final double textSize;

  const MyTextButton(
      {Key? key,
      required this.onTap,
      required this.text,
      required this.textSize})
      : super(key: key);

  @override
  _MyTextButtonState createState() => _MyTextButtonState();
}

class _MyTextButtonState extends State<MyTextButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.transparent, // Set the background color as transparent
        borderRadius: BorderRadius.circular(15),
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
            widget.text,
            style: TextStyle(
              color: _isPressed ? Colors.grey[800] : Colors.grey[900],
              fontWeight: FontWeight.bold,
              fontSize: widget.textSize,
            ),
          ),
        ),
      ),
    );
  }
}
