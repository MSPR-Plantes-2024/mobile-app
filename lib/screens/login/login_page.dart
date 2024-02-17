import 'package:flutter/material.dart';
import 'package:mobile_app_arosaje/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 20),
        width: 310,
        child: Form(
            child: Column(
          children: [
            Text("Connexion",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    MyApp.logged = true;
                  });
                  RestartWidget.restartApp(context);
                },
                child: const Text('Connexion'),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, 'account-creation');
              },
              child: Text('Créer un compte'),
            ),
          ],
        )),
      ),
    );
  }
}
