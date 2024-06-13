import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;

  const MyCard({super.key, required this.child, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(60),
          topRight: Radius.circular(60),
        ),
      ),
      padding: const EdgeInsets.all(24.0),
      child: child,
    );
  }
}
