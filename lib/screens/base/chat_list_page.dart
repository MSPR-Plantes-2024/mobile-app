import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_arosaje/models/message.dart';
import 'package:mobile_app_arosaje/models/user.dart';
import 'package:mobile_app_arosaje/services/api_message_service.dart';


class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  late List<Message> messagesToSort;
  User currentUser = User.getCurrent();

  // Future<List<List<Message>>> prepareMessages() async {
 //    List<List<Message>> messages = [];
 //    messagesToSort = await ApiMessageService.getMessagesByUser(GetStorage().read('currentUser')!);
 //    if (messagesToSort.isNotEmpty) {
 //      List<Message> messagesToSortCopy = List<Message>.from(messagesToSort);
 //      for (Message message in messagesToSortCopy) {
 //        if (message.sender.id == GetStorage().read('currentUser')!.id) {
 //          if(messages.isNotEmpty) {
 //            List<List<Message>> messagesCopy = List<List<Message>>.from(messages);
 //            for (List<Message> messageList in messagesCopy) {
 //              if (message.receiver.id == messageList.first.receiver.id) {
 //                messages.remove(messageList);
 //                messageList.add(message);
 //                messages.add(messageList);
 //                messagesToSort.remove(message);
 //                break;
 //              }
 //            }
 //            if (messagesToSort.contains(message)) {
 //              messages.add([message]);
 //              messagesToSort.remove(message);
 //            }
 //          } else {
 //            messages.add([message]);
 //            messagesToSort.remove(message);
 //          }
 //        }
 //      }
 //
 //      messagesToSortCopy = List<Message>.from(messagesToSort);
 //      for (Message message in messagesToSort) {
 //        List<List<Message>> messagesCopy = List<List<Message>>.from(messages);
 //        for (List<Message> messageList in messagesCopy) {
 //          if (messageList.first.receiver.id == message.sender.id) {
 //            messages.remove(messageList);
 //            messageList.add(message);
 //            messages.add(messageList);
 //            messagesToSortCopy.remove(message);
 //            break;
 //          }
 //        }
 //        if (messagesToSortCopy.contains(message)) {
 //          messages.add([message]);
 //          messagesToSortCopy.remove(message);
 //        }
 //      }
 //      for (List<Message> message in messages) {
 //        message.sort((a, b) => a.date.compareTo(b.date));
 //      }
 //      messages.sort((a, b) => b.last.date.compareTo(a.last.date));
 //      return messages;
 //    }
 //    return [];
 //  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<List<Message>>>(
      //future: prepareMessages(),
      future: ApiMessageService.getByUser(currentUser),
      builder:
          (BuildContext context, AsyncSnapshot<List<List<Message>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
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
                      title: Text(messages[index].first.sender.id ==
                          currentUser.id
                          ? '${messages[index].first.receiver.firstName} ${messages[index].first.receiver.lastName}'
                          : '${messages[index].first.sender.firstName} ${messages[index].first.sender.lastName}'
                      ),
                      trailing: Text(
                          DateFormat('dd/MM/yyyy HH:mm').format(messages[index].last.date)),
                      subtitle: Text('${User.isCurrent(messages[index].last.sender) ? 'Vous' : messages[index].last.sender.firstName} : ${messages[index].last.text}'),
                      onTap: () {
                        context.go('/chat', extra: {
                          'contact': messages[index].first.sender.id ==
                              currentUser.id
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
