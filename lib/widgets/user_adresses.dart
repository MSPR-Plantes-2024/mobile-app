import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_arosaje/main.dart';
import 'package:mobile_app_arosaje/services/api_service.dart';

import '../models/address.dart';

class UserAdresses extends StatefulWidget {
  final Future<List<Address>>? futureAddresses;

  const UserAdresses({super.key, this.futureAddresses});

  @override
  _UserAdressesState createState() => _UserAdressesState();
}

class _UserAdressesState extends State<UserAdresses> {
  Future<List<Address>>? _futureAddresses;

  @override
  void initState() {
    super.initState();
    _futureAddresses = ApiService.getAddressesByUser(MyApp.currentUser!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<Address>>(
            future: _futureAddresses,
            builder: (context, AsyncSnapshot<List<Address>> snapshot) {
              if (snapshot.hasData) {
                return SizedBox(
                  height: 130,
                  child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        List<Address> addresses = snapshot.data!;
                        return ListTile(
                          onTap: () {
                            context.go('/address-managment',
                                extra: Map<String, dynamic>.from(
                                    {'address': addresses[index]}));
                          },
                          title: Text(addresses[index].postalAddress),
                          subtitle: Text(
                              "${addresses[index].city} (${addresses[index].zipCode})"),
                          leading: const Icon(Icons.nature_outlined),
                          trailing: const Icon(Icons.edit_outlined),
                        );
                      }),
                );
              } else if (snapshot.hasError) {
                return const Text('Erreur lors du chargement des addresses.');
              }
              return const SizedBox(
                  height: 50, width: 50, child: CircularProgressIndicator());
            }),
        ElevatedButton(
          onPressed: () {
            context.go('/address-creation',
                extra: Map<String, dynamic>.from(({'originRoute': '/user'})));
          },
          child: const Text('Ajouter une adresse'),
        )
      ],
    );
  }
}
