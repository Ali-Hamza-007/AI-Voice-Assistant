import 'package:flutter/material.dart';
import 'package:voice_assistant_app/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true).copyWith(
        primaryColor: Color(0xFF201C46),
        appBarTheme: AppBarTheme(backgroundColor: Color(0xFF201C46)),
      ),
      title: 'Voice Assistant',
      home: HomePage(),
    );
  }
}
