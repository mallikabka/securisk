import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGaurd extends StatefulWidget {
   AuthGaurd({super.key});

  Future<bool> authenticateUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('email');
    if (username != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  State<AuthGaurd> createState() => _AuthGaurdState();
}

class _AuthGaurdState extends State<AuthGaurd> {
  @override
  Widget build(BuildContext context) {
    return  Placeholder();
  }
}
