import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_arosaje/services/api_service.dart';

import '../../main.dart';
import '../../models/address.dart';

class AddressCreationPage extends StatefulWidget {
  final Map<String, dynamic> map;
  const AddressCreationPage({super.key, required this.map});

  @override
  _AddressCreationPageState createState() => _AddressCreationPageState();
}

class _AddressCreationPageState extends State<AddressCreationPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController postalAddressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController otherInformationsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Form(
            key: _formKey,
            child: Column(children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: const Text("Créer une adresse",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              SizedBox(
                width: 310,
                child: Column(
                  children: [
                    TextFormField(
                      controller: postalAddressController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer une adresse';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Adresse',
                      ),
                    ),
                    TextFormField(
                      controller: cityController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer une ville';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Ville',
                      ),
                    ),
                    TextFormField(
                      controller: zipCodeController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Veuillez entrer un code postal';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Code postal',
                      ),
                    ),
                    TextFormField(
                      controller: otherInformationsController,
                      decoration: const InputDecoration(
                        labelText: 'Informations complémentaires',
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ApiService.createAddress(Address(
                                  user: MyApp.currentUser!,
                                  postalAddress: postalAddressController.text,
                                  city: cityController.text,
                                  zipCode: zipCodeController.text,
                                  otherInformations:
                                      otherInformationsController.text));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Adresse créée !')),
                              );
                              context.go(widget.map['originRoute']);
                            }
                          },
                          child: const Text("Créer l'adresse")),
                    ),
                  ],
                ),
              )
            ])),
      ],
    );
  }
}
