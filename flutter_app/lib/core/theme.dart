import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color deepBlack = Color(0xFF0A0F1E);
  static const Color surface = Color(0xFF111827);
  static const Color amberFire = Color(0xFFFF7849);
  static const Color warmIvory = Color(0xFFE2D4C0);
  static const Color mutedTeal = Color(0xFF4A7FA5);
  static const Color glassWhite = Color(0x33FFFFFF);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: deepBlack,
      primaryColor: amberFire,
      
      colorScheme: const ColorScheme.dark(
        primary: amberFire,
        onPrimary: Colors.white,
        secondary: mutedTeal,
        onSecondary: Colors.white,
        surface: surface,
        onSurface: warmIvory,
        background: deepBlack,
        onBackground: warmIvory,
      ),

      textTheme: TextTheme(
        displayLarge: GoogleFonts.cormorantGaramond(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
          color: warmIvory,
        ),
        titleLarge: GoogleFonts.plusJakartaSans(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: warmIvory,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: warmIvory,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: warmIvory.withOpacity(0.8),
        ),
        labelSmall: GoogleFonts.ibmPlexMono(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          color: mutedTeal,
        ),
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: glassWhite.withOpacity(0.1)),
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: warmIvory,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
