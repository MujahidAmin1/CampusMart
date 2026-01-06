import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';
enum PaymentStatus {
  success,
  cancelled,
  failed,
}

class PaymentResult {
  final PaymentStatus status;
  final String? reference;

  const PaymentResult({
    required this.status,
    this.reference,
  });
}
class PaymentServices {
  Future<PaymentResult> makePayment({
    required BuildContext context,
    required String email,
    required double amount,
  }) {
    final txRef = PayWithPayStack().generateUuidV4();
    final completer = Completer<PaymentResult>();

    PayWithPayStack().now(
      callbackUrl: 'https://your-callback-url.com',
      secretKey: "sk_test_1a6ba59fa15eb7ef440bf61ccea3280522fa7aed",
      context: context,
      customerEmail: email,
      reference: txRef,
      currency: 'NGN',
      amount: amount,
      transactionCompleted: (paymentData) {
        if (!completer.isCompleted) {
          completer.complete(
            PaymentResult(
              status: PaymentStatus.success,
              reference: txRef,
            ),
          );
        }
      },
      transactionNotCompleted: (e) {
        if (!completer.isCompleted) {
          completer.complete(
            const PaymentResult(status: PaymentStatus.cancelled),
          );
        }
      },
    );

    return completer.future;
  }
}
