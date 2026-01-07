import 'package:campusmart/core/providers.dart';
import 'package:campusmart/features/bottomNavBar/notification/repository/notification_repo.dart';
import 'package:campusmart/models/app_notification.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the current user's notifications stream
final notificationsProvider = StreamProvider<List<AppNotification>>((ref) {
  final userId = ref.watch(firebaseAuthProvider).currentUser?.uid;
  if (userId == null) {
    return Stream.value([]);
  }
  return ref.watch(notificationRepositoryProvider).getNotifications(userId);
});

/// Provider for unread notification count
final unreadNotificationCountProvider = StreamProvider<int>((ref) {
  final userId = ref.watch(firebaseAuthProvider).currentUser?.uid;
  if (userId == null) {
    return Stream.value(0);
  }
  return ref.watch(notificationRepositoryProvider).getUnreadCount(userId);
});

/// Controller for notification actions
class NotificationController extends StateNotifier<AsyncValue<void>> {
  final NotificationRepository _repository;
  final String? _userId;

  NotificationController({
    required NotificationRepository repository,
    required String? userId,
  })  : _repository = repository,
        _userId = userId,
        super(const AsyncValue.data(null));

  Future<void> markAsRead(String notificationId) async {
    if (_userId == null) return;
    
    state = const AsyncValue.loading();
    try {
      await _repository.markAsRead(_userId, notificationId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markAllAsRead() async {
    if (_userId == null) return;
    
    state = const AsyncValue.loading();
    try {
      await _repository.markAllAsRead(_userId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteNotification(String notificationId) async {
    if (_userId == null) return;
    
    state = const AsyncValue.loading();
    try {
      await _repository.deleteNotification(_userId, notificationId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, AsyncValue<void>>((ref) {
  final userId = ref.watch(firebaseAuthProvider).currentUser?.uid;
  return NotificationController(
    repository: ref.watch(notificationRepositoryProvider),
    userId: userId,
  );
});
