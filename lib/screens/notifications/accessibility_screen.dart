import 'package:aurb/components/my_dropdown.dart';
import 'package:aurb/components/my_textfield.dart';
import 'package:flutter/material.dart';
import 'package:aurb/screens/sections/header.dart';

class AccessibilityPage extends StatefulWidget {
  @override
  _AccessibilityPageState createState() => _AccessibilityPageState();
}

class _AccessibilityPageState extends State<AccessibilityPage> {
  final TextEditingController _controller = TextEditingController();

  ValueNotifier<String> selectedAcessibility =
      ValueNotifier<String>('Selecione');

  final itemListAccessibility = [
    'Selecione',
    'Falta de rampa de acesso calçadas',
    'Falta de rampa de acesso escadas',
    'Falta de rampa de acesso órg. púb.',
    'Falta de rampa de acesso passarelas',
    'Falta de rampa de acesso a terminais de ônibus',
    'Falta de material antiderrapante',
    'Falta de piso tátil direcional/alerta',
    'Falta de localizador para cegos',
    'Material escorregadio',
    'Outros...',
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
              SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40), // Margem lateral
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
                      selectedValueNotifier: selectedAcessibility,
                      itemsList: itemListAccessibility,
                      onChanged: (value) {
                        setState(() {
                          selectedAcessibility.value = value!;
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
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        'Local',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        borderRadius: BorderRadius.zero,
                      ),
                      child: SizedBox(height: 240, width: 420,
                                              child: Image(
                          image: AssetImage('lib/assets/fotoMapa.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    
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
