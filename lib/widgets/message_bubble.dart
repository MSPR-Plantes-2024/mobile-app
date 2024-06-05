import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bool isMe = message.sender.id == MyApp.currentUser!.id;
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
      margin:  EdgeInsets.only(
        left: isMe ? 50 : 6,
        right: isMe ? 6 : 80,
        top: 8,
        bottom: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                DateFormat('dd/MM/yyyy HH:mm').format(message.date),
                style: TextStyle(
                  fontSize: 12,
                  color: isMe ? Colors.white : Colors.grey,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              message.text,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
