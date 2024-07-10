import 'package:aurb/firestore_notifications/models/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addNotification({required UserNotification notification}) async {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notification.id)
        .set(notification.toMap());
  }

  Future<List<UserNotification>> readNotifications() async {
    List<UserNotification> temp = [];

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .get();

      for (var doc in snapshot.docs) {
        temp.add(UserNotification.fromMap(doc.data()));
      }
    } catch (e) {
      print('Erro ao carregar notificações: $e');
      rethrow;
    }

    return temp;
  }

  Future<Map<String, String>> getAuthorInfo() async {
    try {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(userId).get();
      String authorName = userDoc['name'];
      String authorCpf = userDoc['cpf'];

      return {'name': authorName, 'cpf': authorCpf};
    } catch (e) {
      print('Erro ao obter informações do autor: $e');
      rethrow;
    }
  }

  Future<void> removeNotification({required String notificationId}) async {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }

  Future<void> updateNotification(UserNotification notification) async {
    return firestore
        .collection('users')
        .doc(userId)
        .collection('notifications')
        .doc(notification.id)
        .update(notification.toMap());
  }

  Future<List<UserNotification>> readAllNotifications() async {
    List<UserNotification> allNotifications = [];

    try {
      // Obtém todos os usuários
      QuerySnapshot<Map<String, dynamic>> userSnapshot =
          await firestore.collection('users').get();

      // Itera sobre cada usuário
      for (var userDoc in userSnapshot.docs) {
        String userId = userDoc.id;

        // Obtém todas as notificações desse usuário
        QuerySnapshot<Map<String, dynamic>> notificationSnapshot =
            await firestore
                .collection('users')
                .doc(userId)
                .collection('notifications')
                .get();

        // Adiciona as notificações à lista de todas as notificações
        for (var notificationDoc in notificationSnapshot.docs) {
          allNotifications
              .add(UserNotification.fromMap(notificationDoc.data()));
        }
      }
    } catch (e) {
      print('Erro ao carregar todas as notificações: $e');
      rethrow;
    }

    return allNotifications;
  }
}
