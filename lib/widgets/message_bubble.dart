import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_arosaje/models/user.dart';

import '../main.dart';
import '../models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: User.isCurrent(message.sender) ? Colors.green[300] : Colors.grey[300],
        borderRadius: User.isCurrent(message.sender)
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
        left: User.isCurrent(message.sender) ? 50 : 6,
        right: User.isCurrent(message.sender) ? 6 : 80,
        top: 8,
        bottom: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!User.isCurrent(message.sender))
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
                  color: User.isCurrent(message.sender) ? Colors.white : Colors.grey,
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
