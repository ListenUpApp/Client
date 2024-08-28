import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listenup/core/presentation/ui/colors.dart';
import 'package:listenup/util/dark_theme.dart';

class ListenUpTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool obscureText;
  final String? placeholder;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onTextChanged;

  const ListenUpTextField(
      {super.key,
      required this.controller,
      required this.label,
      this.obscureText = false,
      this.placeholder,
      this.onTextChanged,
      this.keyboardType});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(
            height: 10,
          ),
          CupertinoTextField(
              controller: controller,
              onChanged: onTextChanged,
              obscureText: obscureText,
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              keyboardType: keyboardType ?? TextInputType.text,
              placeholder: placeholder ?? label,
              placeholderStyle: context.isDarkMode
                  ? const TextStyle(color: Colors.white30)
                  : const TextStyle(color: ListenUpColors.gray40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: context.isDarkMode
                    ? ListenUpColors.darkTextFieldBackground
                    : Colors.white,
                border: Border.all(
                  color: context.isDarkMode
                      ? Colors.white24
                      : ListenUpColors.lightBorderOutline,
                  width: 1,
                ),
              ))
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: controller,
            onChanged: onTextChanged,
            obscureText: obscureText,
            keyboardType: keyboardType ?? TextInputType.text,
            decoration: InputDecoration(
              label: Text(placeholder ?? label),
            ),
          ),
        ],
      );
    }
  }
}
