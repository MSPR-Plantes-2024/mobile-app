import 'package:flutter/material.dart';

class UserAdresses extends StatefulWidget {
  const UserAdresses({Key? key}) : super(key: key);

  @override
  _UserAdressesState createState() => _UserAdressesState();
}

class _UserAdressesState extends State<UserAdresses> {
  List<String> adresses = [
    "Adresse 1",
    "Adresse 2",
    "Adresse 3",
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: adresses.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.pushNamed(context, '/adress-managment', arguments: index);
          },
          title: Text("Gardiennage ${index + 1}"),
          subtitle: Text(adresses[index]),
          leading: const Icon(Icons.nature_outlined),
          trailing: const Icon(Icons.edit_outlined),
        );
      },
    );
  }
}
