import 'package:flutter/material.dart';

class MessagingScreen extends StatelessWidget {
  const MessagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(icon: const Icon(Icons.edit_square), onPressed: () {}),
        ],
      ),
      body: const Center(
        child: Text('Chat-style Messaging UI goes here'),
      ),
    );
  }
}
