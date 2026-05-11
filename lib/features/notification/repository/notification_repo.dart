import 'package:campusmart/core/providers.dart';
import 'package:campusmart/models/app_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(firestore: ref.watch(firestoreProvider));
});

class NotificationRepository {
  final FirebaseFirestore _firestore;

  NotificationRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference<Map<String, dynamic>> _notificationsCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('notifications');
  }

  /// Create a new notification for a user
  Future<void> createNotification({
    required String userId,
    required String title,
    required String body,
    NotificationType? type,
    String? relatedId,
  }) async {
    final notificationId = const Uuid().v4();
    final notification = AppNotification(
      id: notificationId,
      title: title,
      body: body,
      isRead: false,
      createdAt: DateTime.now(),
      type: type,
      relatedId: relatedId,
    );

    await _notificationsCollection(userId).doc(notificationId).set(notification.toMap());
  }

  /// Get stream of all notifications for a user (latest first)
  Stream<List<AppNotification>> getNotifications(String userId) {
    return _notificationsCollection(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AppNotification.fromMap(doc.data()))
            .toList());
  }

  /// Get stream of unread notification count for a user
  Stream<int> getUnreadCount(String userId) {
    return _notificationsCollection(userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// Mark a single notification as read
  Future<void> markAsRead(String userId, String notificationId) async {
    await _notificationsCollection(userId).doc(notificationId).update({
      'isRead': true,
    });
  }

  /// Mark all notifications as read for a user
  Future<void> markAllAsRead(String userId) async {
    final batch = _firestore.batch();
    final unreadDocs = await _notificationsCollection(userId)
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in unreadDocs.docs) {
      batch.update(doc.reference, {'isRead': true});
    }

    await batch.commit();
  }

  /// Delete a notification
  Future<void> deleteNotification(String userId, String notificationId) async {
    await _notificationsCollection(userId).doc(notificationId).delete();
  }
}
