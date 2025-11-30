
import 'package:campusmart/features/bottomNavBar/orders/repository/order_repo.dart';
import 'package:campusmart/models/order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ordersProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final repo = ref.watch(orderProvider);
  final userId = repo.firebaseAuth.currentUser?.uid;
  
  if (userId == null) {
    return Stream.value([]);
  }

  return repo.fetchUserOrders(userId);
});

final orderByIdProvider = StreamProvider.autoDispose.family<Order?, String>((ref, orderId) {
  final repo = ref.watch(orderProvider);
  return repo.fetchOrderById(orderId);
});

class OrderController extends StateNotifier<AsyncValue<List<Order>>> {
  final OrderRepository orderRepo;
  final Ref ref;
  OrderController(this.ref, {required this.orderRepo})
      : super(AsyncValue.loading()) {
    fetchUserOrders();
  }

  Stream<List<Order>> fetchUserOrders(){
    final userId = orderRepo.firebaseAuth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }
    return orderRepo.fetchUserOrders(userId);
  }

  
  Future<void> createOrder(Order order) async {
    try {
      await orderRepo.createOrder(order);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}