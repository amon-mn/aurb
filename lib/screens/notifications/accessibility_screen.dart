import 'package:aurb/components/my_button.dart';
import 'package:aurb/components/my_dropdown.dart';
import 'package:aurb/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:aurb/authentication/screens/sections/header.dart';
import 'package:date_time_picker/date_time_picker.dart';

class AccessibilityPage extends StatefulWidget {
  const AccessibilityPage({super.key});

  @override
  _AccessibilityPageState createState() => _AccessibilityPageState();
}

class _AccessibilityPageState extends State<AccessibilityPage> {
  final TextEditingController _controller = TextEditingController();

  ValueNotifier<String> selectedAcessibility =
      ValueNotifier<String>('Selecione');
  ValueNotifier<String> selectedRisco = ValueNotifier<String>('Selecione');

  String selectedDate = '';
  bool isDateSelected =
      false; // Variável para rastrear se a data foi selecionada
  bool isSwitched = false;

  final itemListAccessibility = [
    'Selecione',
    'Falta de rampa de acesso calçadas',
    'Falta de rampa de acesso escadas',
    'Falta de rampa de acesso órg. púb',
    'Falta de rampa de acesso passarelas',
    'Falta de rampa de acesso a \n pontos/terminais de ônibus',
    'Falta de acesso a cadeirantes em ônibus',
    'Falta de material antiderrapante',
    'Falta de piso tátil direcional/alerta',
    'Falta de localzador para cegos',
    'Material escorregadio',
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 40), // Margem lateral
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
                      selectedValueNotifier: selectedAcessibility,
                      itemsList: itemListAccessibility,
                      onChanged: (value) {
                        setState(() {
                          selectedAcessibility.value = value!;
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
                              initialValue: selectedDate.isEmpty
                                  ? null
                                  : selectedDate, // Defina como null quando estiver vazio
                              firstDate: DateTime(2023),
                              lastDate: DateTime(2030),
                              icon: const Icon(
                                Icons.calendar_today,
                                color: Colors.black,
                              ),
                              dateLabelText: '',
                              onChanged: (val) {
                                setState(() {
                                  selectedDate = val.isEmpty
                                      ? ''
                                      : val; // Defina como vazio se for nulo
                                });
                              },
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey[900]!,
                              ),
                            )),
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
                                child: Text(
                                    '6'), // Alinha o texto ao centro do Container
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
                            textSize: 14,
                            colorButton:
                                const Color.fromARGB(255, 121, 182, 76),
                            onTap: () {},
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
