import 'package:flutter/material.dart';
import 'package:toolbox_core/ToolboxCore.dart';
import 'package:toolbox_ui/ToolboxUI.dart';

class PreferenceSwitchItem extends StatelessWidget {
  final PreferenceItem<bool> item;
  final String text;
  final String subtext;

  const PreferenceSwitchItem({
    super.key,
    required this.item,
    required this.text,
    this.subtext = '',
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: item,
      builder: (context, value, child) {
        return SettingSwitchItem(
          onTap: () {
            item.value = !item.value;
          },
          text: text,
          subtext: subtext,
          value: value,
          onChanged: (bool newValue) {
            item.value = newValue;
          },
        );
      },
    );
  }
}

class PreferenceInputItem extends StatefulWidget {
  final PreferenceItem<int> item;
  final String text;
  final String subtext;
  final String hintText;

  const PreferenceInputItem({
    super.key,
    required this.item,
    required this.text,
    this.subtext = '',
    this.hintText = '',
  });

  @override
  State<PreferenceInputItem> createState() => _PreferenceInputItemState();
}

class _PreferenceInputItemState extends State<PreferenceInputItem> {
  late String _tempValue;

  @override
  void initState() {
    super.initState();
    _tempValue = widget.item.value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: widget.item,
      builder: (context, value, child) {
        return SettingInputDialog(
          text: widget.text,
          subtext: widget.subtext,
          currentText: value.toString(),
          hintText: widget.hintText,
          inputType: SettingInputType.integer,
          onChanged: (String val) {
            _tempValue = val;
          },
          onPressed: () {
            if (_tempValue.isEmpty) {
              widget.item.value = widget.item.defaultValue;
            } else {
              int? parsed = int.tryParse(_tempValue);
              if (parsed != null) {
                widget.item.value = parsed;
              }
            }
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class PreferenceDoubleInputItem extends StatefulWidget {
  final PreferenceItem<double> item;
  final String text;
  final String subtext;
  final String hintText;

  const PreferenceDoubleInputItem({
    super.key,
    required this.item,
    required this.text,
    this.subtext = '',
    this.hintText = '',
  });

  @override
  State<PreferenceDoubleInputItem> createState() =>
      _PreferenceDoubleInputItemState();
}

class _PreferenceDoubleInputItemState extends State<PreferenceDoubleInputItem> {
  late String _tempValue;

  @override
  void initState() {
    super.initState();
    _tempValue = widget.item.value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: widget.item,
      builder: (context, value, child) {
        return SettingInputDialog(
          text: widget.text,
          subtext: widget.subtext,
          currentText: value.toString(),
          hintText: widget.hintText,
          inputType: SettingInputType.double,
          onChanged: (String val) {
            _tempValue = val;
          },
          onPressed: () {
            if (_tempValue.isEmpty) {
              widget.item.value = widget.item.defaultValue;
            } else {
              double? parsed = double.tryParse(_tempValue);
              if (parsed != null) {
                widget.item.value = parsed;
              }
            }
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
