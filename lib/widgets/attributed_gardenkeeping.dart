import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app_arosaje/models/publication.dart';
import 'package:mobile_app_arosaje/models/user.dart';
import 'package:mobile_app_arosaje/services/api_publication_service.dart';

import '../main.dart';

class AttributedGardenkeeping extends StatefulWidget {
  const AttributedGardenkeeping({super.key});

  @override
  _AttributedGardenkeepingState createState() =>
      _AttributedGardenkeepingState();
}

class _AttributedGardenkeepingState extends State<AttributedGardenkeeping> {
  Future<List<Publication>> gardenkeepings = ApiPublicationService.getAll().then(
      (value) => value
          .where((element) =>
              element.gardenkeeper != null &&
                  User.isCurrent(element.gardenkeeper!))
          .toList());
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Publication>>(
        future: gardenkeepings,
        builder:
            (BuildContext context, AsyncSnapshot<List<Publication>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(
                        "Gardiennage à ${snapshot.data![index].address.city}"),
                    subtitle: Text(snapshot.data![index].dateTimeBegin.toString()),
                    leading: const Icon(Icons.nature_outlined),
                    trailing: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                context.push('/report-creation',
                                    extra: Map<String, dynamic>.from(({
                                      'publication': snapshot.data![index]
                                    })));
                              },
                              icon: const Icon(Icons.note_add_outlined)),
                          IconButton(
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
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Annuler")),
                                          TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  snapshot.data![index]
                                                      .gardenkeeper = null;
                                                  ApiPublicationService.update(
                                                      snapshot.data![index]);
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Supprimer")),
                                        ],
                                      );
                                    });
                              },
                              icon: const Icon(Icons.delete_outline)),
                        ],
                      ),
                    ));
              },
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          // By default, show a loading spinner.
          return const SizedBox(
              height: 50, width: 50, child: CircularProgressIndicator());
        });
  }
}
