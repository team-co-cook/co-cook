import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerButton extends StatefulWidget {
  const ImagePickerButton({Key? key}) : super(key: key);

  @override
  _ImagePickerButtonState createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  File? _image;

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ImageSource>(
      itemBuilder: (BuildContext context) => <PopupMenuEntry<ImageSource>>[
        const PopupMenuItem(
          child: Text('From Gallery'),
          value: ImageSource.gallery,
        ),
        const PopupMenuItem(
          child: Text('From Camera'),
          value: ImageSource.camera,
        ),
      ],
      onSelected: _getImage,
      icon: const Icon(Icons.add_a_photo),
    );
  }
}
