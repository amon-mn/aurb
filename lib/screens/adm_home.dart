import 'package:aurb/authentication/screens/sections/header.dart';
import 'package:aurb/components/navigation_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdmPage extends StatefulWidget {
  final User user;

  const AdmPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AdmPage> createState() => _AdmPageState();
}

class _AdmPageState extends State<AdmPage> {
  // Chave global para o RefreshIndicator
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(user: widget.user),
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(64.0),
        child: SafeArea(child: Header()),
      ),
      body: Center(
        child: const Text(
          'Você está logado como ADM',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
