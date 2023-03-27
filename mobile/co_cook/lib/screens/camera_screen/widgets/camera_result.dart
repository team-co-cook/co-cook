import 'dart:io';

import 'package:flutter/material.dart';

class CameraResult extends StatefulWidget {
  const CameraResult({super.key, required this.imgPath});
  final String imgPath;

  @override
  State<CameraResult> createState() => _CameraResultState();
}

class _CameraResultState extends State<CameraResult> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.file(
          File(widget.imgPath),
          fit: BoxFit.cover,
        ));
  }
}
