import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_arosaje/main.dart';
import 'package:mobile_app_arosaje/services/api_service.dart';

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
    } else {
      await ApiService.login(email.trim(), password.trim());
      if (MyApp.currentUser != null) {
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
                    if (await isAbleToLogin(
                        emailController.text, passwordController.text)) {
                      log("User connected");
                      RestartWidget.restartApp(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Email ou mot de passe incorrect')));
                    }
                  },
                  child: const Text('Connexion')),
            ),
            TextButton(
              onPressed: () {
                context.go('account-creation');
              },
              child: const Text('Créer un compte'),
            ),
          ],
        )),
      ),
    );
  }
}
