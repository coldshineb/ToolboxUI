import 'package:flutter/material.dart';

class SettingSwitchItem extends StatelessWidget {
  final String text;
  final String subtext;
  final bool value;
  final ValueChanged<bool> onChanged;
  final GestureTapCallback? onTap;

  const SettingSwitchItem({
    Key? key,
    required this.text,
    this.subtext = '',
    required this.value,
    required this.onChanged,
    this.onTap,
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
            onTap: onTap,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Container(
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
                    Switch(
                      value: value,
                      onChanged: onChanged,
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
