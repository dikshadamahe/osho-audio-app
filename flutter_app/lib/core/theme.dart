import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colour Palette
  static const Color deepBlack = Color(0xFF0A0F1E);
  static const Color surface = Color(0xFF111827);
  static const Color amberFire = Color(0xFFFF7849);
  static const Color warmIvory = Color(0xFFE2D4C0);
  static const Color mutedTeal = Color(0xFF4A7FA5);
  static const Color glassTint = Color(0x1FFF7849); // Amber @ 12.5%

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: deepBlack,
      colorScheme: const ColorScheme.dark(
        primary: amberFire,
        onPrimary: Colors.white,
        secondary: mutedTeal,
        surface: surface,
        onSurface: warmIvory,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.cormorantGaramond(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
          color: warmIvory,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: warmIvory,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: warmIvory,
        ),
        labelSmall: GoogleFonts.ibmPlexMono(
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
