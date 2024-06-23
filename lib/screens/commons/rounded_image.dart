import 'dart:typed_data';

import 'package:flutter/material.dart';

class RoundedImage extends StatelessWidget {
  final Uint8List bytes;
  final String imagePath;
  final Size size;


  const RoundedImage({
    Key key,
    @required this.imagePath,
    this.bytes,
    this.size = const Size.fromWidth(120),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.memory(
        bytes,
        width: size.width,
        height: size.width,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}