import 'package:campusmart/core/utils/ktextstyle.dart';
import 'package:flutter/material.dart';

Widget buildMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color? iconColor,
    Color? textColor,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Color(0xff8E6CEF)),
      title: Text(
        title,
        style: kTextStyle(
          size: 16,
          color: textColor ?? Color(0xff3A2770),
          isBold: false,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
        color: Color(0xff3A2770).withOpacity(0.3),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }