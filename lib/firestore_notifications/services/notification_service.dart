import 'package:aurb/firestore_notifications/models/notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  String user_id = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> addNotification({required UserNotification notification}) async {
    return firestore
        .collection('users')
        .doc(user_id)
        .collection('notifications')
        .doc(notification.id)
        .set(notification.toMap());
  }

  Future<List<UserNotification>> readNotifications() async {
    List<UserNotification> temp = [];

    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('users')
        .doc(user_id)
        .collection('notifications')
        .get();

    for (var doc in snapshot.docs) {
      temp.add(UserNotification.fromMap(doc.data()));
    }

    return temp;
  }

  Future<void> removeNotification({required String notificationId}) async {
    return firestore
        .collection('users')
        .doc(user_id)
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }
}
