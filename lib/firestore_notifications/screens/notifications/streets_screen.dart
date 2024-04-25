import 'package:aurb/components/my_button.dart';
import 'package:aurb/components/my_dropdown.dart';
import 'package:aurb/components/my_textfield.dart';
import 'package:aurb/components/show_snackbar.dart';
import 'package:aurb/firestore_notifications/models/location.dart';
import 'package:aurb/firestore_notifications/models/notification.dart';
import 'package:aurb/firestore_notifications/models/notification_location_controller.dart';
import 'package:aurb/firestore_notifications/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:aurb/authentication/screens/sections/header.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class StreetsPage extends StatefulWidget {
  final String tipo;
  const StreetsPage({super.key, required this.tipo});

  @override
  _StreetsPageState createState() => _StreetsPageState();
}

class _StreetsPageState extends State<StreetsPage> {
  final TextEditingController _controller = TextEditingController();
  NotificationService notificationService = NotificationService();
  double _latNotification = 0.0;
  double _longNotification = 0.0;
  ValueNotifier<String> selectedStreet = ValueNotifier<String>('Selecione');
  ValueNotifier<String> selectedRisco = ValueNotifier<String>('Selecione');

  String selectedDate = '';
  bool isDateSelected =
      false; // Variável para rastrear se a data foi selecionada
  bool isSwitched = false;

  final itemListStreet = [
    'Selecione',
    'Condições de trafegabilidade',
    'Rua estreita',
    'Buraco na via',
    'Inexistência de calçada e meio fio',
    'Ausência de sinal. Horizontal',
    'Ausência de faixa de pedestre',
    'Rua/Av. não asfaltada',
    'Estacionamento em fila dupla',
    'Estacionamento nas duas margens',
    'Outros...',
  ];

  final itemListRisco = [
    'Selecione',
    'Nenhum',
    'Baixo',
    'Médio',
    'Alto',
    'Extremo',
  ];

  GoogleMapController? _mapController;
  LatLng _center = const LatLng(-23.550520, -46.633308); // Initial map center
  bool isMapFullScreen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                customIcon: Icons.arrow_back,
                customOnPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Natureza da Notificação',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    MyDropdownFormField(
                      selectedValueNotifier: selectedStreet,
                      itemsList: itemListStreet,
                      onChanged: (value) {
                        setState(() {
                          selectedStreet.value = value!;
                        });
                      },
                    ),
                    SizedBox(height: 24),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Breve descrição da observação',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    MyTextFieldWrapper(
                      hintText: 'Digite sua mensagem',
                      controller: _controller,
                      obscureText: false,
                    ),
                    SizedBox(height: 24),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Local',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isMapFullScreen = !isMapFullScreen;
                              });
                            },
                            child: Container(
                              height: isMapFullScreen ? 400 : 240,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.5),
                                child: ChangeNotifierProvider<
                                    NotificationLocationController>(
                                  create: (context) =>
                                      NotificationLocationController(),
                                  child: Builder(
                                    builder: (context) {
                                      final local = context.watch<
                                          NotificationLocationController>();
                                      if (local.error == "") {
                                        _latNotification = local.lat;
                                        _longNotification = local.long;
                                        return GoogleMap(
                                          initialCameraPosition: CameraPosition(
                                            target: LatLng(-3.100055312439282,
                                                -59.97655211153541),
                                            zoom: 18.0,
                                          ),
                                          zoomControlsEnabled: true,
                                          mapType: MapType.normal,
                                          onMapCreated: local.onMapCreated,
                                          markers: {
                                            Marker(
                                              markerId: MarkerId("MarkerId"),
                                              position: LatLng(_latNotification,
                                                  _longNotification),
                                              infoWindow: const InfoWindow(
                                                  title: "Sua Localização"),
                                              icon: BitmapDescriptor
                                                  .defaultMarker,
                                            ),
                                          },
                                        );
                                      } else {
                                        // Caso haja erro, exibir a mensagem de erro
                                        return Container(
                                          alignment: Alignment.topLeft,
                                          padding: EdgeInsets.only(left: 10),
                                          child: Text(
                                            local.error,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey[900],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Avaliação de Risco',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                    SizedBox(height: 4),
                    MyDropdownFormField(
                      selectedValueNotifier: selectedRisco,
                      itemsList: itemListRisco,
                      onChanged: (value) {
                        setState(() {
                          selectedRisco.value = value!;
                        });
                      },
                    ),
                    SizedBox(height: 24),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Data da Observação',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 124, 124, 124),
                          ),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: SizedBox(
                          height: 30,
                          width: 414,
                          child: DateTimePicker(
                            type: DateTimePickerType.date,
                            dateMask: 'dd/MM/yyyy',
                            initialValue:
                                selectedDate.isEmpty ? null : selectedDate,
                            firstDate: DateTime(2023),
                            lastDate: DateTime(2030),
                            icon: Icon(
                              Icons.calendar_today,
                              color: Colors.black,
                            ),
                            dateLabelText: '',
                            onChanged: (val) {
                              setState(() {
                                selectedDate = val.isEmpty ? '' : val;
                              });
                            },
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[900]!,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.camera_alt,
                          size: 30,
                        ),
                        SizedBox(width: 2),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Anexar Imagens',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: SizedBox(
                              height: 22,
                              width: 48,
                              child: Center(
                                child: Text('6'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Switch(
                            activeColor: Color.fromARGB(255, 121, 182, 76),
                            value: isSwitched,
                            onChanged: (value) {
                              setState(() {
                                isSwitched = value;
                              });
                            },
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Modo Anônimo',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.grey[900],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: SizedBox(
                            height: 40,
                            child: MyButton(
                              colorButton: Color.fromARGB(255, 121, 182, 76),
                              textSize: 14,
                              onTap: () {
                                UserNotification notification =
                                    UserNotification(
                                  id: Uuid().v4(),
                                  descricao: _controller.text,
                                  tipo: widget.tipo,
                                  natureza: selectedStreet.value,
                                  risco: selectedRisco.value,
                                  data: selectedDate,
                                  loc: Location(
                                    latitude: _latNotification,
                                    longitude: _longNotification,
                                  ),
                                  status: "Não Iniciado",
                                );

                                // Adicione a notificação utilizando o serviço de gerenciamento
                                notificationService.addNotification(
                                    notification: notification);

                                // Feche a página e exiba um snackbar para indicar que a notificação foi enviada com sucesso
                                Navigator.pop(context);
                                showSnackBar(
                                  context: context,
                                  mensagem: 'Notificação enviada com sucesso.',
                                  isErro: false,
                                );
                              },
                              textButton: 'Enviar',
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 54),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
