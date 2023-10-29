import 'package:djangoconafrica/components/colors.dart';
import 'package:djangoconafrica/pages/auth_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => AuthPage()),
      );
    });

    return Scaffold(
      backgroundColor: primaryColor,
      body: Center(child: Image.asset("images/django.png")),

      // stack

      // container with djangoCon logo on it
    );
  }
}
