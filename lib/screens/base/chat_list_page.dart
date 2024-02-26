import 'package:flutter/material.dart';
import 'package:mobile_app_arosaje/models/message.dart';

import '../../services/api_service.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late Future<List<Message>?> messageFuture;

  @override
  void initState() {
    super.initState();
    messageFuture = ApiService.getMessages();
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(itemBuilder: (context, index) {
      return ListTile(
        title: const Text("Chat"),
        subtitle: const Text("Dernier message"),
        leading: const Icon(Icons.chat_bubble_outline),
        onTap: () {
          Navigator.pushNamed(context, '/chat');
        },
      );
    });
  }
}
