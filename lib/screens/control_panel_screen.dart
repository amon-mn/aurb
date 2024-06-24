import 'package:flutter/material.dart';
import 'package:aurb/authentication/screens/sections/header.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:aurb/firestore_notifications/models/notification.dart';
import 'package:aurb/firestore_notifications/services/notification_service.dart';

class ControlPanelPage extends StatelessWidget {
  final NotificationService _notificationService = NotificationService();

  ControlPanelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Header(
                customIconLeft: Icons.arrow_back,
                customOnPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Painel de Análise da Mobilidade",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: MediaQuery.of(context).size.height / 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: FutureBuilder<List<UserNotification>>(
                      future: _notificationService.readNotifications(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text("Error loading notifications"));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Center(child: Text("No notifications found"));
                        }

                        List<UserNotification> notifications = snapshot.data!;
                        return GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: LatLng(-3.0870, -60.0055),
                            zoom: 12.0,
                          ),
                          markers: _buildMarkers(notifications),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLegend("Sinalização", Colors.green),
                  _buildLegend("Calçamento", Colors.orange),
                  _buildLegend("Ruas e Avenidas", Colors.red),
                  _buildLegend("Acessibilidade", Colors.blue),
                  _buildLegend("Terminais de Onibus", Colors.purple),
                  _buildLegend("Transporte Público", Colors.yellow),
                  _buildLegend("Obras", Colors.brown),
                  _buildLegend("Obstruções Temporárias", Colors.grey),
                  _buildLegend("Uso do Espaço Público", Colors.cyan),
                  _buildLegend("Outras Notificações", Colors.black),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Set<Marker> _buildMarkers(List<UserNotification> notifications) {
    Set<Marker> markers = {};

    for (UserNotification notification in notifications) {
      if (notification.loc != null) {
        LatLng coordinate =
            LatLng(notification.loc!.latitude, notification.loc!.longitude);

        BitmapDescriptor icon;

        switch (notification.tipo) {
          case "Sinalização":
            icon = BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen);
            break;
          case "Calçamento":
            icon = BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueOrange);
            break;
          case "Ruas e Avenidas":
            icon =
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
            break;
          case "Acessibilidade":
            icon =
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
            break;
          case "Terminais de Onibus":
            icon = BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueMagenta);
            break;
          case "Transporte Público":
            icon = BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueYellow);
            break;
          case "Obras":
            icon =
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose);
            break;
          case "Obstruções Temporárias":
            icon =
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
            break;
          case "Uso do Espaço Público":
            icon = BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueAzure);
            break;
          case "Outras Notificações":
          default:
            icon = BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet);
            break;
        }

        markers.add(
          Marker(
            markerId: MarkerId(notification.id),
            position: coordinate,
            icon: icon,
            infoWindow: InfoWindow(
              title: notification.tipo,
              snippet: notification.descricao,
            ),
          ),
        );
      }
    }

    return markers;
  }

  Widget _buildLegend(String title, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            color: color,
          ),
          SizedBox(width: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
