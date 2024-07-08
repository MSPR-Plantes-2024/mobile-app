import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_arosaje/services/api_publication_service.dart';

import '../../main.dart';
import '../../models/publication.dart';
import '../../widgets/date_time_picker.dart';
import '../../widgets/image_carousel.dart';

class DetailsPublicationPage extends StatefulWidget {
  final Map<String, dynamic> map;
  const DetailsPublicationPage({super.key, required this.map});

  @override
  _DetailsPublicationPageState createState() => _DetailsPublicationPageState();
}

class _DetailsPublicationPageState extends State<DetailsPublicationPage> {
  @override
  Widget build(BuildContext context) {
    final Publication publication = widget.map['publication'];
    final Widget toShow;
    TextEditingController dateTimeBeginInput = TextEditingController(
        text: DateFormat('dd-MM-yyyy HH:mm').format(publication.dateTimeBegin));
    TextEditingController dateTimeEndInput = TextEditingController(
        text: DateFormat('dd-MM-yyyy HH:mm').format(publication.dateTimeEnd));
    DateTime? pickedDateTime;
    TextEditingController descriptionInput =
        TextEditingController(text: publication.description ?? "");
    if (publication.publisher.id == MyApp.currentUser?.id) {
      toShow = Scrollbar(
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: ListView(
              padding: const EdgeInsets.only(top: 10),
              children: <Widget>[
                ImageCarousel(plants: publication.plants),
                SizedBox(
                  width: 380,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(right: 5),
                              child: const Icon(Icons.location_on)),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "${publication.address.city} (${publication.address.zipCode})",
                                  style: const TextStyle(fontSize: 20)),
                              if (publication.publisher.id ==
                                      MyApp.currentUser!.id ||
                                  (publication.gardenkeeper != null &&
                                      publication.gardenkeeper?.id ==
                                          MyApp.currentUser!.id))
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(publication.address.postalAddress,
                                          style: const TextStyle(fontSize: 20)),
                                      if (publication
                                              .address.otherInformations !=
                                          null)
                                        Text(
                                            publication
                                                .address.otherInformations!,
                                            style:
                                                const TextStyle(fontSize: 20))
                                    ])
                            ],
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: const Icon(Icons.calendar_today)),
                            Column(
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: TextFormField(
                                    controller: dateTimeBeginInput,
                                    readOnly: true,
                                    //set it true, so that user will not able to edit text
                                    onTap: () async {
                                      pickedDateTime =
                                          await DateTimePicker.getDateTime(
                                              context);
                                      if (pickedDateTime != null) {
                                        setState(() {
                                          publication.dateTimeBegin =
                                              pickedDateTime!;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 200,
                                  child: TextFormField(
                                    controller: dateTimeEndInput,
                                    readOnly: true,
                                    //set it true, so that user will not able to edit text
                                    onTap: () async {
                                      pickedDateTime =
                                          await DateTimePicker.getDateTime(
                                              context);
                                      if (pickedDateTime != null) {
                                        setState(() {
                                          publication.dateTimeEnd =
                                              pickedDateTime!;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(children: [
                        Container(
                            margin: const EdgeInsets.only(right: 5),
                            child: const Icon(Icons.emoji_nature)),
                        const Text("Plantes : ",
                            style: TextStyle(fontSize: 20)),
                      ]),
                      SizedBox(
                        height: 200,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black)),
                          margin: const EdgeInsets.only(top: 5, bottom: 5),
                          child: Scrollbar(
                            child: ListView.builder(
                                itemCount: publication.plants.length,
                                itemBuilder: (context, index) {
                                  return ExpansionTile(
                                    title: Text(widget
                                        .map['publication'].plants[index].name),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                                height: 100,
                                                child: Image.memory(widget
                                                    .map['publication']
                                                    .plants[index]
                                                    .picture!
                                                    .data as Uint8List)),
                                            Text(
                                                "Description : ${publication.plants[index].description}"),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                          ),
                        ),
                      ),
                      Row(children: [
                        Container(
                            margin: const EdgeInsets.only(right: 5),
                            child: const Icon(Icons.description)),
                        SizedBox(
                          width: 300,
                          child: TextField(controller: descriptionInput),
                        ),
                      ]),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await ApiPublicationService.update(publication);
                                setState(() {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Annonce modifiée')),
                                  );
                                  context.go(widget.map['originRoute']);
                                });
                              },
                              child: const Text('Enregistrer les modifications',
                                  textAlign: TextAlign.center),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await ApiPublicationService.delete(publication);
                                setState(() {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Annonce supprimée')),
                                  );
                                  context.go(widget.map['originRoute']);
                                });
                              },
                              child: const Text('Supprimer',
                                  textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
        ),
      );
    }
    else {
      toShow = Scrollbar(
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: ListView(children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 10),
                child: ImageCarousel(plants: publication.plants)),
            SizedBox(
              width: 380,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: const Icon(Icons.location_on)),
                      if (publication.gardenkeeper == null ||
                          publication.gardenkeeper != MyApp.currentUser)
                        Text(
                            "${publication.address.city} (${publication.address.zipCode})",
                            style: const TextStyle(fontSize: 20))
                      else
                        Text(
                            "${publication.address.city} (${publication.address.zipCode})\n${publication.address.postalAddress}\n${publication.address.otherInformations}",
                            style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(right: 10),
                            child: const Icon(Icons.calendar_today)),
                        Column(
                          children: [
                            Text(
                                DateFormat('dd-MM-yyyy HH:mm')
                                    .format(publication.dateTimeBegin),
                                style: const TextStyle(fontSize: 20)),
                            Text(
                                DateFormat('dd-MM-yyyy HH:mm')
                                    .format(publication.dateTimeEnd),
                                style: const TextStyle(fontSize: 20)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(children: [
                    Container(
                        margin: const EdgeInsets.only(right: 5),
                        child: const Icon(Icons.emoji_nature)),
                    const Text("Plantes : ", style: TextStyle(fontSize: 20)),
                  ]),
                  SizedBox(
                    height: 200,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black)),
                      margin: const EdgeInsets.only(top: 5, bottom: 10),
                      child: Scrollbar(
                        child: ListView.builder(
                            itemCount: publication.plants.length,
                            itemBuilder: (context, index) {
                              Uint8List? pictureData;
                              if (publication.plants[index].picture != null) {
                                pictureData = publication
                                    .plants[index].picture!.data as Uint8List;
                              }

                              return ExpansionTile(
                                title: Text(widget
                                    .map['publication'].plants[index].name),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                            height: 100,
                                            child: pictureData != null
                                                ? Image.memory(pictureData)
                                                : const Center(
                                                    child: Text(
                                                        "Aucune image trouvée pour cette plante"))),
                                        Text(
                                            "Description : ${publication.plants[index].description}"),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (publication.gardenkeeper != null &&
                publication.gardenkeeper!.id == MyApp.currentUser!.id)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        publication.gardenkeeper = null;
                        await ApiPublicationService.update(publication);
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Désengagement pris en compte')),
                          );
                        });
                      },
                      child: const Text('Me désangager',
                          textAlign: TextAlign.center)),
                  ElevatedButton(
                      onPressed: () {
                        context.push('/report-creation',
                            extra: Map<String, dynamic>.from(
                                {'publication': publication}));
                      },
                      child: const Text('Publier un rapport',
                          textAlign: TextAlign.center))
                ],
              )
            else
              ElevatedButton(
                onPressed: () async {
                  publication.gardenkeeper = MyApp.currentUser;
                  await ApiPublicationService.update(publication);
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Engagement pris en compte')),
                    );
                  });
                },
                child: const Text('Je suis volontaire',
                    textAlign: TextAlign.center),
              ),
          ]),
        ),
      );
    }
    return toShow;
  }
}
