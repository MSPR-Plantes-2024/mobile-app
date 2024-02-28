import 'package:flutter/material.dart';

import '../main.dart';
import '../models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.sender == MyApp.currentUser;
    return Container(
      decoration: BoxDecoration(
        color: isMe ? Colors.green[300] : Colors.grey[300],
        borderRadius: isMe
            ? const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
                bottomLeft: Radius.circular(12))
            : const BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
            bottomRight: Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 16,
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 4,
        horizontal: 8,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!isMe)
                Text(
                  '${message.sender.firstName} ${message.sender.lastName}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              else
                const Text(
                  "Vous",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Text(
                message.date.toIso8601String(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Text(
            message.content,
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
