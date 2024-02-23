import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/address.dart';
import '../../services/api_service.dart';

class AddressManagmentPage extends StatefulWidget {
  const AddressManagmentPage({Key? key}) : super(key: key);

  @override
  _AddressManagmentPageState createState() => _AddressManagmentPageState();
}

class _AddressManagmentPageState extends State<AddressManagmentPage> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final Address address = arguments['address'];

    TextEditingController postalAddressController = TextEditingController(text: address.postalAddress);
    TextEditingController cityController = TextEditingController(text: address.city);
    TextEditingController zipCodeController = TextEditingController(text: address.zipCode);
    TextEditingController otherInformationController = TextEditingController(text: address.otherInformations ?? "");


    return ListView(
      children: [
        Form(
            key: _formKey,
            child: Column(children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: const Text("Modifier une\naddresse",
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
                      controller: otherInformationController,
                      decoration: const InputDecoration(
                        labelText: 'Informations complémentaires',
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ApiService.updateAddress(Address(
                                  id: address.id,
                                  user: MyApp.currentUser!,
                                  postalAddress: postalAddressController.text,
                                  city: cityController.text,
                                  zipCode: zipCodeController.text,
                                  otherInformations: otherInformationController.text == "" ? null : otherInformationController.text));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Adresse modifiée !')),
                              );
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("Modifier l'addresse")),
                    ),
                  ],
                ),
              )
            ])),
      ],
    );
  }
}
