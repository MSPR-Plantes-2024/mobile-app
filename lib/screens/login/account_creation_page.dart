import 'package:flutter/material.dart';
import 'package:mobile_app_arosaje/main.dart';

import '../../models/User.dart';

class AccountCreationPage extends StatefulWidget {
  const AccountCreationPage({Key? key}) : super(key: key);

  @override
  _AccountCreationPageState createState() => _AccountCreationPageState();
}

class _AccountCreationPageState extends State<AccountCreationPage> {
  List<bool> isSelected = [true, false];

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
                Text("Créer un compte",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Prénom',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Nom',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Téléphone',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                  ),
                ),
                Container(
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
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      MyApp.currentUser = User.getUser();
                      RestartWidget.restartApp(context);
                    });
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
