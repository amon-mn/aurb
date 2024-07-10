import 'package:aurb/firestore_notifications/models/notification_location_controller.dart';
import 'package:flutter/material.dart';
import 'package:aurb/authentication/screens/sections/header.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:aurb/firestore_notifications/models/notification.dart';
import 'package:aurb/firestore_notifications/services/notification_service.dart';
import 'package:provider/provider.dart';

class ControlPanelPage extends StatelessWidget {
  final NotificationService _notificationService = NotificationService();

  ControlPanelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationLocationController(),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Header(
                customIconLeft: Icons.arrow_back,
                customOnPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Consumer<NotificationLocationController>(
                  builder: (context, controller, child) {
                    return FutureBuilder<List<UserNotification>>(
                      future: _notificationService.readAllNotifications(),
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
                        Set<Marker> markers = _buildMarkers(notifications);

                        return Stack(
                          children: [
                            GoogleMap(
                              onMapCreated: controller.onMapCreated,
                              initialCameraPosition: CameraPosition(
                                target: LatLng(controller.lat, controller.long),
                                zoom: 18.0,
                              ),
                              markers: markers,
                              myLocationEnabled: true,
                              myLocationButtonEnabled: true,
                              zoomControlsEnabled: true,
                              mapType: MapType.normal,
                            ),
                            Positioned(
                              top: 12.0,
                              left: 16.0,
                              child: GestureDetector(
                                onTap: () {
                                  _showLegendPanel(context);
                                },
                                child: Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.75),
                                    borderRadius: BorderRadius.circular(2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 0.5,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.all(8),
                                  child: Icon(
                                    Icons.legend_toggle,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
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
      return BitmapDescriptor.hueAzure;
    }
  }

  void _showLegendPanel(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          children: [
            _buildLegend("Sinalização"),
            _buildLegend("Calçamento"),
            _buildLegend("Ruas e Avenidas"),
            _buildLegend("Acessibilidade"),
            _buildLegend("Terminais de Ônibus"),
            _buildLegend("Transporte Público"),
            _buildLegend("Obras"),
            _buildLegend("Obstruções Temporárias"),
            _buildLegend("Uso do Espaço Público"),
            _buildLegend("Outras Notificações"),
          ],
        );
      },
    );
  }

  Widget _buildLegend(String title) {
    Color legendColor = _getColorForNotificationType(title);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            color: legendColor,
          ),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
