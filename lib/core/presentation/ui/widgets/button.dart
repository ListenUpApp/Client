import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:listenup/core/presentation/ui/colors.dart';

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
    if (Platform.isIOS) {
      return ConstrainedBox(
        constraints: const BoxConstraints(minWidth: double.infinity),
        child: CupertinoButton(
          borderRadius: BorderRadius.circular(12.0),
          padding: const EdgeInsets.symmetric(
            vertical: 18.0,
          ),
          color: ListenUpColors.primary,
          minSize: 20,
          onPressed: enabled ? onPressed : null,
          child: pending
              ? const CupertinoActivityIndicator(
                  color: ListenUpColors.primary,
                )
              : Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      );
    } else {
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
}
