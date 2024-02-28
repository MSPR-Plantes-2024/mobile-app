import 'package:flutter/material.dart';
import 'package:mobile_app_arosaje/widgets/message_bubble.dart';

import '../../models/message.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [];

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final User reciever = arguments['reciever'];
    if (arguments['messages'] != null) {
      messages = arguments['messages'];
    } else {
      ApiService.getMessageByUser(reciever).then((value) {
        if (value != null) {
          messages = value;
        }
      });
    }
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return MessageBubble(
          message: messages[index]
        );
      },
    );
  }
}
