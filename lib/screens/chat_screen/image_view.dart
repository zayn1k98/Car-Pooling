import 'package:flutter/material.dart';

class ImageView extends StatelessWidget {
  final String imageUrl;
  const ImageView({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.close_rounded,
            color: Colors.grey[700],
          ),
        ),
      ),
      body: Hero(
        tag: 'heroTag',
        child: Center(
          child: Image.network(
            imageUrl,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
