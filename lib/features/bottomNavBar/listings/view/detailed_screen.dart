import 'package:campusmart/core/providers.dart';
import 'package:campusmart/core/utils/extensions.dart';
import 'package:campusmart/core/utils/ktextstyle.dart';
import 'package:campusmart/core/utils/price_format.dart';
import 'package:campusmart/features/bottomNavBar/listings/controller/listing_contr.dart';
import 'package:campusmart/features/bottomNavBar/listings/view/owner_profile_lists.dart';
import 'package:campusmart/features/bottomNavBar/listings/view/successpage.dart';
import 'package:campusmart/features/bottomNavBar/notification/repository/notification_repo.dart';
import 'package:campusmart/features/bottomNavBar/orders/repository/order_repo.dart';
import 'package:campusmart/models/app_notification.dart';
import 'package:campusmart/features/payment/payment_service.dart';
import 'package:campusmart/features/payment/payment_confirmation_screen.dart';
import 'package:campusmart/models/order.dart';
import 'package:campusmart/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:uuid/uuid.dart';

class ProductDetailedScreen extends ConsumerStatefulWidget {
  final bool looped;
  final Product product;
  const ProductDetailedScreen(
      {super.key, required this.product, required this.looped});

  @override
  ConsumerState<ProductDetailedScreen> createState() =>
      _ProductDetailedScreenState();
}

class _ProductDetailedScreenState extends ConsumerState<ProductDetailedScreen> {
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authuser = ref.read(firebaseAuthProvider).currentUser;
    final productOwner =
        ref.watch(productOwnerProvider(widget.product.ownerId));

    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Stack(
                  children: [
                    widget.product.imageUrls.length <= 1
                        ? Hero(
                            tag:
                                'product-image-${widget.product.imageUrls.first}',
                            child: Image.network(
                              widget.product.imageUrls.first,
                              width: double.infinity,
                              height: height * 0.45,
                              fit: BoxFit.cover,
                            ),
                          )
                        : SizedBox(
                            height: height * 0.45,
                            child: Stack(
                              children: [
                                CarouselView(
                                  scrollDirection: Axis.horizontal,
                                  itemExtent: MediaQuery.of(context).size.width,
                                  onTap: (index) {
                                    setState(() {
                                      _currentImageIndex = index;
                                    });
                                  },
                                  children: widget.product.imageUrls
                                      .map(
                                        (img) => Image.network(
                                          img,
                                          width: double.infinity,
                                          height: height * 0.45,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                      .toList(),
                                ),
                                // Image Indicator
                                Positioned(
                                  bottom: 16,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.6),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '${_currentImageIndex + 1}/${widget.product.imageUrls.length}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),

                // Content Section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        // Category Badge
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Color(0xff8E6CEF).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Color(0xff8E6CEF).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            "${widget.product.category[0].toUpperCase()}${widget.product.category.substring(1)}",
                            style: kTextStyle(
                              size: 12,
                              isBold: true,
                              color: Color(0xff8E6CEF),
                            ),
                          ),
                        ),

                        // Title
                        Text(
                          widget.product.title,
                          style: kTextStyle(
                            size: 26,
                            isBold: true,
                            color: Color(0xff3A2770),
                          ),
                        ),

                        // Price Card
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xffEFC66C),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xffEFC66C),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Price',
                                    style: kTextStyle(
                                      size: 12,
                                      color: Color(0xff3A2770).withOpacity(0.6),
                                    ),
                                  ),
                                  Text(
                                    formatNairaPrice(widget.product.price),
                                    style: kTextStyle(
                                      isBold: true,
                                      size: 24,
                                      color: Color(0xff3A2770),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Seller/Owner
                        if (productOwner.hasValue && productOwner.value != null)
                          GestureDetector(
                            onTap: () {
                              context.push(
                                OwnerProfileListsScreen(
                                    ownerId: widget.product.ownerId),
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Iconsax.user,
                                  size: 16,
                                  color: Color(0xff8E6CEF),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Owner: ',
                                  style: kTextStyle(
                                    size: 14,
                                    color: Color(0xff3A2770).withOpacity(0.6),
                                  ),
                                ),
                                Text(
                                  productOwner.value!.username,
                                  style: kTextStyle(
                                    size: 17,
                                    color: Color(0xff8E6CEF),
                                    isBold: true,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Description Section
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            Text(
                              'Description',
                              style: kTextStyle(
                                size: 16,
                                isBold: true,
                                color: Color(0xff3A2770),
                              ),
                            ),
                            Text(
                              widget.product.description,
                              style: kTextStyle(
                                size: 21,
                                color: Color(0xff3A2770).withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),

                        widget.looped ? SizedBox() : SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_new, size: 20),
                color: Color(0xff3A2770),
              ),
            ),
          ),

          // Order Button (Fixed at bottom)
          if (!widget.looped)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: authuser?.uid == widget.product.ownerId
                    // User owns this product - show message instead of button
                    ? Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Iconsax.info_circle,
                              color: Colors.grey.shade600,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "You own this product",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    // User doesn't own this product - show order button
                    : Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xff8E6CEF),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff8E6CEF).withOpacity(0.3),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                        final user =
                            ref.read(firebaseAuthProvider).currentUser!;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => PaymentConfirmationScreen(
                              product: widget.product,
                              userEmail: user.email!,
                              onPaymentComplete: (paymentResult) async {
                                if (paymentResult.status != PaymentStatus.success) {
                                  return;
                                }

                                final order = Order(
                                  orderId: const Uuid().v4(),
                                  productId: widget.product.productId,
                                  buyerId: user.uid,
                                  sellerId: widget.product.ownerId,
                                  amount: widget.product.price,
                                  paymentId: paymentResult.reference!,
                                  status: OrderStatus.paid,
                                  orderDate: DateTime.now(),
                                  deliveryAddress: "deliveryAddress",
                                  isShippingConfirmed: false,
                                  hasCollectedItem: false,
                                  recievedAt: null,
                                );
                                await ref.read(orderProvider).createOrder(order);
                                
                                // Send notification to the seller that buyer has paid
                                await ref.read(notificationRepositoryProvider).createNotification(
                                  userId: widget.product.ownerId,
                                  title: 'New Order Received!',
                                  body: 'Someone has paid for "${widget.product.title}". Please take item to the pickup station.',
                                  type: NotificationType.orderPaid,
                                  relatedId: order.orderId,
                                );
                                
                                if (context.mounted) {
                                  context.pushReplacement(Successpage(product: widget.product, order: order));
                                }
                              },
                            ),
                          ),
                        );
                      },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.shopping_cart,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Place an Order",
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
              ),
            ),
        ],
      ),
    );
  }
}
