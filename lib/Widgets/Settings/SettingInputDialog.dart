import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../BlurDialog.dart';

enum SettingInputType { integer, double }

class SettingInputDialog extends StatelessWidget {
  final String text;
  final String subtext;
  final String hintText;
  final String currentText;
  final ValueChanged<String> onChanged;
  final VoidCallback onPressed;
  final SettingInputType inputType;

  const SettingInputDialog({
    Key? key,
    required this.text,
    this.subtext = '',
    this.hintText = '',
    required this.currentText,
    required this.onChanged,
    required this.onPressed,
    this.inputType = SettingInputType.integer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withValues(alpha: 0.5),
      borderRadius: BorderRadius.circular(10.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return BlurDialog(
                    title: Text(text),
                    content: TextField(
                      decoration: InputDecoration(
                        hintText: hintText,
                      ),
                      inputFormatters: [
                        if (inputType == SettingInputType.integer)
                          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                        else
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}')),
                      ],
                      controller: TextEditingController(text: currentText),
                      onChanged: onChanged,
                    ),
                    actions: [
                      TextButton(
                        onPressed: onPressed,
                        child: const Text("确定"),
                      ),
                    ],
                  );
                });
          },
          child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            text,
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          if (subtext.isNotEmpty)
                            Text(
                              subtext,
                              style: TextStyle(
                                  fontSize: 14.0, color: Colors.grey[600]),
                            ),
                        ],
                      )),
                      Container(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: Text(
                          currentText,
                          style: const TextStyle(
                              fontSize: 18.0, color: Colors.grey),
                        ),
                      )
                    ],
                  ))),
        ),
      ),
    );
  }
}
