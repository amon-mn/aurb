import 'package:aurb/screens/adm_details_notification.dart';
import 'package:flutter/material.dart';
import 'package:aurb/authentication/screens/sections/header.dart';
import 'package:aurb/components/navigation_drawer.dart';
import 'package:aurb/firestore_notifications/models/notification.dart';
import 'package:aurb/firestore_notifications/services/notification_service.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'adm_details_notification.dart'; // Importar a nova página de detalhes

class AdmPage extends StatefulWidget {
  final User user;

  const AdmPage({Key? key, required this.user}) : super(key: key);

  @override
  State<AdmPage> createState() => _AdmPageState();
}

class _AdmPageState extends State<AdmPage> {
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Text(
                  'Todas as Ocorrências:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[900],
                  ),
                ),
              ),
              FutureBuilder<List<UserNotification>>(
                future: NotificationService().readAllNotifications(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar notificações'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                        child: Text('Nenhuma notificação encontrada'));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        UserNotification notification = snapshot.data![index];
                        return _buildCard(context, notification);
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, UserNotification notification) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AdmDetailsNotificationPage(notification: notification),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ID: ${notification.id.substring(0, 8)}  -  Status: ${notification.status}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tipo: ${notification.tipo}  -  Risco: ${notification.risco}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Data: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(notification.data))}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
