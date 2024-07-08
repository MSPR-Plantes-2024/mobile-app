import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_arosaje/services/api_address_service.dart';
import 'package:mobile_app_arosaje/services/api_plant_service.dart';

import '../../main.dart';
import '../../models/address.dart';
import '../../models/plant.dart';

class AddressManagmentPage extends StatefulWidget {
  final Map<String, dynamic> map;
  const AddressManagmentPage({super.key, required this.map});

  @override
  _AddressManagmentPageState createState() => _AddressManagmentPageState();
}

class _AddressManagmentPageState extends State<AddressManagmentPage> {
  final _addressFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Address address = widget.map['address'];

    TextEditingController postalAddressController =
        TextEditingController(text: address.postalAddress);
    TextEditingController cityController =
        TextEditingController(text: address.city);
    TextEditingController zipCodeController =
        TextEditingController(text: address.zipCode);
    TextEditingController otherInformationController =
        TextEditingController(text: address.otherInformations ?? "");

    return ListView(
      children: [
        Form(
            key: _addressFormKey,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Plantes'),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1)),
                                height: 200,
                                width: 250,
                                child: Scrollbar(
                                  child: FutureBuilder<List<Plant>>(
                                      future:
                                          ApiPlantService.getByAddress(
                                              address),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<Plant>> snapshot) {
                                        if (snapshot.hasData) {
                                          List<Plant> plants = snapshot.data!;
                                          Map<Plant, bool> plantSelections = {};
                                          for (Plant plant in plants) {
                                            plantSelections[plant] = false;
                                          }
                                          return ListView.builder(
                                              itemCount: snapshot.data!.length,
                                              itemBuilder: (context, index) {
                                                Plant plant =
                                                    snapshot.data![index];
                                                return CheckboxListTile(
                                                    title: Text(plant.name),
                                                    value:
                                                        plantSelections[plant],
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        plantSelections[plant] =
                                                            value!;
                                                      });
                                                    });
                                              });
                                        } else if (snapshot.hasError) {
                                          return Text("${snapshot.error}");
                                        }
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: IconButton(
                                    onPressed: () {
                                      context.push('/add-plant', extra: {
                                        'address': address,
                                        'originRoute': '/address-management'
                                      });
                                    },
                                    icon: const Icon(Icons.add)),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_addressFormKey.currentState!.validate()) {
                              await ApiAddressService.update(Address(
                                  id: address.id,
                                  user: MyApp.currentUser!,
                                  postalAddress: postalAddressController.text,
                                  city: cityController.text,
                                  zipCode: zipCodeController.text,
                                  otherInformations:
                                      otherInformationController.text == ""
                                          ? null
                                          : otherInformationController.text));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Adresse modifiée !')),
                              );
                              context.go(widget.map['originRoute']);
                            }
                          },
                          child: const Text("Modifier l'addresse")),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                            onPressed: () {
                              context.push('/address-management/delete-address',
                                  extra: {'address': address});
                            },
                            child: const Text("Supprimer l'addresse")))
                  ],
                ),
              )
            ])),
      ],
    );
  }
}
