import 'package:cloud_firestore/cloud_firestore.dart';

enum NotificationType {
  orderNew,
  orderPaid,
  orderShipped,
  orderCollected,
  orderCompleted,
  paymentReleased,
  general,
}

class AppNotification {
  final String id;
  final String title;
  final String body;
  final bool isRead;
  final DateTime createdAt;
  final NotificationType? type;
  final String? relatedId;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.isRead,
    required this.createdAt,
    this.type,
    this.relatedId,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    bool? isRead,
    DateTime? createdAt,
    NotificationType? type,
    String? relatedId,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      relatedId: relatedId ?? this.relatedId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
      'type': type?.name,
      'relatedId': relatedId,
    };
  }

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      isRead: map['isRead'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      type: _parseNotificationType(map['type']),
      relatedId: map['relatedId'],
    );
  }

  static NotificationType? _parseNotificationType(String? typeString) {
    if (typeString == null) return null;
    try {
      return NotificationType.values.firstWhere((e) => e.name == typeString);
    } catch (_) {
      return NotificationType.general;
    }
  }
}
