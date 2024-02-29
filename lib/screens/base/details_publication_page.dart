import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_arosaje/services/api_service.dart';

import '../../main.dart';
import '../../models/publication.dart';
import '../../widgets/date_time_picker.dart';
import '../../widgets/image_carousel.dart';

class DetailsPublicationPage extends StatefulWidget {
  final String originRoute;
  final Publication publication;
  const DetailsPublicationPage(
      {super.key, required this.originRoute, required this.publication});

  @override
  _DetailsPublicationPageState createState() => _DetailsPublicationPageState();
}

class _DetailsPublicationPageState extends State<DetailsPublicationPage> {
  @override
  Widget build(BuildContext context) {
    final Widget toShow;
    TextEditingController dateTimeInput = TextEditingController(
        text: DateFormat('dd-MM-yyyy HH:mm').format(widget.publication.date));
    DateTime? pickedDateTime;
    TextEditingController descriptionInput =
        TextEditingController(text: widget.publication.description ?? "");

    if (widget.publication.publisher.id == MyApp.currentUser?.id) {
      toShow = Scrollbar(
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: ListView(
              padding: const EdgeInsets.only(top: 10),
              children: <Widget>[
                ImageCarousel(plants: widget.publication.plants),
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
                                  "${widget.publication.address.city} (${widget.publication.address.zipCode})",
                                  style: const TextStyle(fontSize: 20)),
                              if (widget.publication.publisher.id ==
                                      MyApp.currentUser!.id ||
                                  (widget.publication.gardenkeeper != null &&
                                      widget.publication.gardenkeeper?.id ==
                                          MyApp.currentUser!.id))
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          widget.publication.address
                                              .postalAddress,
                                          style: const TextStyle(fontSize: 20)),
                                      if (widget.publication.address
                                              .otherInformations !=
                                          null)
                                        Text(
                                            widget.publication.address
                                                .otherInformations!,
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
                            SizedBox(
                              width: 200,
                              child: TextFormField(
                                controller: dateTimeInput,
                                readOnly: true,
                                //set it true, so that user will not able to edit text
                                onTap: () async {
                                  pickedDateTime =
                                      await DateTimePicker.getDateTime(context);
                                  if (pickedDateTime != null) {
                                    setState(() {
                                      widget.publication.date = pickedDateTime!;
                                    });
                                  }
                                },
                              ),
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
                                itemCount: widget.publication.plants.length,
                                itemBuilder: (context, index) {
                                  return ExpansionTile(
                                    title: Text(
                                        widget.publication.plants[index].name),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                                height: 100,
                                                child: Image.memory(widget
                                                    .publication
                                                    .plants[index]
                                                    .picture!
                                                    .data as Uint8List)),
                                            Text(
                                                "Description : ${widget.publication.plants[index].description}"),
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
                              onPressed: () {
                                setState(() {
                                  context.go(widget.originRoute);
                                });
                              },
                              child: const Text('Enregistrer les modifications',
                                  textAlign: TextAlign.center),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  context.go(widget.originRoute);
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
    } else {
      toShow = Scrollbar(
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: ListView(children: <Widget>[
            Container(
                margin: const EdgeInsets.only(top: 10),
                child: ImageCarousel(plants: widget.publication.plants)),
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
                      if (widget.publication.gardenkeeper == null ||
                          widget.publication.gardenkeeper != MyApp.currentUser)
                        Text(
                            "${widget.publication.address.city} (${widget.publication.address.zipCode})",
                            style: const TextStyle(fontSize: 20))
                      else
                        Text(
                            "${widget.publication.address.city} (${widget.publication.address.zipCode})\n${widget.publication.address.postalAddress}\n${widget.publication.address.otherInformations}",
                            style: const TextStyle(fontSize: 20)),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      children: [
                        Container(
                            margin: const EdgeInsets.only(right: 5),
                            child: const Icon(Icons.calendar_today)),
                        Text(
                            DateFormat('dd-MM-yyyy HH:mm')
                                .format(widget.publication.date),
                            style: const TextStyle(fontSize: 20)),
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
                            itemCount: widget.publication.plants.length,
                            itemBuilder: (context, index) {
                              Uint8List? pictureData;
                              if (widget.publication.plants[index].picture !=
                                  null) {
                                pictureData = widget.publication.plants[index]
                                    .picture!.data as Uint8List;
                              }

                              return ExpansionTile(
                                title:
                                    Text(widget.publication.plants[index].name),
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
                                            "Description : ${widget.publication.plants[index].description}"),
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
            if (widget.publication.gardenkeeper != null &&
                widget.publication.gardenkeeper == MyApp.currentUser)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          widget.publication.gardenkeeper = null;
                          ApiService.updatePublication(widget.publication);
                        });
                      },
                      child: const Text('Me désangager',
                          textAlign: TextAlign.center)),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Text('Publier un rapport',
                          textAlign: TextAlign.center))
                ],
              )
            else
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.publication.gardenkeeper = MyApp.currentUser;
                    log(widget.publication.gardenkeeper!.toString());
                    ApiService.updatePublication(widget.publication);
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
