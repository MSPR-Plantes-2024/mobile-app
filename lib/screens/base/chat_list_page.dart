import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_arosaje/main.dart';
import 'package:mobile_app_arosaje/models/message.dart';

import '../../models/user.dart';
import '../../services/api_service.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late Future<List<Message>?> messagesFuture;

  List<List<Message>> messages = [];
  bool noMessages = false;

  Future<bool> checkIfMessagesFutureIsEmpty(
      Future<List<Message>?> messagesFuture) async {
    List<Message>? messages = await messagesFuture;
    return messages == null || messages.isEmpty;
  }

  @override
  void initState() {
    super.initState();
    messagesFuture = ApiService.getMessageByUser(MyApp.currentUser!);
    checkIfMessagesFutureIsEmpty(messagesFuture).then((isEmpty) {
      if (isEmpty) {
        noMessages = true;
      } else {
        List<Message> messagesFromCurrentUser = [];
        List<Message> messagesToCurrentUser = [];
        messagesFuture.then((value) {
          messagesFromCurrentUser = value!
              .where((message) => message.sender == MyApp.currentUser)
              .toList();
          messagesToCurrentUser = value
              .where((message) => message.receiver == MyApp.currentUser)
              .toList();
        });
        Set<User> uniqueReceivers =
            messagesFromCurrentUser.map((e) => e.receiver).toSet();
        Set<User> uniqueSendersWithoutCurrentUser =
            messagesToCurrentUser.map((e) => e.sender).toSet();
        for (var receiver in uniqueReceivers) {
          messages.add(
            messagesFromCurrentUser
                .where((element) => element.receiver == receiver)
                .toList(),
          );
        }
        for (var sender in uniqueSendersWithoutCurrentUser) {
          messages.add(
            messagesToCurrentUser
                .where((element) => element.sender == sender)
                .toList(),
          );
        }
        for (var chat in messages) {
          if (chat.length > 1) {
            chat.sort((a, b) => b.date.compareTo(a.date));
          }
        }
        messages.sort((a, b) => b.first.date.compareTo(a.first.date));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget toShow;
    if (noMessages) {
      toShow = const Center(
        child: Text('Aucun message pour le moment.'),
      );
    } else {
      toShow = ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                  '${messages[index].first.sender.firstName} ${messages[index].first.sender.lastName}'),
              subtitle: Text(messages[index].first.content),
              onTap: () {
                context.go('/chat', extra: {
                  'reciever':
                      messages[index].first.sender.id == MyApp.currentUser!.id
                          ? messages[index].first.receiver
                          : messages[index].first.sender,
                  'messages': messages[index],
                });
              },
            );
          });
    }
    return toShow;
  }
}
