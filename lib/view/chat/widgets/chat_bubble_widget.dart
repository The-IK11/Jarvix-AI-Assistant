import 'package:flutter/material.dart';
import 'package:jarvis_ai/data/models/chat_bubble_model.dart';

class ChatBubble extends StatelessWidget {
  final ChatBubbleModel message;

  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: message.isUser 
              ? const Color(0xFF5B4CFF) // Purple for user messages
              : const Color(0xFF2C2C2C), // Dark gray for AI messages
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: message.isUser 
                ? const Radius.circular(16) 
                : const Radius.circular(4),
            bottomRight: message.isUser 
                ? const Radius.circular(4) 
                : const Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!message.isUser) ...[
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF5B4CFF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.smart_toy,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                message.message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
            if (message.isUser) ...[
              const SizedBox(width: 8),
              const CircleAvatar(
                radius: 10,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.person,
                  color: Color(0xFF5B4CFF),
                  size: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
