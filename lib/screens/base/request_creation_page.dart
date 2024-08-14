import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_arosaje/models/publication.dart';
import 'package:mobile_app_arosaje/models/user.dart';
import 'package:mobile_app_arosaje/services/api_address_service.dart';
import 'package:mobile_app_arosaje/services/api_plant_service.dart';
import 'package:mobile_app_arosaje/services/api_publication_service.dart';
import 'package:mobile_app_arosaje/widgets/date_time_picker.dart';

import '../../main.dart';
import '../../models/address.dart';
import '../../models/plant.dart';

class RequestCreationPage extends StatefulWidget {
  final Map<String, dynamic> map;
  const RequestCreationPage({super.key, this.map = const {}});

  @override
  _RequestCreationPageState createState() => _RequestCreationPageState();
}

class _RequestCreationPageState extends State<RequestCreationPage> {
  List<Address> addresses = [];
  ValueNotifier<Address?> selectedAddressNotifier =
      ValueNotifier<Address?>(null);
  Map<Plant, bool> plantSelections = {};
  final _formKey = GlobalKey<FormState>();
  late DateTime? pickedDateTimeBegin;
  late DateTime? pickedDateTimeEnd;
  TextEditingController dateTimeBeginInput = TextEditingController(text: "");
  TextEditingController dateTimeEndInput = TextEditingController(text: "");
  TextEditingController addPlantInput = TextEditingController();
  TextEditingController addAddressInput = TextEditingController();
  TextEditingController descriptionImput = TextEditingController();
  User currentUser = User.getCurrent();

  Future<void> setPlantList(Address address) async {
    List<Plant> plants = await ApiPlantService.getByAddress(address);
    if (plants.isNotEmpty) {
      setState(() {
        plantSelections = {};
        for (var plant in plants) {
          plantSelections[plant] = false;
        }
      });
    } else {
      setState(() {
        plantSelections = {};
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ApiAddressService.getByUser(currentUser).then((value) {
      if (value.isNotEmpty) {
        setState(() {
          addresses = value;
          if (widget.map['address'] != null) {
            selectedAddressNotifier.value = addresses.firstWhere(
                (element) => element.id == widget.map['address'].id);
          } else {
            selectedAddressNotifier.value = addresses.first;
          }
          setPlantList(addresses.first);
        });
      }
    });
    selectedAddressNotifier.addListener(() {
      setPlantList(selectedAddressNotifier.value!);
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
                                child: selectedAddressNotifier.value != null
                                    ? DropdownButtonFormField(
                                        validator: (value) => value == null
                                            ? "Sélectionnez une adresse."
                                            : null,
                                        value: selectedAddressNotifier.value,
                                        items: addresses.map((Address address) {
                                          return DropdownMenuItem<Address>(
                                            value: address,
                                            child: Text(
                                                "${address.city} (${address.zipCode})"),
                                          );
                                        }).toList(),
                                        onChanged: (Address? newValue) {
                                          setState(() {
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
                        selectedAddressNotifier.value != null
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
                                                Address? address,
                                                Widget? child) {
                                              return ListView.builder(
                                                  itemCount: plantSelections
                                                      .entries.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return CheckboxListTile(
                                                        title: Text(
                                                            plantSelections
                                                                .entries
                                                                .elementAt(
                                                                    index)
                                                                .key
                                                                .name),
                                                        value: plantSelections
                                                            .entries
                                                            .elementAt(index)
                                                            .value,
                                                        onChanged: (newValue) {
                                                          setState(() {
                                                            plantSelections.update(
                                                                plantSelections
                                                                    .entries
                                                                    .elementAt(
                                                                        index)
                                                                    .key,
                                                                (value) =>
                                                                    newValue!,
                                                                ifAbsent: () =>
                                                                    newValue!);
                                                          });
                                                        });
                                                  });
                                            },
                                          )),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: IconButton(
                                              onPressed: () {
                                                context.push('/add-plant',
                                                    extra:
                                                    {
                                                      'address' : selectedAddressNotifier.value,
                                                      'originRoute': '/request-creation'
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
                        const Text('Date et heure de début'),
                        TextFormField(
                          controller: dateTimeBeginInput,
                          //editing controller of this TextField
                          decoration: const InputDecoration(
                              icon: Icon(Icons.calendar_today)),
                          readOnly: true,
                          //set it true, so that user will not able to edit text
                          onTap: () async {
                            pickedDateTimeBegin =
                                await DateTimePicker.getDateTime(context);
                            if (pickedDateTimeBegin != null) {
                              setState(() {
                                dateTimeBeginInput.text =
                                    DateFormat('dd-MM-yyyy HH:mm').format(
                                        pickedDateTimeBegin!); //set output date to TextField value.
                              });
                            }
                          },
                        ),
                        const Text('Date et heure de fin'),
                        TextFormField(
                          controller: dateTimeEndInput,
                          //editing controller of this TextField
                          decoration: const InputDecoration(
                              icon: Icon(Icons.calendar_today)),
                          readOnly: true,
                          //set it true, so that user will not able to edit text
                          onTap: () async {
                            pickedDateTimeEnd =
                            await DateTimePicker.getDateTime(context);
                            if (pickedDateTimeEnd != null) {
                              setState(() {
                                dateTimeEndInput.text =
                                    DateFormat('dd-MM-yyyy HH:mm').format(
                                        pickedDateTimeEnd!); //set output date to TextField value.
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
                              onPressed: () async {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKey.currentState!.validate()) {
                                  List<Plant> selectedPlants = plantSelections
                                      .entries
                                      .where((entry) => entry.value)
                                      .map((entry) => entry.key)
                                      .toList();
                                  await ApiPublicationService.create(Publication(
                                      dateTimeBegin: pickedDateTimeBegin!,
                                      dateTimeEnd: pickedDateTimeEnd!,
                                      address: selectedAddressNotifier.value!,
                                      publisher: currentUser,
                                      description: descriptionImput.text,
                                      plants: selectedPlants));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Publication créée !')),
                                  );
                                  context.go('/my-publications');
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
