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
                  child: FutureBuilder<List<UserNotification>>(
                    future: _notificationService.readNotifications(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: Text("Error loading notifications"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("No notifications found"));
                      }

                      List<UserNotification> notifications = snapshot.data!;
                      Set<Marker> markers = _buildMarkers(notifications);
                      List<String> legendTitles = [];

                      // Filter out duplicate legend titles
                      markers.forEach((marker) {
                        if (!legendTitles.contains(marker.infoWindow.title!)) {
                          legendTitles.add(marker.infoWindow.title!);
                        }
                      });

                      return Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(-3.0870, -60.0055),
                              zoom: 12.0,
                            ),
                            markers: markers,
                          ),
                          Positioned(
                            top: 16.0,
                            right: 16.0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: legendTitles.map((title) {
                                return _buildLegend(title);
                              }).toList(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
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
        Color markerColor = _getColorForNotificationType(notification.tipo);

        icon =
            BitmapDescriptor.defaultMarkerWithHue(_getHueForColor(markerColor));

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

  Color _getColorForNotificationType(String type) {
    switch (type) {
      case "Sinalização":
        return Colors.green;
      case "Calçamento":
        return Colors.orange;
      case "Ruas e Avenidas":
        return Colors.red;
      case "Acessibilidade":
        return Colors.blue;
      case "Terminais de Ônibus":
        return Colors.purple;
      case "Transporte Público":
        return Colors.yellow;
      case "Obras":
        return Colors.pink;
      case "Obstruções Temporárias":
        return Colors.cyan;
      case "Uso do Espaço Público":
        return Colors.black;
      case "Outras Notificações":
      default:
        return Colors.black;
    }
  }

  double _getHueForColor(Color color) {
    // Convert Color to Hue value for BitmapDescriptor
    if (color == Colors.red) {
      return BitmapDescriptor.hueRed;
    } else if (color == Colors.blue) {
      return BitmapDescriptor.hueBlue;
    } else if (color == Colors.green) {
      return BitmapDescriptor.hueGreen;
    } else if (color == Colors.orange) {
      return BitmapDescriptor.hueOrange;
    } else if (color == Colors.yellow) {
      return BitmapDescriptor.hueYellow;
    } else if (color == Colors.purple) {
      return BitmapDescriptor.hueViolet;
    } else if (color == Colors.pink) {
      return BitmapDescriptor.hueRose;
    } else if (color == Colors.cyan) {
      return BitmapDescriptor.hueCyan;
    } else if (color == Colors.black) {
      return BitmapDescriptor.hueAzure;
    } else {
      return BitmapDescriptor.hueAzure; // Default hue for unknown colors
    }
  }

  Widget _buildLegend(String title) {
    Color legendColor = _getColorForNotificationType(title);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            color: legendColor,
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
