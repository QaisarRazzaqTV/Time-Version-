import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, String>> _messages = [];

  bool _loading = false;

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();

    if (message.isEmpty || _loading) return;

    setState(() {
      _messages.add({
        'role': 'user',
        'message': message,
      });
      _loading = true;
    });

    _messageController.clear();

    try {
      final response = await http.post(
        Uri.parse('https://time-vision.fastapicloud.dev/chat'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        String answer;

        if (data is Map && data['reply'] != null) {
  answer = data['reply'].toString();
} else {
  answer = response.body;
}

        setState(() {
          _messages.add({
            'role': 'ai',
            'message': answer,
          });
        });
      } else {
        setState(() {
          _messages.add({
            'role': 'ai',
            'message':
                'Server error: ${response.statusCode}\n${response.body}',
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({
          'role': 'ai',
          'message': 'Connection error: $e',
        });
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Vision AI'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          size: 70,
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Ask Time Vision AI',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Ask me anything about your past or future.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final item = _messages[index];
                      final isUser = item['role'] == 'user';

                      return Align(
                        alignment: isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          constraints: const BoxConstraints(
                            maxWidth: 320,
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: isUser
                                ? Theme.of(context)
                                    .colorScheme
                                    .primaryContainer
                                : Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                          ),
                          child: Text(
                            item['message'] ?? '',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
                    },
                  ),
          ),

          if (_loading)
            const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text('Time Vision AI is thinking...'),
            ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Write your question...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _loading ? null : _sendMessage,
                    icon: const Icon(Icons.send),
                    iconSize: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
