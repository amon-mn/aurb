import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/*
class NotificationLocationController extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  String error = '';
  GoogleMapController? _mapsController;
  bool _disposed = false; // Adiciona uma variável para rastrear se foi descartado

  GoogleMapController? get mapsController => _mapsController;

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    await getPosition();
  }

  getPosition() async {
    try {
      Position position = await _currentPosition();
      lat = position.latitude;
      long = position.longitude;
      if (_mapsController != null && !_disposed) {
        _mapsController!.animateCamera(CameraUpdate.newLatLng(LatLng(lat, long)));
      }
    } catch (e) {
      error = e.toString();
    }
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<Position> _currentPosition() async {
    LocationPermission permission;
    bool isActive = await Geolocator.isLocationServiceEnabled();

    if (!isActive) {
      return Future.error('Por favor, habilite a localização no smartphone');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso à localização');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Você precisa autorizar o acesso à localização');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  void dispose() {
    _disposed = true; // Marca como descartado antes de chamar o super.dispose()
    super.dispose();
  }
}
*/
class NotificationLocationController extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  String error = '';
  late GoogleMapController _mapsController;
  LatLng _newPosition = LatLng(0.0, 0.0);

  get mapsController => _mapsController;

  onMapCreated(GoogleMapController gmc) async {
    _mapsController = gmc;
    await getPosition();
  }

  getPosition() async {
    try {
      Position position = await _currentPosition();
      lat = position.latitude;
      long = position.longitude;
      _newPosition = LatLng(lat, long);
      _mapsController.animateCamera(CameraUpdate.newLatLng(_newPosition));
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }

  updatePosition(LatLng position) {
    _newPosition = position;
    print(
        "Nova posição atualizada: ${_newPosition.latitude}, ${_newPosition.longitude}");
    notifyListeners();
  }

  setNewPosition() {
    lat = _newPosition.latitude;
    long = _newPosition.longitude;
    print("Posição final definida: $lat, $long");
    notifyListeners();
  }

  Future<Position> _currentPosition() async {
    LocationPermission permission;
    bool isActive = await Geolocator.isLocationServiceEnabled();

    if (!isActive) {
      return Future.error('Por favor, habilite a localização no smartphone');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Você precisa autorizar o acesso à localização');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Você precisa autorizar o acesso à localização');
    }

    return await Geolocator.getCurrentPosition();
  }
}
