import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app_arosaje/models/plant_condition.dart';

import '../../main.dart';
import '../../models/address.dart';
import '../../models/plant.dart';
import '../../services/api_service.dart';

class AddressManagmentPage extends StatefulWidget {
  final Map<String, dynamic> map;
  const AddressManagmentPage({super.key, required this.map});

  @override
  _AddressManagmentPageState createState() => _AddressManagmentPageState();
}

class _AddressManagmentPageState extends State<AddressManagmentPage> {
  final _addressFormKey = GlobalKey<FormState>();
  final _plantFormKey = GlobalKey<FormState>();

  File? _picture;

  final _picker = ImagePicker();
  // Implementing the image picker
  Future<bool> _openImagePicker(ImageSource source) async {
    final XFile? pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _picture = File(pickedImage.path);
      });
      return true;
    } else {
      return false;
    }
  }

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
    TextEditingController plantNameController = TextEditingController();
    TextEditingController plantDescriptionController = TextEditingController();

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
                                      future: ApiService.getPlantsByAddress(
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
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            PlantCondition?
                                                selectedPlantCondition;
                                            return AlertDialog(
                                              title: const Text(
                                                  'Ajouter une plante'),
                                              content: Form(
                                                key: _plantFormKey,
                                                child: Column(
                                                  children: [
                                                    TextFormField(
                                                      controller:
                                                          plantNameController,
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Veuillez entrer un nom';
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText: 'Nom',
                                                      ),
                                                    ),
                                                    FutureBuilder<
                                                            List<
                                                                PlantCondition>>(
                                                        future: ApiService
                                                            .getPlantConditions(),
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<
                                                                    List<
                                                                        PlantCondition>>
                                                                snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            print (snapshot.data!);
                                                            selectedPlantCondition =
                                                                snapshot.data!
                                                                    .first;
                                                            return DropdownButtonFormField<
                                                                    PlantCondition>(
                                                                items: snapshot.data!.map<
                                                                    DropdownMenuItem<
                                                                        PlantCondition>>((PlantCondition
                                                                    plantCondition) {
                                                                  return DropdownMenuItem(
                                                                      value:
                                                                          plantCondition,
                                                                      child: Text(
                                                                          plantCondition
                                                                              .name));
                                                                }).toList(),
                                                                value:
                                                                    selectedPlantCondition,
                                                                onChanged:
                                                                    (PlantCondition?
                                                                        value) {
                                                                  selectedPlantCondition =
                                                                      value;
                                                                },
                                                                decoration:
                                                                    const InputDecoration(
                                                                  labelText:
                                                                      'Condition',
                                                                ));
                                                          } else if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                                "${snapshot.error}");
                                                          }
                                                          return const Center(
                                                            child:
                                                                CircularProgressIndicator(),
                                                          );
                                                        }),
                                                    TextFormField(
                                                      controller:
                                                          plantDescriptionController,
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            'Description',
                                                      ),
                                                    ),
                                                    FormField(validator:
                                                        (value) {
                                                      if (_picture == null) {
                                                        return 'Veuillez ajouter une photo';
                                                      }
                                                      return null;
                                                    }, builder:
                                                        (FormFieldState state) {
                                                      return Row(
                                                        children: [
                                                          IconButton(
                                                            icon: const Icon(Icons
                                                                .add_a_photo_outlined),
                                                            onPressed: () {
                                                              _openImagePicker(
                                                                  ImageSource
                                                                      .camera);
                                                            },
                                                          ),
                                                          IconButton(
                                                            icon: const Icon(Icons
                                                                .folder_outlined),
                                                            onPressed: () {
                                                              _openImagePicker(
                                                                  ImageSource
                                                                      .gallery);
                                                            },
                                                          ),
                                                          Icon(_picture == null
                                                              ? Icons.close
                                                              : Icons.check),
                                                        ],
                                                      );
                                                    })
                                                  ],
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      context.pop();
                                                    },
                                                    child:
                                                        const Text('Annuler')),
                                                TextButton(
                                                    onPressed: () {
                                                      if (_plantFormKey
                                                          .currentState!
                                                          .validate()) {
                                                        setState(() {
                                                          ApiService.createPlant(Plant(
                                                              address: address,
                                                              user: MyApp
                                                                  .currentUser!,
                                                              name:
                                                                  plantNameController
                                                                      .text,
                                                              description:
                                                                  plantDescriptionController
                                                                      .text,
                                                              plantCondition:
                                                                  selectedPlantCondition!,
                                                              picture: null));
                                                        });
                                                      }
                                                    },
                                                    child:
                                                        const Text('Ajouter'))
                                              ],
                                            );
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
                          onPressed: () {
                            if (_addressFormKey.currentState!.validate()) {
                              ApiService.updateAddress(Address(
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
                  ],
                ),
              )
            ])),
      ],
    );
  }
}
