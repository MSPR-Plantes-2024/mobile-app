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
  Address? selectedValue;
  final _formKey = GlobalKey<FormState>();
  Map<Plant, bool> plantSelections = {};

  late DateTime? pickedDateTime;
  TextEditingController dateTimeInput = TextEditingController();
  TextEditingController addPlantInput = TextEditingController();
  TextEditingController addAddressInput = TextEditingController();
  TextEditingController descriptionImput = TextEditingController();

  @override
  void initState() {
    dateTimeInput.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Address>> addresses =
        ApiService.getAddressesByUser(MyApp.currentUser!);
    Future<List<Plant>> plants = ApiService.getPlantsByAddress(selectedValue!);

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
                                child: FutureBuilder<List<Address>>(
                                    future: addresses,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<Address>> snapshot) {
                                      if (snapshot.hasData) {
                                        return DropdownButtonFormField(
                                          validator: (value) => value == null
                                              ? "Sélectionnez une adresse."
                                              : null,
                                          value: selectedValue,
                                          items: snapshot.data!
                                              .map((Address address) {
                                            return DropdownMenuItem(
                                              value: address,
                                              child: Text(
                                                  "${address.city} (${address.zipCode})"),
                                            );
                                          }).toList(),
                                          onChanged: (Address? newValue) {
                                            setState(() {
                                              selectedValue = newValue!;
                                            });
                                          },
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text("${snapshot.error}");
                                      }
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    })),
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
                                          future: plants,
                                          builder: (BuildContext context,
                                              AsyncSnapshot<List<Plant>>
                                                  snapshot) {
                                            if (snapshot.hasData) {
                                              return ListView.builder(
                                                  itemCount:
                                                      snapshot.data!.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    Plant plant =
                                                        snapshot.data![index];
                                                    return CheckboxListTile(
                                                        title: Text(plant.name),
                                                        value: plantSelections[
                                                            plant],
                                                        onChanged:
                                                            (bool? value) {
                                                          setState(() {
                                                            plantSelections[
                                                                plant] = value!;
                                                          });
                                                        });
                                                  });
                                            } else if (snapshot.hasError) {
                                              return Text("${snapshot.error}");
                                            }
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: IconButton(
                                        onPressed: () {
                                          context.go('/address-managment',
                                              extra: selectedValue);
                                        },
                                        icon: const Icon(Icons.add)),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
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
                                      address: selectedValue!,
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
