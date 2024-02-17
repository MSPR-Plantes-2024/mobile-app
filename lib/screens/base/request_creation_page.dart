import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RequestCreationPage extends StatefulWidget {
  const RequestCreationPage({Key? key}) : super(key: key);

  @override
  _RequestCreationPageState createState() => _RequestCreationPageState();
}

class _RequestCreationPageState extends State<RequestCreationPage> {
  Object? selectedValue = null;
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> flowerList = [
    {"title": "Item 1", "isChecked": false},
    {"title": "Item 2", "isChecked": false},
    {"title": "Item 3", "isChecked": false},
    {"title": "Item 4", "isChecked": false},
    {"title": "Item 5", "isChecked": false},
  ];
  List<Map<String, dynamic>> addresses = [
    {"title": "Adresse 1"},
    {"title": "Adresse 2"},
    {"title": "Adresse 3"},
  ];

  TextEditingController dateTimeInput = TextEditingController();
  TextEditingController addFlowerInput = TextEditingController();
  TextEditingController addAdressInput = TextEditingController();

  @override
  void initState() {
    dateTimeInput.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Center(
          child: Container(
            width: 300,
            padding: const EdgeInsets.only(top: 20),
            child: Column(children: [
              const Text("Création d'une\ndemande",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Titre'),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Entrez un titre.';
                            }
                            return null;
                          },
                        ),
                        Text('Adresse'),
                        Row(
                          children: [
                            SizedBox(
                              width: 250,
                              child: DropdownButtonFormField(
                                validator: (value) => value == null
                                    ? "Sélectionnez une adresse."
                                    : null,
                                value: selectedValue,
                                items: [
                                  for (Map<String, dynamic> item in addresses)
                                    DropdownMenuItem(
                                      value: item["title"],
                                      child: Text(item["title"]),
                                    ),
                                ],
                                onChanged: (Object? newValue) {
                                  setState(() {
                                    selectedValue = newValue!;
                                  });
                                },
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title:
                                              const Text('Ajouter une adresse'),
                                          content: TextField(
                                            controller: addAdressInput,
                                            decoration: const InputDecoration(
                                                labelText: 'Adresse'),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  addAdressInput.clear();
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Annuler')),
                                            TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    addresses.add({
                                                      "title":
                                                          addAdressInput.text
                                                    });
                                                    selectedValue =
                                                        addAdressInput.text;
                                                  });
                                                  addAdressInput.clear();
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Ajouter')),
                                          ],
                                        );
                                      });
                                },
                                icon: const Icon(Icons.add)),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Plantes'),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.black, width: 1)),
                                    height: 200,
                                    width: 250,
                                    child: Scrollbar(
                                      child: ListView.builder(
                                        itemCount: flowerList.length,
                                        itemBuilder: (context, index) =>
                                            CheckboxListTile(
                                          value: flowerList[index]["isChecked"],
                                          onChanged: (value) {
                                            setState(() {
                                              flowerList[index]["isChecked"] =
                                                  value!;
                                            });
                                          },
                                          title: Text(
                                            flowerList[index]["title"],
                                            style: const TextStyle(
                                                color: Colors.black87),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text('Ajouter'),
                                                  content: TextField(
                                                    controller: addFlowerInput,
                                                    decoration:
                                                        const InputDecoration(
                                                            labelText: 'Nom'),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          addFlowerInput
                                                              .clear();
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            'Annuler')),
                                                    TextButton(
                                                        onPressed: () {
                                                          if (addFlowerInput
                                                                  .text.length >
                                                              0) {
                                                            setState(() {
                                                              flowerList.add({
                                                                "title":
                                                                    addFlowerInput
                                                                        .text,
                                                                "isChecked":
                                                                    true
                                                              });
                                                            });
                                                            addFlowerInput
                                                                .clear();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          }
                                                          ;
                                                        },
                                                        child: const Text(
                                                            'Ajouter')),
                                                  ],
                                                );
                                              });
                                        },
                                        icon: const Icon(Icons.add)),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text('Date et heure'),
                        TextFormField(
                          controller: dateTimeInput,
                          //editing controller of this TextField
                          decoration: InputDecoration(
                              icon: Icon(
                                  Icons.calendar_today), //icon of text field
                              labelText: DateFormat('dd-MM-yyyy HH:mm').format(
                                  DateTime.now().add(
                                      Duration(hours: 1))) //label text of field
                              ),
                          readOnly: true,
                          //set it true, so that user will not able to edit text
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime.now().add(Duration(days: 30)),
                            );
                            TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now().hour + 1 < 21 &&
                                      TimeOfDay.now().hour + 1 > 8
                                  ? TimeOfDay.now()
                                      .replacing(hour: TimeOfDay.now().hour + 1)
                                  : TimeOfDay(hour: 8, minute: 0),
                            );

                            if (pickedDate != null) {
                              print(
                                  pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(pickedDate);
                              print(
                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                              setState(() {
                                dateTimeInput.text =
                                    formattedDate; //set output date to TextField value.
                              });
                              if (pickedTime != null) {
                                print(pickedTime);
                                dateTimeInput.text =
                                    "${dateTimeInput.text} ${pickedTime.format(context)}";
                              }
                            }
                          },
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ElevatedButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Processing Data')),
                                  );
                                }
                              },
                              child: const Text('Créer',
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        ),
                      ]))
            ]),
          ),
        ),
      ],
    );
  }
}
