import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          '오늘의 웹툰',
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'Nanum Gothic',
            fontWeight: FontWeight.w800,
          ),
        ),
        foregroundColor: Colors.green,
        elevation: 0,
      ),
    );
  }
}
