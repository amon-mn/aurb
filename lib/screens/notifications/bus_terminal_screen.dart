import 'package:aurb/components/my_button.dart';
import 'package:aurb/components/my_dropdown.dart';
import 'package:aurb/components/my_textfield.dart';
import 'package:aurb/screens/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aurb/authentication/screens/sections/header.dart';
import 'package:date_time_picker/date_time_picker.dart';

class BusTerminalPage extends StatefulWidget {
  const BusTerminalPage({super.key});

  @override
  _BusTerminalPageState createState() => _BusTerminalPageState();
}

class _BusTerminalPageState extends State<BusTerminalPage> {
  final TextEditingController _controller = TextEditingController();

  ValueNotifier<String> selectedBusTerminal =
      ValueNotifier<String>('Selecione');
  ValueNotifier<String> selectedRisco = ValueNotifier<String>('Selecione');

  String selectedDate = '';
  bool isDateSelected =
      false; // Variável para rastrear se a data foi selecionada
  bool isSwitched = false;

  final itemListBusTerminal = [
    'Selecione',
    'Falta de cobertura',
    'Falta de segurança',
    'Falta de rampa de acesso',
    'Falta de assentos ',
    'Tempo de espera',
    'Ausência de banheiros',
    'Banheiros em mau funcionamento',
    'Falta de indicador de números \ntelefônicos de emergência',
    'Inundações em forte chuva',
    'Terminal/Ponto quebrado \nou deteriorado',
    'Condições de espera em horário \nde pico',
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
                      selectedValueNotifier: selectedBusTerminal,
                      itemsList: itemListBusTerminal,
                      onChanged: (value) {
                        setState(() {
                          selectedBusTerminal.value = value!;
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
                      child: Text(
                        'Local',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
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
                        child: const SizedBox(
                          height: 240,
                          width: 414,
                          child: Image(
                            image: AssetImage('lib/assets/gps.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
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
                        const Icon(
                          Icons.camera_alt,
                          size: 30,
                        ),
                        const SizedBox(width: 2),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Anexar Imagens',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[900],
                            ),
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
                            child: const SizedBox(
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
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Switch(
                          activeColor: const Color.fromARGB(255, 121, 182, 76),
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                            });
                          },
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            'Modo Anônimo',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: Colors.grey[900],
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        SizedBox(
                          height: 40,
                          width: 108,
                          child: MyButton(
                            colorButton:
                                const Color.fromARGB(255, 121, 182, 76),
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
