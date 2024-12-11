import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(
        userName: "Marc Velasquez"
      ),
    )
  );
}