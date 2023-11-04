import 'package:flutter/material.dart';

class UserScreen extends StatelessWidget {
  final String name;
  final String urlImage;

  const UserScreen({
    Key? key,
    required this.name,
    required this.urlImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
          title: Text(name),
          centerTitle: true,
        ),
        body: Container(),
      );
}
