import 'package:campusmart/core/providers.dart';
import 'package:campusmart/core/utils/my_colors.dart';
import 'package:campusmart/features/bottomNavBar/profile/controller/profie_contr.dart';
import 'package:campusmart/models/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

/// Screen that displays notifications for items that have been purchased
/// from the current user (where they are the seller).
/// 
/// Fetches and displays all products from orders where:
/// - sellerId = current user's UID
/// - status = 'paid'
class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.read(firebaseAuthProvider).currentUser!.uid;
    final itemsPaidFor = ref.watch(itemsPaidForProvider(currentUserId));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyColors.purpleShade,
        foregroundColor: Colors.white,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: itemsPaidFor.when(
        data: (products) => _buildNotificationsList(context, products),
        error: (error, stack) => _buildErrorState(context, error),
        loading: () => _buildLoadingState(),
      ),
    );
  }

  // ============================================================================
  // Main Content Builders
  // ============================================================================

  /// Builds the main notifications list view
  Widget _buildNotificationsList(BuildContext context, List<Product> products) {
    if (products.isEmpty) {
      return _buildEmptyState();
    }

    return Column(
      children: [
        _buildHeader(products.length),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _buildNotificationCard(context, products[index], index);
            },
          ),
        ),
      ],
    );
  }

  /// Builds the header section with purchase count
  Widget _buildHeader(int count) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MyColors.purpleShade.withOpacity(0.1),
            MyColors.coldGold.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: MyColors.purpleShade,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.shopping_bag_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$count Purchase${count > 1 ? 's' : ''}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyColors.darkBase,
            ),
          ),
          const Spacer(),
          Text(
            'All notifications',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // Notification Card
  // ============================================================================

  /// Builds an individual notification card for a purchased product
  Widget _buildNotificationCard(BuildContext context, Product product, int index) {
    final dateFormatter = DateFormat('MMM dd, yyyy • hh:mm a');
    
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: 300 + (index * 100)),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: MyColors.purpleShade.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              // TODO: Navigate to product details if needed
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProductImage(product),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildProductDetails(product, dateFormatter),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the product image section
  Widget _buildProductImage(Product product) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            MyColors.purpleShade.withOpacity(0.2),
            MyColors.coldGold.withOpacity(0.2),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: product.imageUrls.isNotEmpty
            ? Image.network(
                product.imageUrls.first,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => _buildImagePlaceholder(),
              )
            : _buildImagePlaceholder(),
      ),
    );
  }

  /// Builds the product details section
  Widget _buildProductDetails(Product product, DateFormat dateFormatter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPurchasedBadge(),
        const SizedBox(height: 8),
        Text(
          product.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: MyColors.darkBase,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          product.description,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildPriceTag(product.price),
            const Spacer(),
            _buildTimestamp(product.datePosted, dateFormatter),
          ],
        ),
      ],
    );
  }

  /// Builds the "Purchased" status badge
  Widget _buildPurchasedBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MyColors.coldGold.withOpacity(0.8),
            MyColors.warmGold.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 14,
            color: Colors.white,
          ),
          SizedBox(width: 4),
          Text(
            'Purchased',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the price tag
  Widget _buildPriceTag(double price) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: MyColors.purpleShade.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '₦${price.toStringAsFixed(2)}',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: MyColors.purpleShade,
        ),
      ),
    );
  }

  /// Builds the timestamp display
  Widget _buildTimestamp(DateTime date, DateFormat formatter) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.access_time,
          size: 14,
          color: Colors.grey[400],
        ),
        const SizedBox(width: 4),
        Text(
          formatter.format(date),
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  // ============================================================================
  // State Widgets (Empty, Loading, Error)
  // ============================================================================

  /// Placeholder widget for missing product images
  Widget _buildImagePlaceholder() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            MyColors.purpleShade.withOpacity(0.3),
            MyColors.coldGold.withOpacity(0.3),
          ],
        ),
      ),
      child: const Icon(
        Icons.shopping_bag_outlined,
        color: Colors.white,
        size: 32,
      ),
    );
  }

  /// Builds the empty state when no notifications exist
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  MyColors.purpleShade.withOpacity(0.2),
                  MyColors.coldGold.withOpacity(0.2),
                ],
              ),
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 80,
              color: MyColors.purpleShade.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'No Notifications Yet',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: MyColors.darkBase,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Your purchase notifications will appear here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the loading state
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  MyColors.purpleShade.withOpacity(0.2),
                  MyColors.coldGold.withOpacity(0.2),
                ],
              ),
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(MyColors.purpleShade),
              strokeWidth: 3,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Loading notifications...',
            style: TextStyle(
              fontSize: 16,
              color: MyColors.darkBase,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the error state
  Widget _buildErrorState(BuildContext context, Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.withOpacity(0.1),
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 80,
              color: Colors.red[400],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Oops! Something went wrong',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: MyColors.darkBase,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              // TODO: Implement refresh functionality
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.purpleShade,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}