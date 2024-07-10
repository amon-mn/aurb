import 'package:aurb/components/my_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:aurb/firestore_notifications/models/notification.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:aurb/authentication/screens/sections/header.dart';
import 'package:aurb/firestore_notifications/services/notification_service.dart';
import 'package:aurb/components/my_textfield.dart';
import 'package:aurb/screens/home.dart';
import 'package:date_time_picker/date_time_picker.dart';

class DetailsNotificationPage extends StatefulWidget {
  final UserNotification notification;

  const DetailsNotificationPage({Key? key, required this.notification})
      : super(key: key);

  @override
  _DetailsNotificationPageState createState() =>
      _DetailsNotificationPageState();
}

class _DetailsNotificationPageState extends State<DetailsNotificationPage> {
  late TextEditingController _statusController;
  late TextEditingController _tipoController;
  late TextEditingController _naturezaController;
  late TextEditingController _descricaoController;
  late TextEditingController _empresaController;
  late TextEditingController _linhaController;
  late ValueNotifier<String> _selectedRisco;
  late ValueNotifier<String> _selectedEmpresa;
  late ValueNotifier<String> _selectedLinha;
  late CameraPosition _initialCameraPosition;
  String _selectedDate = '';
  List<String> _imageUrls = [];

  final itemListRisco = [
    'Selecione',
    'Nenhum',
    'Baixo',
    'Médio',
    'Alto',
    'Extremo',
  ];

  final itemListEmpresas = [
    'Selecione',
    'Rondônia Transportes Ltda.',
    'Viação São Pedro Ltda.',
    'Viação Nova Integração Ltda.',
    'Via Verde Transportes Col. Ltda.',
    'Expresso Coroado Transportes Col. Ltda.',
    'Global Green Transportes Ltda.',
    'Outros...',
  ];

  final itemListLinhas = [
    'Selecione',
    '003',
    '011',
    '055',
    '059',
    '126',
    '205',
    '212',
    '306',
    '316',
    '318',
    '323',
    '427',
    '455',
    '458',
    'Outros...',
  ];

  @override
  void initState() {
    super.initState();
    final location = widget.notification.loc;
    _initialCameraPosition = CameraPosition(
      target: LatLng(location?.latitude ?? 0.0, location?.longitude ?? 0.0),
      zoom: 18,
    );

    _statusController =
        TextEditingController(text: widget.notification.status ?? '');
    _tipoController = TextEditingController(text: widget.notification.tipo);
    _naturezaController =
        TextEditingController(text: widget.notification.natureza ?? '');
    _selectedRisco = ValueNotifier<String>(
      itemListRisco.contains(widget.notification.risco)
          ? widget.notification.risco
          : 'Selecione',
    );
    _selectedDate = widget.notification.data.isNotEmpty
        ? DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(widget.notification.data))
        : '';
    _descricaoController =
        TextEditingController(text: widget.notification.descricao ?? '');
    _empresaController =
        TextEditingController(text: widget.notification.empresa ?? '');
    _linhaController =
        TextEditingController(text: widget.notification.linha ?? '');

    // Verificação de autenticação antes de carregar as imagens
    if (FirebaseAuth.instance.currentUser != null) {
      _loadImages();
    } else {
      // Usuário não autenticado, trate conforme necessário
      print('Usuário não autenticado');
      // Aqui você pode decidir o que fazer se o usuário não estiver autenticado,
      // como mostrar uma mensagem ou redirecioná-lo para o login.
    }

    // Verifica se o valor de empresa não está vazio para decidir se deve ser incluído na lista
    if (widget.notification.empresa != null &&
        widget.notification.empresa!.isNotEmpty) {
      _selectedEmpresa = ValueNotifier<String>(
        itemListEmpresas.contains(widget.notification.empresa ?? '')
            ? widget.notification.empresa ?? ''
            : 'Selecione',
      );
    } else {
      _selectedEmpresa = ValueNotifier<String>('Selecione');
    }

