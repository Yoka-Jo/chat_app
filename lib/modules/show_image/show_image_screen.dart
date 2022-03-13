import 'package:flutter/material.dart';

class ShowImageScreen extends StatelessWidget {
  final String? photoUrl;
  const ShowImageScreen(
    this.photoUrl, {
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network(
        photoUrl!,
      ),
    );
  }
}
