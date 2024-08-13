import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_arosaje/models/user.dart';
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
  User currentUser = User.getCurrent();

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
                child: const Text("Modifier une\nadresse",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
              ),
              SizedBox(
                width: 350,
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
                                width: 300,
                                child: Scrollbar(
                                  child: FutureBuilder<List<Plant>>(
                                      future:
                                          ApiPlantService.getByAddress(
                                              address),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<Plant>> snapshot) {
                                        if (snapshot.hasData) {
                                          List<Plant> plants = snapshot.data!;

                                          return ListView.builder(
                                              itemCount: plants.length,
                                              itemBuilder: (context, index) {
                                                Plant plant = plants[index];
                                                final Color statusColor;
                                                switch (plant.plantCondition.name) {
                                                  case 'Problème':
                                                    statusColor = Colors.orange;
                                                    break;
                                                  case 'Abimé':
                                                    statusColor = Colors.red;
                                                    break;
                                                  case 'Malade':
                                                    statusColor = Colors.purple;
                                                    break;
                                                  default:
                                                    statusColor = Colors.green;
                                                }
                                                return ListTile(
                                                    leading: Icon(
                                                        Icons.eco, color: statusColor),
                                                    title: Text(plant.name),
                                                    subtitle: Text(
                                                        'Status : ${plant.plantCondition.name}'),
                                                    trailing: SizedBox(
                                                      width: 70,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          SizedBox(
                                                            width: 30,
                                                            child: IconButton(
                                                              iconSize: 20,
                                                              icon: const Icon(
                                                                  Icons.edit_outlined,
                                                              ),
                                                              onPressed: () {
                                                                context.push('/add-edit-plant',
                                                                    extra: {
                                                                      'plant': plant,
                                                                      'originRoute': '/address-management'
                                                                    });
                                                              },
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 30,
                                                            child: IconButton(
                                                                iconSize: 20,
                                                                icon: const Icon(
                                                                  Icons.delete_outline
                                                              ),
                                                              onPressed: () {
                                                                context.push(
                                                                    '/address-management/delete-plant',
                                                                    extra: {
                                                                      'plant': plant,
                                                                    });
                                                              }),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                );
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
                                      context.push('/add-edit-plant', extra: {
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
                                  user: currentUser,
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
                          child: const Text("Modifier l'adresse")),
                    ),
                    Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ElevatedButton(
                            onPressed: () {
                              context.push('/address-management/delete-address',
                                  extra: {'address': address});
                            },
                            child: const Text("Supprimer l'adresse")))
                  ],
                ),
              )
            ])),
      ],
    );
  }
}
