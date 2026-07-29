import 'package:flutter/material.dart';
import 'package:toolbox_ui/ToolboxUI.dart';

class BlurMenuItemButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData? icon;
  final String text;
  final String? shortcutKbd;
  final double height;

  const BlurMenuItemButton({
    super.key,
    required this.onPressed,
    this.icon,
    required this.text,
    this.shortcutKbd,
    this.height = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: MenuItemButton(
        onPressed: onPressed,
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon),
              const SizedBox(width: 5),
            ],
            Text(text),
            if (shortcutKbd != null) ...[
              const SizedBox(width: 5),
              KbdIndicator(kbd: shortcutKbd!),
            ]
          ],
        ),
      ),
    );
  }
}
