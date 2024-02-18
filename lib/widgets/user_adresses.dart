import 'package:flutter/material.dart';

import '../models/Address.dart';

class UserAdresses extends StatefulWidget {
  const UserAdresses({Key? key}) : super(key: key);

  @override
  _UserAdressesState createState() => _UserAdressesState();
}

class _UserAdressesState extends State<UserAdresses> {
  List<Address> addresses = Address.getAddresses();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: addresses.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {
            Navigator.pushNamed(context, '/adress-managment', arguments: index);
          },
          title: Text("${addresses[index].postalAddress}"),
          subtitle:
              Text("${addresses[index].city} (${addresses[index].zipCode})"),
          leading: const Icon(Icons.nature_outlined),
          trailing: const Icon(Icons.edit_outlined),
        );
      },
    );
  }
}
