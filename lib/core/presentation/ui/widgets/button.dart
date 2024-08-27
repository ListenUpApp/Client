import 'package:flutter/material.dart';

class ListenupButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool enabled;
  final bool pending;
  const ListenupButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.enabled,
      required this.pending});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: enabled ? onPressed : null,
      child: pending
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : Text(
              text,
            ),
    );
  }
}
