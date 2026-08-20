import 'package:flutter/material.dart';

void main() {
  runApp(const TimeVisionApp());
}

class TimeVisionApp extends StatelessWidget {
  const TimeVisionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Time Vision',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Vision'),
      ),
      body: const Center(
        child: Text(
          'Welcome to Time Vision',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
