import 'package:flutter/material.dart';
import 'package:mobile_app_arosaje/main.dart';
import 'package:mobile_app_arosaje/services/api_service.dart';
import 'package:mobile_app_arosaje/widgets/attributed_gardenkeeping.dart';
import 'package:mobile_app_arosaje/widgets/user_adresses.dart';

import '../../models/user.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController =
      TextEditingController(text: MyApp.currentUser!.firstName);
  TextEditingController lastNameController =
      TextEditingController(text: MyApp.currentUser!.lastName);
  TextEditingController emailController =
      TextEditingController(text: MyApp.currentUser!.email);

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
          child: const SizedBox(
            height: 390,
            child: AttributedGardenkeeping(),
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
                const ExpansionTile(title: Text('Adresses'), children: [
                  UserAdresses(),
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
                                      const Text('Nom'),
                                      SizedBox(
                                        width: 180,
                                        height: 40,
                                        child: TextFormField(
                                          controller: firstNameController,
                                          // The validator receives the text that the user has entered.
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Veuillez entrer un nom';
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
                                      const Text('Prénom'),
                                      SizedBox(
                                        width: 180,
                                        height: 40,
                                        child: TextFormField(
                                          controller: lastNameController,
                                          // The validator receives the text that the user has entered.
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Veuillez entrer un prénom';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Email'),
                                        SizedBox(
                                          width: 180,
                                          height: 40,
                                          child: TextFormField(
                                            controller: emailController,
                                            // The validator receives the text that the user has entered.
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Veuillez entrer un email';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate()) {
                                    ApiService.updateUser(User(
                                        id: MyApp.currentUser!.id,
                                        firstName: firstNameController.text,
                                        lastName: lastNameController.text,
                                        email: emailController.text,
                                        password: MyApp.currentUser!.password,
                                        userType: MyApp.currentUser!.userType));

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Changements sauvegardés !')),
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
                const ExpansionTile(
                    title: Text('Notifications'),
                    children: [Text("Paramètre 1")]),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      MyApp.currentUser = null;
                    });
                    RestartWidget.restartApp(context);
                  },
                  child: const Text('Me déconnecter'),
                ),
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}
