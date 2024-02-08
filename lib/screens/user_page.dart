import 'package:flutter/material.dart';
import 'package:mobile_app_arosaje/widgets/user_adresses.dart';

import '../widgets/attributed_gardenkeeping.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _formKey = GlobalKey<FormState>();

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
                AttributedGardenkeeping(),
                AttributedGardenkeeping(),
                AttributedGardenkeeping(),
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
                ExpansionTile(title: const Text('Adresses'), children: [
                  SizedBox(height: 200, child: UserAdresses()),
                ]),
                ExpansionTile(
                    title: const Text('Informations personnelles'),
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Nom'),
                                      SizedBox(
                                        width: 180,
                                        height: 40,
                                        child: TextFormField(
                                          // The validator receives the text that the user has entered.
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Prénom'),
                                      SizedBox(
                                        width: 180,
                                        height: 40,
                                        child: TextFormField(
                                          // The validator receives the text that the user has entered.
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Email'),
                                      SizedBox(
                                        width: 180,
                                        height: 40,
                                        child: TextFormField(
                                          // The validator receives the text that the user has entered.
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Téléphone'),
                                      SizedBox(
                                        width: 180,
                                        height: 40,
                                        child: TextFormField(
                                          // The validator receives the text that the user has entered.
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Processing Data')),
                                    );
                                  }
                                },
                                child: const Text(
                                    'Sauvegarder les\nchangements',
                                    textAlign: TextAlign.center),
                              ),
                            ),
                          ],
                        ),
                      )
                    ]),
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
