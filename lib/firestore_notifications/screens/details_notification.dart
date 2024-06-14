import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:aurb/firestore_notifications/models/notification.dart';
import 'package:intl/intl.dart';
import 'package:aurb/authentication/screens/sections/header.dart'; // Importe o Header
import 'package:aurb/firestore_notifications/services/notification_service.dart'; // Importe o serviço de notificação
import 'package:aurb/components/my_textfield.dart';
import 'package:aurb/screens/home.dart'; // Importe a tela Home

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
  late TextEditingController _riscoController;
  late TextEditingController _dataController;
  late TextEditingController _descricaoController;
  late TextEditingController _empresaController;
  late TextEditingController _linhaController;

  @override
  void initState() {
    super.initState();
    _statusController =
        TextEditingController(text: widget.notification.status ?? '');
    _tipoController = TextEditingController(text: widget.notification.tipo);
    _naturezaController =
        TextEditingController(text: widget.notification.natureza ?? '');
    _riscoController = TextEditingController(text: widget.notification.risco);
    _dataController = TextEditingController(
        text: DateFormat('dd/MM/yyyy')
            .format(DateTime.parse(widget.notification.data)));
    _descricaoController =
        TextEditingController(text: widget.notification.descricao ?? '');
    _empresaController =
        TextEditingController(text: widget.notification.empresa ?? '');
    _linhaController =
        TextEditingController(text: widget.notification.linha ?? '');
  }

  @override
  void dispose() {
    _statusController.dispose();
    _tipoController.dispose();
    _naturezaController.dispose();
    _riscoController.dispose();
    _dataController.dispose();
    _descricaoController.dispose();
    _empresaController.dispose();
    _linhaController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    UserNotification updatedNotification = UserNotification(
      id: widget.notification.id,
      status: _statusController.text,
      tipo: _tipoController.text,
      natureza: _naturezaController.text,
      risco: _riscoController.text,
      data: widget.notification.data, // Assuming date is not editable
      descricao: _descricaoController.text,
      empresa: _empresaController.text,
      linha: _linhaController.text,
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
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Notificação'),
          content: const Text(
            'Tem certeza que deseja excluir esta notificação?',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancela a exclusão
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Cor de fundo vermelha
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Notificação'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEditableField('Risco', _riscoController),
                const SizedBox(height: 8),
                _buildEditableField('Data', _dataController,
                    readOnly: true), // Assuming date is not editable
                const SizedBox(height: 8),
                _buildEditableField('Descrição', _descricaoController),
                const SizedBox(height: 8),
                if (_empresaController.text.isNotEmpty)
                  _buildEditableField('Empresa', _empresaController),
                const SizedBox(height: 8),
                if (_linhaController.text.isNotEmpty)
                  _buildEditableField('Linha', _linhaController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Cor de fundo verde
              ),
              child: const Text('Cancelar',
                  style: TextStyle(color: Colors.black)), // Texto preto
            ),
            ElevatedButton(
              onPressed: () async {
                await _saveChanges();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Cor de fundo verde
              ),
              child: const Text('Salvar Alterações',
                  style: TextStyle(color: Colors.black)), // Texto preto
            ),
          ],
        );
      },
    );
  }

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
              const SizedBox(height: 25),
              Padding(
                padding: const EdgeInsets.all(16.0),
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
                    const SizedBox(height: 8),
                    _buildNonEditableField(
                        'Status', widget.notification.status ?? ''),
                    const SizedBox(height: 8),
                    _buildNonEditableField(
                        'Tipo', widget.notification.tipo ?? ''),
                    const SizedBox(height: 8),
                    _buildNonEditableField(
                        'Natureza', widget.notification.natureza ?? ''),
                    const SizedBox(height: 8),
                    _buildNonEditableField('Risco', widget.notification.risco),
                    const SizedBox(height: 8),
                    _buildNonEditableField(
                        'Data',
                        DateFormat('dd/MM/yyyy')
                            .format(DateTime.parse(widget.notification.data))),
                    const SizedBox(height: 8),
                    _buildNonEditableField(
                        'Descrição', widget.notification.descricao ?? ''),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _openEditModal,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: Text(
                            'Editar',
                            style: TextStyle(
                                color: Colors.black), // Cor do texto preto
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: _deleteNotification,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: Text(
                            'Excluir',
                            style: TextStyle(
                                color: Colors.black), // Cor do texto preto
                          ),
                        ),
                      ],
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

  Widget _buildEditableField(String label, TextEditingController controller,
      {bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
