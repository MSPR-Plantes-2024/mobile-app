import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_arosaje/main.dart';
import 'package:mobile_app_arosaje/services/api_service.dart';

import '../../models/publication.dart';

class HomePage extends StatefulWidget {
  final bool myPublications;
  const HomePage({super.key, required this.myPublications});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    if (widget.myPublications) {
      return const MyPublications();
    } else {
      return const GlobalPublications();
    }
  }
}

class GlobalPublications extends StatefulWidget {
  const GlobalPublications({super.key});

  @override
  State<GlobalPublications> createState() => _GlobalPublicationsState();
}

class _GlobalPublicationsState extends State<GlobalPublications> {
  final Future<List<Publication>> publicationList =
      ApiService.getPublications();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/background.jpg"),
        fit: BoxFit.cover,
      )),
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: FutureBuilder<List<Publication>>(
              future: publicationList,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Publication>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      Uint8List? pictureData;
                      if (snapshot.hasData &&
                          snapshot.data![index].plants.isNotEmpty &&
                          snapshot
                                  .data![index]
                                  .plants[Random().nextInt(
                                      snapshot.data![index].plants.length)]
                                  .picture !=
                              null) {
                        pictureData = snapshot
                            .data![index]
                            .plants[Random()
                                .nextInt(snapshot.data![index].plants.length)]
                            .picture!
                            .data as Uint8List;
                      }
                      return Align(
                        child: GestureDetector(
                          onTap: () {
                            context.push('/details-publication',
                                extra: Map<String, dynamic>.from({
                                  'originRoute': '/',
                                  'publication': snapshot.data![index]
                                }));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            margin: const EdgeInsets.only(bottom: 10),
                            height: 270,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color(0xFFE5E5E5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  pictureData != null
                                      ? Image.memory(
                                          pictureData,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              1,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        )
                                      : const SizedBox(
                                          height: 200,
                                          child: Center(
                                            child: Text(
                                              "Aucune image trouvée pour cette publication",
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      "${snapshot.data![index].address.city} (${snapshot.data![index].address.zipCode})",
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    padding: const EdgeInsets.only(top: 15),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              })),
    );
  }
}

class MyPublications extends StatefulWidget {
  const MyPublications({super.key});

  @override
  State<MyPublications> createState() => _MyPublicationsState();
}

class _MyPublicationsState extends State<MyPublications> {
  final Future<List<Publication>> myPublicationList =
      ApiService.getPublicationsByUser(MyApp.currentUser!);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/background.jpg"),
        fit: BoxFit.cover,
      )),
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: FutureBuilder<List<Publication>>(
              future: myPublicationList,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Publication>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      Uint8List? pictureData;
                      if (snapshot.hasData &&
                          snapshot.data![index].plants.isNotEmpty &&
                          snapshot
                                  .data![index]
                                  .plants[Random().nextInt(
                                      snapshot.data![index].plants.length)]
                                  .picture !=
                              null) {
                        pictureData = snapshot
                            .data![index]
                            .plants[Random()
                                .nextInt(snapshot.data![index].plants.length)]
                            .picture!
                            .data as Uint8List;
                      }
                      return Align(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          margin: const EdgeInsets.only(bottom: 10),
                          height: 270,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFFE5E5E5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                pictureData != null
                                    ? Image.memory(
                                        pictureData,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                1,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      )
                                    : const SizedBox(
                                        height: 200,
                                        child: Center(
                                          child: Text(
                                            "Aucune image trouvée pour cette publication",
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: Text(
                                    "${snapshot.data![index].address.city} (${snapshot.data![index].address.zipCode})",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    padding: const EdgeInsets.only(top: 15),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
    );
  }
}
