import 'ai_chat_screen.dart';
ElevatedButton.icon(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AiChatScreen(),
      ),
    );
  },
  icon: const Icon(Icons.auto_awesome),
  label: const Text('AI Assistant'),
),
