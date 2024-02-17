import 'dart:ui';

import 'package:flutter/material.dart';

import '../../widgets/publication.dart';

class HomePage extends StatefulWidget {
  const HomePage(bool myPublications, {Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Publication> publicationList = [
    Publication(
      image: "assets/images/01.jpg",
      title: "Titre 1",
    ),
    Publication(
      image: "assets/images/02.jpg",
      title: "Titre 2",
    ),
    Publication(
      image: "assets/images/03.jpg",
      title: "Titre 3",
    ),
    Publication(
      image: "assets/images/04.jpg",
      title: "Titre 4",
    ),
    Publication(
      image: "assets/images/05.jpg",
      title: "Titre 5",
    ),
  ];

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
        child: ListView(
          padding: const EdgeInsets.only(top: 15),
          children: [
            for (Widget publication in publicationList) publication,
          ],
        ),
      ),
    );
  }
}
