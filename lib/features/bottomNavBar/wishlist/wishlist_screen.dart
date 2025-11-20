import 'package:campusmart/features/bottomNavBar/wishlist/controller/wishlist_contr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistProvider = ref.watch(wishlistControllerProvider);
   
    return Scaffold(
      appBar: AppBar(
        title: Text("Wish List"),
      ),
      body: wishlistProvider.when(
        data: (items) {
          // ✅ Check if list is empty
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff3A2770),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add items you love to your wishlist',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }
          
          // ✅ Return ListView with the items
          return ListView.builder(
            itemCount: items.length,
            padding: EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(
                    item.productTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xff3A2770),
                    ),
                  ),
                  subtitle: Text(
                    '₦${item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Color(0xff8E6CEF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      ref
                          .read(wishlistControllerProvider.notifier)
                          .removeFromWishList(item);
                    },
                  ),
                ),
              );
            },
          );
        },
        error: (e, st) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 60,
                color: Colors.red.shade300,
              ),
              SizedBox(height: 16),
              Text(
                'Failed to load wishlist',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff3A2770),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Please try again later',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xff8E6CEF), Color(0xff6CEFBD)],
                  ),
                  shape: BoxShape.circle,
                ),
                child: SpinKitSpinningLines(
                  color: Colors.white,
                  size: 40,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Loading products...',
                style: TextStyle(
                  color: Color(0xff3A2770).withOpacity(0.6),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}