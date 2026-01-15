
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

final sellerOrdersProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final repo = ref.watch(orderProvider);
  final userId = repo.firebaseAuth.currentUser?.uid;
  
  if (userId == null) {
    return Stream.value([]);
  }

  return repo.fetchSellerOrders(userId);
});

final allOrdersProvider = Provider.autoDispose<List<Order>>((ref) {
  final buyerOrders = ref.watch(ordersProvider).value ?? [];
  final sellerOrders = ref.watch(sellerOrdersProvider).value ?? [];
  
  final allOrders = [...buyerOrders, ...sellerOrders];
  // Remove duplicates if any
  final uniqueOrders = {for (var o in allOrders) o.orderId: o}.values.toList();
  
  // Sort by date descending
  uniqueOrders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
  
  return uniqueOrders;
});

final orderByIdProvider = StreamProvider.autoDispose.family<Order?, String>((ref, orderId) {
  final repo = ref.watch(orderProvider);
  final userId = repo.firebaseAuth.currentUser?.uid;
  
  if (userId == null) {
    return Stream.value(null);
  }
  
  return repo.fetchOrderById(orderId, userId);
});
