import 'package:flutter/material.dart';
import 'package:mobile_app_arosaje/main.dart';
import 'package:mobile_app_arosaje/services/api_message_service.dart';
import 'package:mobile_app_arosaje/widgets/message_bubble.dart';

import '../../models/message.dart';
import '../../models/user.dart';

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
    TextEditingController newMessageController = TextEditingController();

    final User contact = widget.map['contact'];
    if (widget.map['messages'] != null) {
      messages = widget.map['messages'];
    }

    return Column(
      children: [
        Flexible(
          fit: FlexFit.loose,
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return MessageBubble(message: messages[index]);
            },
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            border: BorderDirectional(
              top: BorderSide(color: Colors.black, width: 1),
            ),
          ),
          margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
          child: TextFormField(
            controller: newMessageController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Veuillez entrer un message';
              }
              return null;
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 10.0),
              suffix: IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    await ApiMessageService.create(Message(
                        text: newMessageController.text,
                        date: DateTime.now(),
                        sender: MyApp.currentUser!,
                        receiver: contact));
                    messages.add((Message(
                        text: newMessageController.text,
                        date: DateTime.now(),
                        sender: MyApp.currentUser!,
                        receiver: contact)));
                    newMessageController.clear();
                    setState(() {});
                  }),
              hintText: 'Nouveau message...',
            ),
          ),
        ),
      ],
    );
  }
}
