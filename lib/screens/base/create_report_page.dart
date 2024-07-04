import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_arosaje/models/picture.dart';
import 'package:mobile_app_arosaje/services/api_picture_service.dart';
import 'package:mobile_app_arosaje/services/api_plant_service.dart';

import '../../models/plant.dart';
import '../../models/plant_condition.dart';
import '../../models/publication.dart';
import '../../widgets/date_time_picker.dart';
import '../../widgets/picture_form_field.dart';

class CreateReportPage extends StatefulWidget {
  final Map<String, dynamic> map;

  const CreateReportPage({super.key, required this.map});

  @override
  _CreateReportPageState createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final _formKey = GlobalKey<FormState>();
  late DateTime? pickedDateTime;
  TextEditingController dateTimeInput = TextEditingController(text: "");
  TextEditingController titleInput = TextEditingController(text: "");
  Map<Plant, File?> plantPictures = {};
  Map<Plant, bool> plantProblems = {};
  TextEditingController textInput = TextEditingController();

  @override
  void initState() {
    super.initState();
    final Publication publication = widget.map['publication'];
    for (Plant plant in publication.plants) {
      plantPictures[plant] = null;
      plantProblems[plant] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Publication publication = widget.map['publication'];
    return Scrollbar(
        child: Form(
      key: _formKey,
      child: ListView(children: [
        Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          child: const Text("Rapport d'entretient",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
        ),
        const Text("Date et heure"),
        TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'Veuillez entrer une date';
            }
            return null;
          },
          controller: dateTimeInput,
          //editing controller of this TextField
          decoration: const InputDecoration(icon: Icon(Icons.calendar_today)),
          readOnly: true,
          //set it true, so that user will not able to edit text
          onTap: () async {
            pickedDateTime = await DateTimePicker.getDateTime(context);
            if (pickedDateTime != null) {
              setState(() {
                dateTimeInput.text = DateFormat('dd-MM-yyyy HH:mm').format(
                    pickedDateTime!); //set output date to TextField value.
              });
            }
          },
        ),
        const Text("Titre"),
        TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return 'Veuillez entrer un titre';
            }
            return null;
          },
          controller: titleInput,
        ),
        const Text("Plantes"),
        ListView.builder(
          shrinkWrap: true,
          itemCount: publication.plants.length,
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                children: [
                  Text(publication.plants[index].name),
                  Row(
                    children: [
                      PictureFormField(
                        picture: plantPictures[publication.plants[index]],
                        onPictureChanged: (File? newPicture) {
                          setState(() {
                            plantPictures[publication.plants[index]] =
                                newPicture;
                          });
                        },
                      ),
                      Column(children: [
                        const Text("Un problème ?"),
                        Row(children: [
                          Column(
                            children: [
                              Radio(
                                value: true,
                                groupValue:
                                    plantProblems[publication.plants[index]],
                                onChanged: (value) {
                                  setState(() {
                                    plantProblems[publication.plants[index]] =
                                        value!;
                                  });
                                },
                              ),
                              const Text("Oui")
                            ],
                          ),
                          Column(children: [
                            Radio(
                              value: false,
                              groupValue:
                                  plantProblems[publication.plants[index]],
                              onChanged: (value) {
                                setState(() {
                                  plantProblems[publication.plants[index]] =
                                      value!;
                                });
                              },
                            ),
                            const Text("Non")
                          ])
                        ])
                      ])
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        const Text("Autre chose à ajouter ?"),
        TextFormField(
          controller: textInput,
        ),
        TextButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                for(Plant plant in publication.plants){
                  if(plantProblems[plant] == true){
                    plant.plantCondition = PlantCondition(
                      id: 4,
                      name: "Problème",
                    );
                    await ApiPlantService.updatePlant(plant);
                  }
                }
                final List<Picture> pictures = [];
                log('plantPictures = $plantPictures');
                for (File? file in plantPictures.values) {
                  if (file != null) {
                    // log('file = $file');
                    // log('${(await ApiService.createPicture(
                    //     Picture(data: file.readAsBytesSync())))!}');
                    pictures.add((await ApiPictureService.createPicture(
                        Picture(data: file.readAsBytesSync())))!);
                  }
                }
                // await ApiService.createReport(
                //     Report(
                //         date: pickedDateTime!,
                //         title: titleInput.text,
                //         publication: publication,
                //         pictures: pictures,
                //         text: textInput.text));
                if (mounted) {
                  Navigator.of(context).pop();
                }
              }
            },
            child: const Text('Ajouter'))
      ]),
    ));
  }
}
