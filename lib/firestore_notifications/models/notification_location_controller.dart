import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NotificationLocationController extends ChangeNotifier {
  double lat = 0.0;
  double long = 0.0;
  String error = '';
  GoogleMapController? _mapsController;
  LatLng _newPosition = LatLng(0.0, 0.0);
  bool _disposed = false;

  ValueNotifier<String> addressNotifier =
      ValueNotifier<String>('Carregando endereço...');

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
      _newPosition = LatLng(lat, long);

      if (_mapsController != null && !_disposed) {
        _mapsController!.animateCamera(CameraUpdate.newLatLng(_newPosition));
      }
      await _getAddressFromCoordinates(lat, long);
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
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
    _getAddressFromCoordinates(lat, long);
    notifyListeners();
  }

  setNewPositionWithLatLng(LatLng position) {
    lat = position.latitude;
    long = position.longitude;
    print("Nova posição definida com LongPress: $lat, $long");
    _getAddressFromCoordinates(lat, long);
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

  Future<void> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    final apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'].isNotEmpty) {
          addressNotifier.value = data['results'][0]['formatted_address'];
          print('Endereço encontrado: ${addressNotifier.value}');
        } else {
          addressNotifier.value = 'Endereço não encontrado';
          print(addressNotifier.value);
        }
      } else {
        throw Exception('Erro ao obter o endereço');
      }
    } catch (e) {
      addressNotifier.value = 'Erro ao obter endereço: $e';
      print('Exception in _getAddressFromCoordinates: $e');
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
