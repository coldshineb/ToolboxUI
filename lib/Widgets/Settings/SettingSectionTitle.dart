import 'package:flutter/material.dart';

class SettingSectionTitle extends StatelessWidget {
  final String text;
  const SettingSectionTitle({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 24.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
