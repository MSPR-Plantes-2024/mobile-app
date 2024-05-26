import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_arosaje/main.dart';
import 'package:mobile_app_arosaje/models/message.dart';

import '../../services/api_service.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late List<Message> messagesToSort;

  Future<List<List<Message>>> prepareMessages() async {
    List<List<Message>> messages = [];
    messagesToSort = await ApiService.getMessageByUser(MyApp.currentUser!);
    if (messagesToSort.isNotEmpty) {
      var messagesToSortCopy = List<Message>.from(messagesToSort);
      for (Message message in messagesToSortCopy) {
        if (message.sender.id == MyApp.currentUser!.id) {
          messages.add([message]);
          messagesToSort.remove(message);
        }
      }
      for (Message message in messagesToSort) {
        List<List<Message>> messagesCopy = List<List<Message>>.from(messages);
        for (List<Message> messageList in messagesCopy) {
          if (messageList.first.receiver.id == message.sender.id) {
            messageList.add(message);
            break;
          }
          messages.add([message]);
        }
      }
      for (List<Message> message in messages) {
        message.sort((a, b) => a.date.compareTo(b.date));
      }
      messages.sort((a, b) => a.last.date.compareTo(b.last.date));
      return messages;
    }
    ;
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<Message>>>(
      future: prepareMessages(),
      builder:
          (BuildContext context, AsyncSnapshot<List<List<Message>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<List<Message>> messages = snapshot.data!;
          return messages.isEmpty
              ? const Center(
                  child: Text('Aucun message pour le moment.'),
                )
              : ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          '${messages[index].first.sender.firstName} ${messages[index].first.sender.lastName}'),
                      subtitle: Text('${messages[index].last.sender.id == MyApp.currentUser!.id ? 'Vous' : messages[index].last.sender.firstName} : ${messages[index].last.text}'),
                      onTap: () {
                        context.go('/chat', extra: {
                          'reciever': messages[index].first.sender.id ==
                                  MyApp.currentUser!.id
                              ? messages[index].first.receiver
                              : messages[index].first.sender,
                          'messages': messages[index],
                        });
                      },
                    );
                  });
        }
      },
    );
  }
}
