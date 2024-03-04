import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mobile_app_arosaje/main.dart';
import 'package:mobile_app_arosaje/services/api_service.dart';

import '../../models/user.dart';

class AccountCreationPage extends StatefulWidget {
  const AccountCreationPage({super.key});

  @override
  _AccountCreationPageState createState() => _AccountCreationPageState();
}

class _AccountCreationPageState extends State<AccountCreationPage> {

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  // List<bool> isSelected = [true, false];

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.only(top: 20),
            width: 310,
            child: Form(
                child: Column(
              children: [
                const Text("Créer un compte",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                TextFormField(
                  controller: firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'Prénom',
                  ),
                ),
                TextFormField(
                  controller: lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                  ),
                ),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                  ),
                ),
                /*Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 20),
                  child: ToggleButtons(
                      onPressed: (int index) {
                        setState(() {
                          isSelected = [false, false];
                          isSelected[index] = true;
                        });
                      },
                      isSelected: isSelected,
                      children: const [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Particulier'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Professionnel'),
                        )
                      ]),
                ),*/
                ElevatedButton(
                  onPressed: () async {
                      User currentUser = User(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          userType: "USER");
                      log(currentUser.toString());
                      ApiService.createUser(currentUser);
                      setState(() {
                        MyApp.currentUser = currentUser;
                      });
                      RestartWidget.restartApp(context);
                  },
                  child: const Text('Créer un compte'),
                ),
              ],
            )),
          ),
        ),
      ],
    );
  }
}