    // Verifica se o valor da linha não está vazio para decidir se deve ser incluído na lista
    if (widget.notification.linha != null &&
        widget.notification.linha!.isNotEmpty) {
      _selectedLinha = ValueNotifier<String>(
        itemListLinhas.contains(widget.notification.linha ?? '')
            ? widget.notification.linha ?? ''
            : 'Selecione',
      );
    } else {
      _selectedLinha = ValueNotifier<String>('Selecione');
    }
  }

  void _onMapCreated(GoogleMapController controller) {}

  Future<void> _loadImages() async {
    try {
      String notificationId = widget.notification.id;
      final ListResult result =
          await FirebaseStorage.instance.ref().child('images/').listAll();

      List<String> imageUrls = [];
      await Future.forEach(result.items, (Reference ref) async {
        // Verifica se a imagem pertence à notificação específica
        if (ref.name.contains(notificationId)) {
          String url = await ref.getDownloadURL();
          imageUrls.add(url);
        }
      });

      setState(() {
        _imageUrls = imageUrls;
      });
    } catch (e) {
      print('Erro ao carregar imagens: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Erro ao carregar imagens: $e'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _statusController.dispose();
    _tipoController.dispose();
    _naturezaController.dispose();
    _descricaoController.dispose();
    _empresaController.dispose();
    _linhaController.dispose();
    _selectedRisco.dispose();
    _selectedEmpresa.dispose();
    _selectedLinha.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    UserNotification updatedNotification = UserNotification(
      id: widget.notification.id,
      status: _statusController.text,
      tipo: _tipoController.text,
      natureza: _naturezaController.text,
      risco: _selectedRisco.value,
      data: DateFormat('yyyy-MM-dd')
          .parse(_selectedDate)
          .toIso8601String(), // Update the date format
      descricao: _descricaoController.text,
      empresa: _selectedEmpresa.value, // Inclui a empresa selecionada
      linha: _selectedLinha.value,
    );

    await NotificationService().updateNotification(updatedNotification);

    Navigator.pop(context); // Fecha o modal de edição

    // Redireciona para a tela HomeScreen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) =>
              HomeScreen(user: FirebaseAuth.instance.currentUser!)),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: const Text(
          'Notificação Atualizada com Sucesso',
        ),
      ),
    );
  }

  Future<void> _deleteNotification() async {
    if (widget.notification.status != "Não Iniciado") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Exclusão não permitida'),
            content: const Text(
              'Apenas notificações com o status "Não Iniciado" podem ser excluídas.',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Notificação'),
          content: const Text(
            'Tem certeza que deseja excluir esta notificação?',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancela a exclusão
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Cor de fundo verde
              ),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirma a exclusão
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Cor de fundo vermelha
              ),
              child: const Text(
                'Excluir',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );

    if (confirmDelete) {
      await NotificationService()
          .removeNotification(notificationId: widget.notification.id);
      Navigator.pop(context); // Fecha o modal de edição
      Navigator.pop(
          context); // Volta para a tela anterior (notification_screen.dart)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red, // Cor de fundo vermelha
          content: const Text(
            'Notificação Excluída com Sucesso',
          ), // Texto preto
        ),
      );
    }
  }

  void _openEditModal() {
    if (widget.notification.status == "Não Iniciado") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          String localSelectedDate = _selectedDate;
          TextEditingController localDescricaoController =
              TextEditingController(text: _descricaoController.text);
          TextEditingController localEmpresaController =
              TextEditingController(text: _empresaController.text);
          TextEditingController localLinhaController =
              TextEditingController(text: _linhaController.text);

          // Criar um ValueNotifier local para gerenciar o estado do dropdown no modal
          ValueNotifier<String> localSelectedRisco =
              ValueNotifier<String>(_selectedRisco.value);
          ValueNotifier<String> localSelectedEmpresa =
              ValueNotifier<String>(_selectedEmpresa.value);
          ValueNotifier<String> localSelectedLinha =
              ValueNotifier<String>(_selectedLinha.value);

          return AlertDialog(
            title: const Text('Editar Notificação'),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDatePickerField(
                          'Data da Observação', localSelectedDate,
                          (String val) {
                        setState(() {
                          localSelectedDate = val;
                        });
                      }),
                      const SizedBox(height: 12),
                      _buildEditableField(
                          'Descrição da Observação', localDescricaoController),
                      const SizedBox(height: 12),
                      _buildDropdownField('Avaliação de Risco',
                          localSelectedRisco, itemListRisco),
                      const SizedBox(height: 12),
                      if (localEmpresaController.text.isNotEmpty)
                        _buildDropdownField('Nome da Empresa',
                            localSelectedEmpresa, itemListEmpresas),
                      const SizedBox(height: 12),
                      if (localLinhaController.text.isNotEmpty)
                        _buildDropdownField('Número da Linha',
                            localSelectedLinha, itemListLinhas),
                    ],
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = localSelectedDate;
                    _descricaoController.text = localDescricaoController.text;
                    _selectedRisco.value = localSelectedRisco.value;
                    _selectedEmpresa.value = localSelectedEmpresa.value;
                    _selectedLinha.value = localSelectedLinha.value;
                  });
                  Navigator.of(context).pop();
                  _saveChanges();
                },
                child: const Text('Salvar'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Edição não permitida'),
            content: const Text(
              'Apenas notificações com o status "Não Iniciado" podem ser editadas.',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildDropdownField(String label,
      ValueNotifier<String> selectedValueNotifier, List<String> itemsList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        MyDropdownFormField(
          selectedValueNotifier: selectedValueNotifier,
          itemsList: itemsList,
          onChanged: (value) {
            selectedValueNotifier.value = value!;
          },
        ),
      ],
    );
  }

  Widget _buildDatePickerField(
      String label, String initialValue, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Container(
            height: 48, // Altura reduzida para 48
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100, // Cor de fundo verde claro
              border: Border.all(
                color: Color.fromRGBO(
                    49, 28, 28, 1), // Cor da borda verde mais escura
              ),
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: DateTimePicker(
              type: DateTimePickerType.date,
              dateMask: 'dd/MM/yyyy',
              initialValue: initialValue,
              firstDate: DateTime(2023),
              lastDate: DateTime(2030),
              icon: const Icon(
                Icons.calendar_today,
                color: Colors.black,
              ),
              dateLabelText: '',
              onChanged: onChanged,
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(33, 33, 33, 1.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final location = widget.notification.loc;
    final String address = location?.endereco ?? 'Endereço não disponível';
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Header(
                customIconLeft: Icons.arrow_back,
                customOnPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID: ${widget.notification.id.substring(0, 8)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildNonEditableField('Status da Notificação',
                        widget.notification.status ?? ''),
                    const SizedBox(height: 10),
                    _buildNonEditableField(
                        'Tipo da Notificação', widget.notification.tipo),
                    const SizedBox(height: 10),
                    _buildNonEditableField('Natureza da Notificação',
                        widget.notification.natureza ?? ''),
                    const SizedBox(height: 10),
                    _buildNonEditableField(
                        'Avaliação de Risco', widget.notification.risco),
                    const SizedBox(height: 10),
                    _buildNonEditableField(
                        'Data da Observação',
                        DateFormat('dd/MM/yyyy')
                            .format(DateTime.parse(widget.notification.data))),
                    const SizedBox(height: 10),
                    _buildNonEditableField('Descrição da Observação',
                        widget.notification.descricao ?? ''),
                    const SizedBox(height: 10),
                    _buildNonEditableField('Endereço', address),
                    const SizedBox(height: 10),
                    if (widget.notification.empresa?.isNotEmpty ?? false)
                      _buildNonEditableField(
                          'Nome da Empresa', widget.notification.empresa ?? ''),
                    const SizedBox(height: 10),
                    if (widget.notification.linha?.isNotEmpty ?? false)
                      _buildNonEditableField(
                          'Número da Linha', widget.notification.linha ?? ''),
                    const SizedBox(height: 10),
                    Text(
                      "Localização",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            12.0), // Raio do arredondamento das bordas
                        border: Border.all(
                          color: Colors.grey, // Cor da borda
                          width: 2.0, // Largura da borda em pixels
                        ),
                      ),
                      height: 200,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                            12.0), // Raio do arredondamento das bordas
                        child: GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: _initialCameraPosition,
                          markers: {
                            Marker(
                              markerId: MarkerId(widget.notification.id),
                              position: LatLng(location?.latitude ?? 0.0,
                                  location?.longitude ?? 0.0),
                            ),
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Imagens da Notificação',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _imageUrls.isNotEmpty
                        ? GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                            ),
                            itemCount: _imageUrls.length,
                            itemBuilder: (context, index) {
                              return Image.network(_imageUrls[index]);
                            },
                          )
                        : const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Text('Nenhuma imagem registrada'),
                          ),
                    const SizedBox(height: 24),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _openEditModal,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: Size(
                                  100, 30), // Aumenta o tamanho mínimo do botão
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical:
                                      12), // Ajusta o preenchimento interno
                            ),
                            child: Text(
                              'Editar',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ), // Cor do texto preto
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _deleteNotification,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              minimumSize: Size(
                                  100, 30), // Aumenta o tamanho mínimo do botão
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical:
                                      12), // Ajusta o preenchimento interno
                            ),
                            child: Text(
                              'Excluir',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ), // Cor do texto preto
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16), // Espaçamento após os botões
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller,
      {bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        MyTextFieldWrapper(
          controller: controller,
          obscureText: false,
        ),
      ],
    );
  }

  Widget _buildNonEditableField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
