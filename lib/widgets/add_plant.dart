import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_arosaje/models/picture.dart';
import 'package:mobile_app_arosaje/models/plant.dart';
import 'package:mobile_app_arosaje/widgets/picture_form_field.dart';

import '../main.dart';
import '../models/address.dart';
import '../models/plant_condition.dart';
import '../services/api_service.dart';

class AddPlant extends StatefulWidget {
  final Address address;
  const AddPlant({super.key, required this.address});

  @override
  _AddPlantState createState() => _AddPlantState();
}

class _AddPlantState extends State<AddPlant> {
  final _plantFormKey = GlobalKey<FormState>();
  File? _picture;

  TextEditingController plantNameController = TextEditingController();
  TextEditingController plantDescriptionController = TextEditingController();
  List<PlantCondition> plantConditions = [];
  PlantCondition? selectedPlantCondition;

  @override
  void initState() {
    super.initState();
    ApiService.getPlantConditions().then((value) {
      setState(() {
        if (value.isNotEmpty) {
          plantConditions = value;
          selectedPlantCondition = plantConditions.first;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter une plante'),
      content: Form(
        key: _plantFormKey,
        child: Column(
          children: [
            TextFormField(
              controller: plantNameController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Veuillez entrer un nom';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Nom',
              ),
            ),
            DropdownButtonFormField<PlantCondition>(
                items: plantConditions.map<DropdownMenuItem<PlantCondition>>(
                    (PlantCondition plantCondition) {
                  return DropdownMenuItem(
                      value: plantCondition, child: Text(plantCondition.name));
                }).toList(),
                value: selectedPlantCondition,
                onChanged: (PlantCondition? value) {
                  selectedPlantCondition = value;
                },
                decoration: const InputDecoration(
                  labelText: 'Condition',
                )),
            TextFormField(
              controller: plantDescriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
              ),
            ),
            FormField(validator: (value) {
              if (_picture == null) {
                return 'Veuillez ajouter une photo';
              }
              return null;
            }, builder: (FormFieldState state) {
              return PictureFormField(
                picture: _picture,
                onPictureChanged: (File? newPicture) {
                  setState(() {
                    _picture = newPicture;
                  });
                },
              );
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Annuler')),
        TextButton(
            onPressed: () async {
              if (_plantFormKey.currentState!.validate()) {
                await ApiService.createPlant(Plant(
                    address: widget.address,
                    user: MyApp.currentUser!,
                    name: plantNameController.text,
                    description: plantDescriptionController.text,
                    plantCondition: selectedPlantCondition!,
                    picture: await ApiService.createPicture(Picture(
                      date: DateTime.now(),
                      data: _picture!.readAsBytesSync(),
                    ))));
                if (mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: const Text('Ajouter'))
      ],
    );
  }
}
