import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_app_arosaje/main.dart';
import 'package:mobile_app_arosaje/services/api_auth_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
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
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                    onPressed: () async {
                      User currentUser = User(
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          userType: "USER");
                      if (await ApiAuthService.logon(currentUser)) {
                        log("Account created");
                        RestartWidget.restartApp(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Erreur de création d\'utilisateur')));
                      }
                    },
                    child: const Text('Créer un compte'),
                  ),
                ),
              ],
            )),
          ),
        ),
      ],
    );
  }
}
