import 'package:flutter/material.dart';
import 'package:listenup/util/dark_theme.dart';

import '../../../constants/asset_paths.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      decoration: context.isDarkMode
          ? const BoxDecoration(color: Colors.black)
          : const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 0, 0, 0),
                    Color.fromARGB(255, 110, 52, 41),
                    Color.fromARGB(255, 244, 92, 57)
                  ],
                  stops: [
                    0,
                    .5,
                    .9
                  ]),
            ),
      child: const Center(
        child: SizedBox(
          width: 120,
          child: Image(
            image: AssetImage(AssetPaths.whiteTextColorLogo),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
