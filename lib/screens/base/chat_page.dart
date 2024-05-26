import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_app_arosaje/widgets/message_bubble.dart';

import '../../models/message.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';

class ChatPage extends StatefulWidget {
  final Map<String, dynamic> map;
  const ChatPage({super.key, required this.map});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [];

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final User reciever = arguments['reciever'];

    return FutureBuilder<List<Message>>(
      future: ApiService.getMessageByUser(reciever),
      builder: (BuildContext context, AsyncSnapshot<List<Message>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return MessageBubble(message: messages[index]);
            },
          );
        }
      },
    );
  }
}
