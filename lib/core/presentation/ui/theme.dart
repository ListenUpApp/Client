import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listenup/core/presentation/ui/colors.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: ListenUpColors.primary,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: ListenUpColors.primary,
  ),
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.normal,
        fontSize: 24.0,
        height: 3.0,
        color: ListenUpColors.gray70),
    labelSmall: GoogleFonts.poppins(
      fontWeight: FontWeight.normal,
      fontSize: 12.0,
      height: 1.4,
      color: ListenUpColors.gray50,
    ),
    labelMedium: GoogleFonts.poppins(
      fontWeight: FontWeight.normal,
      fontSize: 14.0,
      height: 1.4,
      color: ListenUpColors.gray70,
    ),
    displayMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
        height: 2.4,
        color: ListenUpColors.gray90),
    titleLarge: GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
      fontSize: 28.0,
      height: 3.0,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    floatingLabelStyle: const TextStyle(color: ListenUpColors.primary),
    border: MaterialStateOutlineInputBorder.resolveWith(
      (states) {
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 224, 228, 234),
            width: 1,
          ),
        );
      },
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: ListenUpColors.primary),
    ),
    labelStyle: const TextStyle(
      color: Color.fromARGB(255, 168, 179, 196),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
        // backgroundColor: Color(lightTheme.primaryColor.value),
        minimumSize: const Size(double.infinity, 60),
        backgroundColor: ListenUpColors.primary,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.poppins(
            letterSpacing: 1.0, fontWeight: FontWeight.w600, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
  ),
  cardColor: ListenUpColors.lightCardColor,
  scaffoldBackgroundColor: ListenUpColors.lightCardColor,
);

ThemeData darkTheme = ThemeData(
  cardColor: const Color.fromARGB(255, 17, 17, 17),
  scaffoldBackgroundColor: const Color.fromARGB(255, 6, 6, 6),
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.poppins(
        fontWeight: FontWeight.normal,
        fontSize: 24.0,
        height: 30.0,
        color: ListenUpColors.gray70),
    labelSmall: GoogleFonts.poppins(
      fontWeight: FontWeight.normal,
      fontSize: 12.0,
      height: 14.0,
      color: ListenUpColors.gray50,
    ),
    labelMedium: GoogleFonts.poppins(
      fontWeight: FontWeight.normal,
      fontSize: 14.0,
      height: 14.0,
      color: ListenUpColors.gray70,
    ),
    displayMedium: GoogleFonts.poppins(
        fontWeight: FontWeight.normal,
        fontSize: 16.0,
        height: 24.0,
        color: ListenUpColors.gray90),
    titleLarge: GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
      fontSize: 28.0,
      height: 30.0,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: const Color.fromARGB(255, 26, 26, 26),
    filled: true,
    border: MaterialStateOutlineInputBorder.resolveWith(
      (states) {
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 94, 94, 94),
            width: 1,
          ),
        );
      },
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(
        color: ListenUpColors.primary,
      ),
    ),
    labelStyle: const TextStyle(
      color: Color.fromARGB(255, 168, 179, 196),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
        // backgroundColor: Color(lightTheme.primaryColor.value),
        minimumSize: const Size(double.infinity, 60),
        backgroundColor: ListenUpColors.primary,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.poppins(
            letterSpacing: 1.0, fontWeight: FontWeight.w600, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
  ),
);
