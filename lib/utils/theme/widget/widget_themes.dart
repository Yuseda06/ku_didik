import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    headlineMedium: GoogleFonts.roboto(color: Colors.black87),
    headlineSmall: GoogleFonts.montserrat(color: Colors.black54, fontSize: 20),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineMedium: GoogleFonts.roboto(color: Colors.white70),
    headlineSmall: GoogleFonts.montserrat(color: Colors.white60, fontSize: 20),
  );
}
