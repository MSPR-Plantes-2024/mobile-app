import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

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
  final List<Publication> publicationList = Publication.getPublications();

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
        child: ListView.builder(
          itemCount: publicationList.length,
          itemBuilder: (BuildContext context, int index) {
            return Align(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/details-publication',
                      arguments: {'publication' : publicationList[index]});
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
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Image.asset(
                          publicationList[index]
                              .plants[Random()
                                  .nextInt(publicationList[index].plants.length)]
                              .picture!
                              .url,
                          width: MediaQuery.of(context).size.width * 1,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Text(
                            "${publicationList[index].address.city} (${publicationList[index].address.zipCode})",
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
        ),
      ),
    );
  }
}

class MyPublications extends StatefulWidget {
  const MyPublications({super.key});

  @override
  State<MyPublications> createState() => _MyPublicationsState();
}

class _MyPublicationsState extends State<MyPublications> {
  final List<Publication> myPublicationList = Publication.getPublications();

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
        child: ListView.builder(
          itemCount: myPublicationList.length,
          itemBuilder: (BuildContext context, int index) {
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
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFE5E5E5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Image.asset(
                        myPublicationList[index]
                            .plants[Random().nextInt(
                                myPublicationList[index].plants.length)]
                            .picture!
                            .url,
                        width: MediaQuery.of(context).size.width * 1,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: Text(
                          "${myPublicationList[index].address.city} (${myPublicationList[index].address.zipCode})",
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
        ),
      ),
    );
  }
}
