import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_arosaje/models/picture.dart';
import 'package:mobile_app_arosaje/models/plant.dart';
import 'package:mobile_app_arosaje/models/user.dart';
import 'package:mobile_app_arosaje/services/api_picture_service.dart';
import 'package:mobile_app_arosaje/services/api_plant_condition.dart';
import 'package:mobile_app_arosaje/services/api_plant_service.dart';
import 'package:mobile_app_arosaje/widgets/picture_form_field.dart';
import 'package:mobile_app_arosaje/models/address.dart';
import 'package:mobile_app_arosaje/models/plant_condition.dart';
import 'package:path_provider/path_provider.dart';


class AddEditPlant extends StatefulWidget {
  final Map<String, dynamic> map;
  const AddEditPlant({super.key, required this.map});

  @override
  _AddEditPlantState createState() => _AddEditPlantState();
}

class _AddEditPlantState extends State<AddEditPlant> {
  late Address address;
  final _plantFormKey = GlobalKey<FormState>();
  File? _picture;
  User currentUser = User.getCurrent();
  TextEditingController plantNameController = TextEditingController();
  TextEditingController plantDescriptionController = TextEditingController();
  List<PlantCondition> plantConditions = [];
  PlantCondition? selectedPlantCondition;

  Future<File> getFileFromUint8List(Uint8List data) async {
    final tempDir = await getTemporaryDirectory();
    final picture = File('${tempDir.path}/temp_picture_${DateTime.now().millisecondsSinceEpoch}.png');
    return picture.writeAsBytes(data);
  }

  @override
  void initState() {
    super.initState();
    if (widget.map['plant'] != null) {
      Plant plant = widget.map['plant'];
      address = widget.map['address'];
      plantNameController.text = plant.name;
      plantDescriptionController.text = plant.description ?? '';
      getFileFromUint8List(Uint8List.fromList(plant.picture!.data)).then((value) {
        setState(() {
          _picture = value;
        });
      });
    } else {
      address = widget.map['address'];
    }
    ApiPlantConditionService.getAll().then((value) {
      setState(() {
        if (value.isNotEmpty) {
          plantConditions = value;
          widget.map['plant'] == null
              ? selectedPlantCondition = plantConditions.first
              : selectedPlantCondition = plantConditions
                  .where((element) =>
                      element.id == widget.map['plant'].plantCondition!.id)
                  .first;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.map['pant'] != null
          ? 'Modifier une plante'
          : 'Ajouter une plante'),
      content: Form(
        key: _plantFormKey,
        child: SingleChildScrollView(
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
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                child: TextFormField(
                  controller: plantDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
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
              _picture != null
                  ? Image.file(_picture!, height: 100)
                  : const SizedBox(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('Annuler')),
        TextButton(
            onPressed: () async {
              if (_plantFormKey.currentState!.validate()) {
                if (widget.map['plant'] != null) {
                  ApiPlantService.update(Plant(
                          address: address,
                          user: currentUser,
                          name: plantNameController.text,
                          description: plantDescriptionController.text,
                          plantCondition: selectedPlantCondition!,
                          picture: _picture!.readAsBytesSync() ==
                                  widget.map['plant'].picture.data
                              ? widget.map['plant'].picture
                              : await ApiPictureService.create(Picture(
                                  date: DateTime.now(),
                                  data: _picture!.readAsBytesSync(),
                                ))))
                      .then((value) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Plante mise à jour')),
                      );
                      context.go('/address-management',
                          extra: {'address': address});
                    }
                  });
                } else {
                  ApiPlantService.create(Plant(
                          address: address,
                          user: currentUser,
                          name: plantNameController.text,
                          description: plantDescriptionController.text,
                          plantCondition: selectedPlantCondition!,
                          picture: await ApiPictureService.create(Picture(
                            date: DateTime.now(),
                            data: _picture!.readAsBytesSync(),
                          ))))
                      .then((value) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Plante ajoutée')),
                      );
                      setState(() {
                        context.go(widget.map['originRoute'],
                            extra: {'address': address});
                      });
                    }
                  });
                }
              }
            },
            child: const Text('Ajouter'))
      ],
    );
  }
}
