import 'package:flutter/material.dart';
import 'package:aurb/authentication/screens/sections/header.dart';
import 'package:intl/intl.dart';
import 'package:aurb/firestore_notifications/models/notification.dart';
import 'package:aurb/firestore_notifications/services/notification_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AdmDetailsNotificationPage extends StatefulWidget {
  final UserNotification notification;

  const AdmDetailsNotificationPage({Key? key, required this.notification})
      : super(key: key);

  @override
  _AdmDetailsNotificationPageState createState() =>
      _AdmDetailsNotificationPageState();
}

class _AdmDetailsNotificationPageState
    extends State<AdmDetailsNotificationPage> {
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _statusController = TextEditingController(text: widget.notification.status);
  }

  @override
  void dispose() {
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final location = widget.notification.loc;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(64.0),
        child: SafeArea(child: Header()),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalhes da Ocorrência',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'ID: ${widget.notification.id}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Status: ${widget.notification.status}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (widget.notification.isAnonymous == false)
                Column(
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'UserID: ${widget.notification.authorId}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Autor: ${widget.notification.authorName}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'CPF: ${widget.notification.authorCpf}',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
              Text(
                'Data: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.notification.data))}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Tipo: ${widget.notification.tipo}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Risco: ${widget.notification.risco}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Endereço: ${widget.notification.loc?.endereco ?? 'Endereço não disponível'}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Descrição: ${widget.notification.descricao ?? 'Descricao não disponível'}',
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Localização:",
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  border: Border.all(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                ),
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(location?.latitude ?? 0.0,
                          location?.longitude ?? 0.0),
                      zoom: 18,
                    ),
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
              const SizedBox(height: 24),
              if (widget.notification.status != 'Ocorrência Concluída')
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed:
                          widget.notification.status == 'Em Processamento'
                              ? _confirmCompleteOccurrence
                              : _confirmStartOccurrence,
                      child: Text(
                        widget.notification.status == 'Em Processamento'
                            ? 'Concluir Ocorrência'
                            : 'Iniciar Ocorrência',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            widget.notification.status == 'Em Processamento'
                                ? Colors.blue
                                : Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _editNotification,
                          child: Text(
                            'Editar',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _confirmDelete,
                          child: Text(
                            'Excluir',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

// ####### FUNÇÕES #######

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Você realmente deseja excluir esta notificação?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await NotificationService()
                  .removeNotification(notificationId: widget.notification.id);
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Voltar para a página anterior
            },
            child: Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _editNotification() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Status'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              //_saveNotification();
              Navigator.of(context).pop();
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }

  void _confirmStartOccurrence() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Iniciar Ocorrência'),
        content: Text(
          'Ao confirmar, o status da ocorrência será alterado para "Em Processamento", você deseja continuar?',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              _startOccurrence();
              Navigator.of(context).pop();
            },
            child: Text('Iniciar', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  void _confirmCompleteOccurrence() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Concluir Ocorrência'),
        content: Text(
          'Ao confirmar, o status da ocorrência será alterado para "Ocorrência Concluída", você deseja continuar?',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar', style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () {
              _completeOccurrence();
              Navigator.of(context).pop();
            },
            child: Text('Concluir', style: TextStyle(color: Colors.green)),
          ),
        ],
      ),
    );
  }

  void _startOccurrence() async {
    // Atualiza o status da notificação
    UserNotification updatedNotification = widget.notification;
    updatedNotification.status = 'Em Processamento';

    try {
      await NotificationService().updateAllNotification(
        updatedNotification.authorId!,
        updatedNotification,
      );

      // Atualiza o estado para refletir a mudança no status
      setState(() {
        widget.notification.status = 'Em Processamento';
      });

      // Mostra uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocorrência iniciada com sucesso!')),
      );
    } catch (e) {
      // Mostra uma mensagem de erro em caso de falha
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao iniciar a ocorrência.')),
      );
    }
  }

  void _completeOccurrence() async {
    // Atualiza o status da notificação
    UserNotification updatedNotification = widget.notification;
    updatedNotification.status = 'Ocorrência Concluída';

    try {
      await NotificationService().updateAllNotification(
        updatedNotification.authorId!,
        updatedNotification,
      );

      // Atualiza o estado para refletir a mudança no status
      setState(() {
        widget.notification.status = 'Ocorrência Concluída';
      });

      // Mostra uma mensagem de sucesso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ocorrência concluída com sucesso!')),
      );
    } catch (e) {
      // Mostra uma mensagem de erro em caso de falha
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Falha ao concluir a ocorrência.')),
      );
    }
  }
}
