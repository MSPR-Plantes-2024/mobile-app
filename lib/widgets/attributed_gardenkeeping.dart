import 'package:flutter/material.dart';

class AttributedGardenkeeping extends StatefulWidget {
  const AttributedGardenkeeping({super.key});

  @override
  _AttributedGardenkeepingState createState() =>
      _AttributedGardenkeepingState();
}

class _AttributedGardenkeepingState extends State<AttributedGardenkeeping> {
  List<String> gardenkeepings = [
    "Adresse 1",
    "Adresse 2",
    "Adresse 3",
  ];
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: gardenkeepings.length,
      itemBuilder: (context, index) {
        return ListTile(
            title: Text("Gardiennage ${index + 1}"),
            subtitle: Text(gardenkeepings[index]),
            leading: const Icon(Icons.nature_outlined),
            trailing: IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Me désangager"),
                          content: const Text(
                              "Voulez-vous vraiment vous désangager de ce gardiennage ?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("Annuler")),
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    gardenkeepings.removeAt(index);
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text("Supprimer")),
                          ],
                        );
                      });
                },
                icon: Icon(Icons.delete_outline)));
      },
    );
  }
}
