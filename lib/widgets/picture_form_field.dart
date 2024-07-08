import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PictureFormField extends StatefulWidget {
  final File? picture;
  final Function(File?) onPictureChanged;

  const PictureFormField({super.key, required this.picture, required this.onPictureChanged});

  @override
  _PictureFormFieldState createState() => _PictureFormFieldState();
}

class _PictureFormFieldState extends State<PictureFormField> {
  final _picker = ImagePicker();

  Future<File?> _openImagePicker(ImageSource source) async {
    final XFile? pickedImage = await _picker.pickImage(source: source);
    return (pickedImage == null ? null : File(pickedImage.path));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.add_a_photo_outlined),
                onPressed: () {
                  _openImagePicker(ImageSource.camera).then((pickedFile) {
                    setState(() {
                      widget.onPictureChanged(pickedFile);
                    });
                  });
                },
              ),
              IconButton(
                icon: const Icon(Icons.folder_outlined),
                onPressed: () {
                  _openImagePicker(ImageSource.gallery).then((pickedFile) {
                    setState(() {
                      widget.onPictureChanged(pickedFile);
                    });
                  });
                },
              ),
            ],
          ),
        ),
        Icon((widget.picture == null ? Icons.close : Icons.check),
            color: (widget.picture == null ? Colors.red : Colors.green)
    ),
      ],
    );
  }
}