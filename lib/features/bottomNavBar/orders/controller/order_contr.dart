
import 'package:campus_mart/features/bottomNavBar/orders/repository/order_repo.dart';
import 'package:campus_mart/models/order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ordersProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final repo = ref.watch(orderProvider);
  final userId = repo.firebaseAuth.currentUser?.uid;
  
  if (userId == null) {
    return Stream.value([]); // Return empty stream for logged-out users
  }
  
  return repo.firebaseFirestore
      .collection('orders')
      .where('buyerId', isEqualTo: userId)
      .orderBy('createdAt', descending: true) 
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Order.fromMap(doc.data()))
          .toList());
});

// Order actions provider for mutations

final orderActionsProvider = Provider((ref) => OrderActions(ref));

class OrderActions {
  final Ref _ref;
  OrderActions(this._ref);
  
  Future<void> createOrder(Order order) async {
    await _ref.read(orderProvider).createOrder(order);
    _ref.invalidate(ordersProvider); // Refresh list
  }
}

