import 'dart:io';

import 'package:aurb/components/my_button.dart';
import 'package:aurb/components/my_dropdown.dart';
import 'package:aurb/components/my_textfield.dart';
import 'package:aurb/components/show_snackbar.dart';
import 'package:aurb/firestore_notifications/models/location.dart';
import 'package:aurb/firestore_notifications/models/notification.dart';
import 'package:aurb/firestore_notifications/models/notification_location_controller.dart';
import 'package:aurb/firestore_notifications/services/notification_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:aurb/authentication/screens/sections/header.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class PublicSpacePage extends StatefulWidget {
  final String tipo;
  const PublicSpacePage({super.key, required this.tipo});

  @override
  _PublicSpacePageState createState() => _PublicSpacePageState();
}

class _PublicSpacePageState extends State<PublicSpacePage> {
  final TextEditingController _controller = TextEditingController();
  NotificationService notificationService = NotificationService();
  double _latNotification = 0.0;
  double _longNotification = 0.0;
  ValueNotifier<String> selectedPS = ValueNotifier<String>('Selecione');
  ValueNotifier<String> selectedRisco = ValueNotifier<String>('Selecione');

  String selectedDate = '';
  bool isDateSelected =
      false; // Variável para rastrear se a data foi selecionada
  bool isSwitched = false;

  final itemListPS = [
    'Selecione',
    'Muros e cercas',
    'Objetos relacionados a materiais \nde construção',
    'Lixo',
    'Materiais derrapantes e jardins \nou desníveis',
    'Ocupação por empreendimentos \ncomerciais.',
    'Postes e árvores',
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

  final FirebaseStorage storage = FirebaseStorage.instance;
  ValueNotifier<bool> isUploadingNotifier = ValueNotifier<bool>(false);
  ValueNotifier<int> numberOfImagesSelectedNotifier = ValueNotifier<int>(0);
  List<XFile> selectedImages = [];
  bool uploading = false;
  double progress = 0.0;

  Future<XFile?> getImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<void> upload(XFile file) async {
    isUploadingNotifier.value = true;
    String ref = 'images/img-${DateTime.now().toString()}.jpeg';
    Reference storageRef = FirebaseStorage.instance.ref().child(ref);

    UploadTask task = storageRef.putFile(
      File(file.path),
      SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {
          'user': '123',
        },
      ),
    );
    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      if (snapshot.state == TaskState.running) {
        setState(() {
          uploading = true;
          progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        });
      } else if (snapshot.state == TaskState.success) {
        setState(() {
          uploading = false;
          progress = 100.0;
          // Incrementa o contador de imagens enviadas com sucesso
          int currentCount = numberOfImagesSelectedNotifier.value;
          numberOfImagesSelectedNotifier.value = currentCount + 1;
        });
      }
    });
    await task;
    isUploadingNotifier.value = false;
  }

  void pickAndUploadImage() async {
    XFile? file = await getImage();
    if (file != null) {
      await upload(file);
    }
  } // Initial map center

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
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 10),
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
                      selectedValueNotifier: selectedPS,
                      itemsList: itemListPS,
                      onChanged: (value) {
                        setState(() {
                          selectedPS.value = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Breve descrição da observação',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    MyTextFieldWrapper(
                      hintText: 'Digite sua mensagem',
                      controller: _controller,
                      obscureText: false,
                    ),
                    const SizedBox(height: 24),
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
                                          initialCameraPosition: const CameraPosition(
                                            target: LatLng(-3.100055312439282,
                                                -59.97655211153541),
                                            zoom: 18.0,
                                          ),
                                          zoomControlsEnabled: true,
                                          mapType: MapType.normal,
                                          onMapCreated: local.onMapCreated,
                                          markers: {
                                            Marker(
                                              markerId: const MarkerId("MarkerId"),
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
                                          padding: const EdgeInsets.only(left: 10),
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
                    const SizedBox(height: 24),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Avaliação de Risco',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    MyDropdownFormField(
                      selectedValueNotifier: selectedRisco,
                      itemsList: itemListRisco,
                      onChanged: (value) {
                        setState(() {
                          selectedRisco.value = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.only(left: 10),
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
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 124, 124, 124),
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
                            icon: const Icon(
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
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            pickAndUploadImage();
                          },
                          child: ValueListenableBuilder<bool>(
                            valueListenable: isUploadingNotifier,
                            builder: (context, isUploading, child) {
                              return Row(
                                children: [
                                  if (isUploading)
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(right: 16.0),
                                      child: SizedBox(
                                        width: 15,
                                        height: 15,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    )
                                  else
                                    const Icon(
                                      Icons.camera_alt,
                                      size: 30,
                                    ),
                                  const SizedBox(width: 2),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      isUploading
                                          ? '${progress.round()}% enviado'
                                          : 'Anexar Imagens',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[900],
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: ValueListenableBuilder<int>(
                              valueListenable: numberOfImagesSelectedNotifier,
                              builder: (context, value, child) {
                                return SizedBox(
                                  height: 22,
                                  width: 48,
                                  child: Center(
                                    child: Text(
                                      '$value',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[900],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Switch(
                            activeColor: const Color.fromARGB(255, 121, 182, 76),
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
                              colorButton: const Color.fromARGB(255, 121, 182, 76),
                              textSize: 14,
                              onTap: () {
                                UserNotification notification =
                                    UserNotification(
                                  id: const Uuid().v4(),
                                  descricao: _controller.text,
                                  tipo: widget.tipo,
                                  natureza: selectedPS.value,
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
                    const SizedBox(height: 54),
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
