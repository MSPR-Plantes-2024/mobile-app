import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_arosaje/models/publication.dart';
import 'package:mobile_app_arosaje/widgets/date_time_picker.dart';

import '../../main.dart';
import '../../models/address.dart';
import '../../models/plant.dart';
import '../../services/api_service.dart';

class RequestCreationPage extends StatefulWidget {
  const RequestCreationPage({super.key});

  @override
  _RequestCreationPageState createState() => _RequestCreationPageState();
}

class _RequestCreationPageState extends State<RequestCreationPage> {
  List<Address> addresses = [];
  List<Plant> plants = [];
  Address? selectedAddress;
  ValueNotifier<Address?> selectedAddressNotifier =
      ValueNotifier<Address?>(null);
  Map<Plant, bool> plantSelections = {};

  final _formKey = GlobalKey<FormState>();
  late DateTime? pickedDateTime;
  TextEditingController dateTimeInput = TextEditingController(text: "");
  TextEditingController addPlantInput = TextEditingController();
  TextEditingController addAddressInput = TextEditingController();
  TextEditingController descriptionImput = TextEditingController();

  @override
  void initState() {
    super.initState();
    ApiService.getAddressesByUser(MyApp.currentUser!).then((value) {
      if (value.isNotEmpty) {
        setState(() {
          addresses = value;
          selectedAddress = addresses.first;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Container(
            width: 300,
            padding: const EdgeInsets.only(top: 20),
            child: Column(children: [
              const Text("Création d'une\ndemande",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Adresse'),
                        Row(
                          children: [
                            SizedBox(
                                width: 250,
                                child: selectedAddress != null
                                    ? DropdownButtonFormField(
                                        validator: (value) => value == null
                                            ? "Sélectionnez une adresse."
                                            : null,
                                        value: selectedAddress,
                                        items: addresses.map((Address address) {
                                          return DropdownMenuItem<Address>(
                                            value: address,
                                            child: Text(
                                                "${address.city} (${address.zipCode})"),
                                          );
                                        }).toList(),
                                        onChanged: (Address? newValue) {
                                          setState(() {
                                            selectedAddress = newValue;
                                            selectedAddressNotifier.value =
                                                newValue;
                                          });
                                        },
                                      )
                                    : const Text(
                                        "Veuillez ajouter une adresse.")),
                            IconButton(
                                onPressed: () {
                                  context.go('/address-creation',
                                      extra: Map<String, dynamic>.from({
                                        'originRoute': '/request-creation'
                                      }));
                                },
                                icon: const Icon(Icons.add)),
                          ],
                        ),
                        selectedAddress != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Plantes'),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(1),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black,
                                                  width: 1)),
                                          height: 200,
                                          width: 250,
                                          child: Scrollbar(
                                            child: ValueListenableBuilder(
                                                valueListenable:
                                                    selectedAddressNotifier,
                                                builder: (BuildContext context,
                                                    Address? value,
                                                    Widget? child) {
                                                  return FutureBuilder<
                                                          List<Plant>>(
                                                      future: ApiService
                                                          .getPlantsByAddress(
                                                              selectedAddress!),
                                                      builder: (BuildContext
                                                              context,
                                                          AsyncSnapshot<
                                                                  List<Plant>>
                                                              snapshot) {
                                                        if (snapshot.hasData) {
                                                          plants =
                                                              snapshot.data!;
                                                          for (Plant plant
                                                              in plants) {
                                                            plantSelections[
                                                                plant] = false;
                                                          }
                                                          return ListView
                                                              .builder(
                                                                  itemCount:
                                                                      snapshot
                                                                          .data!
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    Plant
                                                                        plant =
                                                                        snapshot
                                                                            .data![index];
                                                                    return CheckboxListTile(
                                                                        title: Text(plant
                                                                            .name),
                                                                        value: plantSelections[
                                                                            plant],
                                                                        onChanged:
                                                                            (bool?
                                                                                value) {
                                                                          setState(
                                                                              () {
                                                                            plantSelections[plant] =
                                                                                value!;
                                                                          });
                                                                        });
                                                                  });
                                                        } else if (snapshot
                                                            .hasError) {
                                                          return Text(
                                                              "${snapshot.error}");
                                                        }
                                                        return const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        );
                                                      });
                                                }),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: IconButton(
                                              onPressed: () {
                                                context.go('/address-managment',
                                                    extra: {
                                                      'originRoute':
                                                          '/request-creation',
                                                      'address': selectedAddress
                                                    });
                                              },
                                              icon: const Icon(Icons.add)),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        const Text('Date et heure'),
                        TextFormField(
                          controller: dateTimeInput,
                          //editing controller of this TextField
                          decoration: const InputDecoration(
                              icon: Icon(Icons.calendar_today)),
                          readOnly: true,
                          //set it true, so that user will not able to edit text
                          onTap: () async {
                            pickedDateTime =
                                await DateTimePicker.getDateTime(context);
                            if (pickedDateTime != null) {
                              setState(() {
                                dateTimeInput.text =
                                    DateFormat('dd-MM-yyyy HH:mm').format(
                                        pickedDateTime!); //set output date to TextField value.
                              });
                            }
                          },
                        ),
                        const Text('Description'),
                        TextFormField(
                          controller: descriptionImput,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrez une description.';
                            }
                            return null;
                          },
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKey.currentState!.validate()) {
                                  List<Plant> selectedPlants = plantSelections
                                      .entries
                                      .where((entry) => entry.value)
                                      .map((entry) => entry.key)
                                      .toList();
                                  ApiService.createPublication(Publication(
                                      date: pickedDateTime!,
                                      address: selectedAddress!,
                                      publisher: MyApp.currentUser!,
                                      description: descriptionImput.text,
                                      plants: selectedPlants));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Publication créée !')),
                                  );
                                }
                              },
                              child: const Text('Publier',
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        ),
                      ]))
            ]),
          ),
        ),
      ],
    );
  }
}
