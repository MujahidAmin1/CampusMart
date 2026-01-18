import 'package:campusmart/core/utils/ktextstyle.dart';
import 'package:campusmart/core/utils/price_format.dart';
import 'package:campusmart/features/payment/payment_service.dart';
import 'package:campusmart/models/product.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  final Product product;
  final String userEmail;
  final Function(PaymentResult) onPaymentComplete;

  const PaymentConfirmationScreen({
    super.key,
    required this.product,
    required this.userEmail,
    required this.onPaymentComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: Color(0xff3A2770)),
        ),
        title: Text(
          'Confirm Payment',
          style: kTextStyle(
            size: 18,
            isBold: true,
            color: Color(0xff3A2770),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Important Notice Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xff3A2770).withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color(0xff3A2770).withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xff8E6CEF).withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Iconsax.security_safe,
                      color: Color(0xff8E6CEF),
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Secure Payment Notice',
                          style: kTextStyle(
                            size: 15,
                            isBold: true,
                            color: Color(0xff3A2770),
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'The payment account is under the control of the school. Admin has no direct access to funds. Your payment is securely handled.',
                          style: kTextStyle(
                            size: 13,
                            color: Color(0xff3A2770).withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 24),

            // Order Summary
            Text(
              'Order Summary',
              style: kTextStyle(
                size: 18,
                isBold: true,
                color: Color(0xff3A2770),
              ),
            ),

            SizedBox(height: 16),

            // Product Details Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.imageUrls.first,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: kTextStyle(
                            size: 16,
                            isBold: true,
                            color: Color(0xff3A2770),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xff8E6CEF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            product.category,
                            style: kTextStyle(
                              size: 11,
                              color: Color(0xff8E6CEF),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Price Breakdown
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xffEFC66C).withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Color(0xffEFC66C).withOpacity(0.5),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Product Price',
                        style: kTextStyle(
                          size: 14,
                          color: Color(0xff3A2770).withOpacity(0.7),
                        ),
                      ),
                      Text(
                        formatNairaPrice(product.price),
                        style: kTextStyle(
                          size: 14,
                          color: Color(0xff3A2770),
                        ),
                      ),
                    ],
                  ),
                  Divider(height: 24, color: Color(0xffEFC66C).withOpacity(0.5)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: kTextStyle(
                          size: 16,
                          isBold: true,
                          color: Color(0xff3A2770),
                        ),
                      ),
                      Text(
                        formatNairaPrice(product.price),
                        style: kTextStyle(
                          size: 20,
                          isBold: true,
                          color: Color(0xff3A2770),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Proceed to Payment Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final paymentService = PaymentServices();
                  final result = await paymentService.makePayment(
                    context: context,
                    email: userEmail,
                    amount: product.price,
                  );

                  // Pop the confirmation screen
                  if (context.mounted) {
                    Navigator.pop(context);
                  }

                  // Callback with the result
                  onPaymentComplete(result);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff8E6CEF),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  shadowColor: Color(0xff8E6CEF).withOpacity(0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.card,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Proceed to Payment',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff3A2770).withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
