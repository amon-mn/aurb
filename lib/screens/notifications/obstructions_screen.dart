import 'package:aurb/components/my_button.dart';
import 'package:aurb/components/my_dropdown.dart';
import 'package:aurb/components/my_textfield.dart';
import 'package:aurb/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aurb/authentication/screens/sections/header.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ObstructionsPage extends StatefulWidget {
  const ObstructionsPage({super.key});

  @override
  _ObstructionsPageState createState() => _ObstructionsPageState();
}

class _ObstructionsPageState extends State<ObstructionsPage> {
  final TextEditingController _controller = TextEditingController();

  ValueNotifier<String> selectedObstruction =
      ValueNotifier<String>('Selecione');
  ValueNotifier<String> selectedRisco = ValueNotifier<String>('Selecione');

  String selectedDate = '';
  bool isDateSelected =
      false; // Variável para rastrear se a data foi selecionada
  bool isSwitched = false;

  final itemListObstruction = [
    'Selecione',
    'Construção',
    'Lixo',
    'Bueiros sem tampa',
    'Calçada quebrada',
    'Encanamento rompido'
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
                      selectedValueNotifier: selectedObstruction,
                      itemsList: itemListObstruction,
                      onChanged: (value) {
                        setState(() {
                          selectedObstruction.value = value!;
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
                                child: GoogleMap(
                                  onMapCreated: (controller) {
                                    _mapController = controller;
                                  },
                                  initialCameraPosition: CameraPosition(
                                    target: _center,
                                    zoom: 15.0,
                                  ),
                                  markers: <Marker>[
                                    Marker(
                                      markerId: MarkerId("marker_1"),
                                      position: _center,
                                      infoWindow: const InfoWindow(
                                        title: 'Marker Title',
                                        snippet: 'Marker Snippet',
                                      ),
                                    ),
                                  ].toSet(),
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Switch(
                          activeColor: Color.fromARGB(255, 121, 182, 76),
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                            });
                          },
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Modo Anônimo',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey[900],
                            ),
                          ),
                        ),
                        SizedBox(width: 24),
                        SizedBox(
                          height: 40,
                          width: 108,
                          child: MyButton(
                            colorButton: Color.fromARGB(255, 121, 182, 76),
                            textSize: 14,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                          user: FirebaseAuth
                                              .instance.currentUser!,
                                        )),
                              );
                            },
                            textButton: 'Enviar',
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
