import 'package:flutter/material.dart';

class AttributedGardenkeeping extends StatefulWidget {
  const AttributedGardenkeeping({super.key});

  @override
  _AttributedGardenkeepingState createState() =>
      _AttributedGardenkeepingState();
}

class _AttributedGardenkeepingState extends State<AttributedGardenkeeping> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, '/gardenkeeping');
      },
      title: const Text("Gardiennage 1"),
      subtitle: const Text("Adresse 1"),
      leading: const Icon(Icons.nature_outlined),
      trailing: const Icon(Icons.edit_outlined),
    );
  }
}
