import 'package:flutter/material.dart';

class Publication extends StatelessWidget {
  const Publication({Key? key, required this.image, required this.title})
      : super(key: key);

  final String image;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        margin: const EdgeInsets.only(bottom: 10),
        height: 270,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFE5E5E5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Image.asset(
                image,
                width: MediaQuery.of(context).size.width * 1,
                height: 200,
                fit: BoxFit.cover,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
