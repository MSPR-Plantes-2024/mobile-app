import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Column(children: [
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: const Text("Vos gardiennages",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        Container(
          decoration: const BoxDecoration(
            border: BorderDirectional(
                top: BorderSide(color: Colors.black, width: 1)),
          ),
          child: SizedBox(
            height: 390,
            child: ListView(
              children: const [
                ListTile(
                  title: Text("Gardiennage 1"),
                  subtitle: Text("Adresse 1"),
                ),
                ListTile(
                  title: Text("Gardiennage 2"),
                  subtitle: Text("Adresse 2"),
                ),
                ListTile(
                  title: Text("Gardiennage 3"),
                  subtitle: Text("Adresse 3"),
                ),
              ],
            ),
          ),
        ),
      ]),
      Column(
        children: [
          const Text("Paramètres",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Container(
            decoration: const BoxDecoration(
              border: BorderDirectional(
                  top: BorderSide(color: Colors.black, width: 1)),
            ),
            child: Column(
              children: [
                ExpansionTile(
                    title: const Text('Adresses'),
                    children: const [Text("Adresse 1")]),
                ExpansionTile(
                    title: const Text('Informations personnelles'),
                    children: const [Text("Paramètre 1")]),
                ExpansionTile(
                    title: const Text('Notifications'),
                    children: const [Text("Paramètre 1")]),
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}
