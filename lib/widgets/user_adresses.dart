import 'package:flutter/material.dart';
import 'package:mobile_app_arosaje/services/api_service.dart';

import '../models/address.dart';

class UserAdresses extends StatefulWidget {
  const UserAdresses({Key? key}) : super(key: key);

  @override
  _UserAdressesState createState() => _UserAdressesState();
}

class _UserAdressesState extends State<UserAdresses> {
  late Future<List<Address>?> addressesFuture;

  @override
  void initState() {
    super.initState();
    addressesFuture = ApiService.getAddresses();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: addressesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator(); // or any other loading widget
          } else if (snapshot.hasError) {
            return const Text('Erreur lors du chargement des addresses.'); // or any other error widget
          } else {
            final List<Address> addresses = snapshot.data ?? [];
            return ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.pushNamed(context, '/address-managment',
                        arguments: {'address' : addresses[index]});
                  },
                  title: Text("${addresses[index].postalAddress}"),
                  subtitle: Text(
                      "${addresses[index].city} (${addresses[index].zipCode})"),
                  leading: const Icon(Icons.nature_outlined),
                  trailing: const Icon(Icons.edit_outlined),
                );
              },
            );
          }
        });
  }
}
