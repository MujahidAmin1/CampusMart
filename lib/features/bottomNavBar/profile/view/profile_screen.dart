import 'package:campusmart/core/providers.dart';
import 'package:campusmart/core/utils/extensions.dart';
import 'package:campusmart/features/auth/controller/auth_controller.dart';
import 'package:campusmart/features/bottomNavBar/profile/controller/profie_contr.dart';
import 'package:campusmart/features/bottomNavBar/profile/view/edit_profile_screen.dart';
import 'package:campusmart/features/bottomNavBar/profile/view/myListings.dart';
import 'package:campusmart/features/bottomNavBar/profile/widget/customW.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.read(firebaseAuthProvider).currentUser;
    final userstate = ref.watch(userByIdProvider(currentUser!.uid));
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Color(0xff3A2770),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: userstate.when(
        data: (user) {
          // Show loading state if user document doesn't exist yet
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Color(0xff8E6CEF),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Setting up your profile...',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff3A2770).withOpacity(0.7),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile Header Card
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Color(0xff8E6CEF),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff8E6CEF).withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: (user.profilePic ?? '').isNotEmpty 
                            ? NetworkImage(user.profilePic!) 
                            : null,
                        child: (user.profilePic ?? '').isEmpty
                            ? Text(
                                user.username[0].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff8E6CEF),
                                ),
                              )
                            : null,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      user.username,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user.regNo,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24),
              
              // Account Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff3A2770),
                        ),
                      ),
                    ),
                    buildMenuItem(
                      context,
                      Icons.edit_outlined,
                      'Edit Profile',
                      () {
                        context.push(EditProfileScreen(user: user));
                      },
                    ),
                    Divider(height: 1, indent: 60, endIndent: 16),
                    buildMenuItem(
                      context,
                      Icons.shopping_bag_outlined,
                      'My Listings',
                      () {
                          context.push(MyListedItemsScreen());
                      },
                    ),
                  
                  ],
                ),
              ),
              
              SizedBox(height: 16),
              
              // Settings Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff3A2770),
                        ),
                      ),
                    ),
                    Divider(height: 1, indent: 60, endIndent: 16),
                    buildMenuItem(
                      context,
                      Icons.privacy_tip_outlined,
                      'Privacy',
                      () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Privacy Policy'),
                            content: SingleChildScrollView(
                              child: Text(
                                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                                'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                                'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris '
                                'nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in '
                                'reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla '
                                'pariatur. Excepteur sint occaecat cupidatat non proident, sunt in '
                                'culpa qui officia deserunt mollit anim id est laborum.\n\n'
                                'Curabitur pretium tincidunt lacus. Nulla gravida orci a odio. '
                                'Nullam varius, turpis et commodo pharetra, est eros bibendum elit, '
                                'nec luctus magna felis sollicitudin mauris. Integer in mauris eu '
                                'nibh euismod gravida. Duis ac tellus et risus vulputate vehicula.',
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Divider(height: 1, indent: 60, endIndent: 16),
                    buildMenuItem(
                      context,
                      Icons.help_outline,
                      'Help & Support',
                      () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Help & Support'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Need help or have questions?',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'Contact us at:',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                SelectableText(
                                  'mujahidamin2005@gmail.com',
                                  style: TextStyle(
                                    color: Color(0xff8E6CEF),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Close'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Divider(height: 1, indent: 60, endIndent: 16),
                    buildMenuItem(
                      context,
                      Icons.location_on_outlined,
                      'Pickup Station',
                      () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Color(0xff8E6CEF),
                                ),
                                SizedBox(width: 8),
                                Text('Pickup Station'),
                              ],
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Collect your orders from:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 12),
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Color(0xff8E6CEF).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'Campus pickup shop, opposite tomato sellers, Coke Village, BUK new site',
                                    style: TextStyle(
                                      color: Color(0xff3A2770),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Close'),
                              ),
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=11.971707927064859,8.42293212054006');
                                  try {
                                    await launchUrl(url, mode: LaunchMode.externalApplication);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Could not open maps')),
                                    );
                                  }
                                },
                                icon: Icon(Icons.map, size: 18),
                                label: Text('Open in Maps'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xff8E6CEF),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 16),
              
              // Logout Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: buildMenuItem(
                  context,
                  Icons.logout,
                  'Logout',
                  () {
                    // Show logout confirmation
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Logout'),
                        content: Text('Are you sure you want to logout?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(authControllerProvider.notifier).signout();
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Logout',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  iconColor: Colors.red,
                  textColor: Colors.red,
                ),
              ),
              
              SizedBox(height: 24),
              
              // App Version
              Center(
                child: Text(
                  'CampusMart v1.0.0',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xff3A2770).withOpacity(0.5),
                  ),
                ),
              ),
              
              SizedBox(height: 16),
            ],
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red.shade400,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Oops! Something went wrong',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff3A2770),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  Text(
                    'We couldn\'t load your profile. Please check your connection and try again.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xff3A2770).withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.invalidate(userByIdProvider);
                    },
                    icon: Icon(Icons.refresh),
                    label: Text('Try Again'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff8E6CEF),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Color(0xff8E6CEF),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  'Loading your profile...',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff3A2770).withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}