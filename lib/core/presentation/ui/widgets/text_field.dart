import 'package:flutter/material.dart';

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
