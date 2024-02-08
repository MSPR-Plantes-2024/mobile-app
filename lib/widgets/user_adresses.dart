import 'package:flutter/material.dart';

class UserAdresses extends StatefulWidget {
  const UserAdresses({Key? key}) : super(key: key);

  @override
  _UserAdressesState createState() => _UserAdressesState();
}

class _UserAdressesState extends State<UserAdresses> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text("Adresse 1"),
          leading: Icon(Icons.home_outlined),
          trailing: Icon(Icons.edit_outlined),
        ),
        ListTile(
          title: Text("Adresse 2"),
          leading: Icon(Icons.home_outlined),
          trailing: Icon(Icons.edit_outlined),
        ),
        ListTile(
          title: Text("Adresse 3"),
          leading: Icon(Icons.home_outlined),
          trailing: Icon(Icons.edit_outlined),
        ),
      ],
    );
  }
}
