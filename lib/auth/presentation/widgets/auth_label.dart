import 'package:flutter/material.dart';

class AuthLabel extends StatelessWidget {
  final String title;
  final String label;
  const AuthLabel({super.key, required this.title, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(
          height: 38,
        ),
      ],
    );
  }
}
