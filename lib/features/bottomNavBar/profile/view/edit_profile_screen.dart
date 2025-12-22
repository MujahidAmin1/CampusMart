import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:campusmart/core/img_picker.dart';
import 'package:campusmart/features/bottomNavBar/profile/controller/profie_contr.dart';
import 'package:campusmart/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final User user;
  const EditProfileScreen({super.key, required this.user});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _usernameController;
  File? _pickedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final file = await pickImage();
    if (file != null) {
      setState(() {
        _pickedImage = file;
      });
    }
  }

  Future<void> _updateProfile() async {
    if (_usernameController.text.trim().isEmpty) {
      Flushbar(
        message: 'Username cannot be empty',
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ).show(context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(profileControllerProvider.notifier).updateProfile(
            username: _usernameController.text.trim(),
            imageFile: _pickedImage,
          );
          
      // Refresh the user provider
      ref.invalidate(userByIdProvider(widget.user.id));

      if (mounted) {
        Flushbar(
          title: 'Success',
          message: 'Profile updated successfully',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ).show(context);
        
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        Flushbar(
          title: 'Error',
          message: 'Failed to update profile: $e',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ).show(context);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Color(0xff3A2770),
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Color(0xff3A2770)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(height: 20),
                // Profile Image Picker
                Center(
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: Color(0xff8E6CEF), width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage: _pickedImage != null
                              ? FileImage(_pickedImage!)
                              : ((widget.user.profilePic ?? '').isNotEmpty
                                      ? NetworkImage(widget.user.profilePic!)
                                      : null) as ImageProvider?,
                          child: (_pickedImage == null && (widget.user.profilePic ?? '').isEmpty)
                              ? Text(
                                  widget.user.username.isNotEmpty
                                      ? widget.user.username[0].toUpperCase()
                                      : '?',
                                  style: TextStyle(
                                    fontSize: 40,
                                    color: Color(0xff8E6CEF),
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : null,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Color(0xff8E6CEF),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              Iconsax.camera,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                
                // Username Field
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff8E6CEF).withOpacity(0.08),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Username",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff3A2770),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _usernameController,
                        style: TextStyle(
                           fontSize: 16,
                           color: Color(0xff3A2770),
                           fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter your username",
                          prefixIcon: Icon(Iconsax.user, color: Color(0xff8E6CEF)),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Color(0xff8E6CEF), width: 1.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 40),
                
                // Update Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff8E6CEF),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Save Changes",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(color: Color(0xff8E6CEF)),
                      SizedBox(height: 16),
                      Text(
                        "Updating profile...",
                         style: TextStyle(
                          color: Color(0xff3A2770),
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}