import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_app_arosaje/main.dart';
import 'package:mobile_app_arosaje/services/api_auth_service.dart';
import 'package:mobile_app_arosaje/services/api_user_service.dart';
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
  final _passwordVerificationFormKey = GlobalKey<FormState>();
  User currentUser = User.getCurrent();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordVerificationController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    firstNameController.text =
        currentUser.firstName;
    lastNameController.text =
        currentUser.lastName;
    emailController.text =
        currentUser.email!;
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
                const ExpansionTile(
                    title: Text('Adresses et plantes'),
                    children: [
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
                                onPressed: () async {
                                  // Validate returns true if the form is valid, or false otherwise.
                                  if (_formKey.currentState!.validate()) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text(
                                                'Vérification de mot de passe'),
                                            content: Form(
                                              key: _passwordVerificationFormKey,
                                              child: Column(
                                                children: [
                                                  const Text(
                                                      'Veuillez entrer votre mot de passe pour confirmer les changements'),
                                                  TextFormField(
                                                    controller:
                                                        passwordVerificationController,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Veuillez entrer votre mot de passe';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Annuler'),
                                              ),
                                              TextButton(
                                                onPressed: () async {
                                                  if (_passwordVerificationFormKey
                                                      .currentState!
                                                      .validate()) {
                                                    if (await ApiAuthService.login(
                                                        currentUser
                                                            .email!,
                                                        passwordVerificationController
                                                            .text)) {
                                                      await ApiUserService.update(User(
                                                          id: currentUser.id,
                                                          firstName:
                                                              firstNameController
                                                                  .text,
                                                          lastName:
                                                              lastNameController
                                                                  .text,
                                                          email: emailController
                                                              .text,
                                                          password:
                                                              passwordVerificationController
                                                                  .text,
                                                          userType: currentUser
                                                              .userType));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'Changements sauvegardés !')),
                                                      );
                                                      Navigator.of(context)
                                                          .pop();
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'Mot de passe incorrect')),
                                                      );
                                                    }
                                                  }
                                                },
                                                child: const Text('Confirmer'),
                                              ),
                                            ],
                                          );
                                        });
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
                      User.removeCurrent();
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
