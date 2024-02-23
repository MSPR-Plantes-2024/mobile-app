import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mobile_app_arosaje/main.dart';
import 'package:mobile_app_arosaje/services/api_service.dart';

import '../../models/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<bool> isAbleToLogin(String? email, String? password) async {
    if (email == null || password == null) {
      return false;
    }
    List<User>? users = await ApiService.getUsers();
    if (users == null) {
      log("users is null");
      return false;
    }
    for (var key in users) {
      if (key.id == null) {
        log("key.id is null for $key");
        continue;
      }

      User? user = await ApiService.getUser(key.id!);
      log(user!.toString());
      if (user.email == email && user.password == password) {
        setState(() {
          MyApp.currentUser = user;
        });
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 20),
        width: 310,
        child: Form(
            child: Column(
          children: [
            const Text("Connexion",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
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
                    log("${emailController.text} ${passwordController.text}");
                    if (await isAbleToLogin(
                        emailController.text, passwordController.text)) {
                      RestartWidget.restartApp(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Email ou mot de passe incorrect')));
                    }
                  },
                  child: const Text('Connexion')),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'account-creation');
              },
              child: const Text('Créer un compte'),
            ),
          ],
        )),
      ),
    );
  }
}
