
import 'package:campus_mart/features/bottomNavBar/orders/repository/order_repo.dart';
import 'package:campus_mart/models/order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ordersProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final repo = ref.watch(orderProvider);
  final userId = repo.firebaseAuth.currentUser?.uid;
  
  if (userId == null) {
    return Stream.value([]);
  }

  return repo.fetchUserOrders(userId);
});

final orderActionsProvider = Provider.autoDispose((ref) {
  return OrderActions(ref);
});

class OrderActions {
  final Ref _ref;
  OrderActions(this._ref);
  
  Future<void> createOrder(Order order) async {
    await _ref.read(orderProvider).createOrder(order);
  }
}

