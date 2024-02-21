import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

MaterialColor kPrimaryColor = MaterialColor(0xFFFFEB3B, <int, Color>{
  50: Color(0xFFFFF8E1),
  100: Color(0xFFFFF59D),
  200: Color(0xFFFFF176),
  300: Color(0xFFFFEE58),
  400: Color(0xFFFFEB3B),
  500: Color(0xE6FFE200), // Color for 500
  600: Color(0xFFFFE600),
  700: Color(0xFFFFE100),
  800: Color(0xFFFFDA00),
  900: Color(0xFFFFD600),
});

class TAppTheme {
  static ThemeData lightTheme = ThemeData(
      useMaterial3: false,
      brightness: Brightness.light,
      primarySwatch: kPrimaryColor,
      textTheme: TextTheme(
        headlineMedium: GoogleFonts.roboto(color: Colors.black, fontSize: 20),
        headlineSmall: GoogleFonts.montserrat(
            color: const Color.fromARGB(255, 208, 16, 16), fontSize: 20),
      ));

  static ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    brightness: Brightness.dark,
  );
}
