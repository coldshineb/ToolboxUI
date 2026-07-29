import 'package:flutter/material.dart';

class KbdIndicator extends StatelessWidget {
  const KbdIndicator({super.key, required this.kbd});

  final String kbd;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
        ),
        child: Text(kbd));
  }
}
