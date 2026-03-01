import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors based on modern, clean corporate aesthetic (Trust, Growth, Communication)
  static const Color primaryColor = Color(0xFF1E3A8A); // Deep Blue
  static const Color secondaryColor = Color(0xFF38BDF8); // Sky Blue Accent
  static const Color backgroundColor = Color(0xFFF8FAFC); // Very Light Slate
  static const Color surfaceColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF0F172A); // Dark Slate
  static const Color textSecondaryColor = Color(0xFF64748B); // Slate Gray

  static const Color successColor = Color(0xFF10B981); // Emerald Green
  static const Color warningColor = Color(0xFFF59E0B); // Amber
  static const Color errorColor = Color(0xFFEF4444); // Red

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      primaryColor: primaryColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        surface: surfaceColor,
        error: errorColor,
      ),
      fontFamily:
          'Roboto', // Using built-in font for now, can add GoogleFonts later
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textPrimaryColor,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: primaryColor),
        titleTextStyle: TextStyle(
          color: textPrimaryColor,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: surfaceColor,
        elevation: 2,
        shadowColor: Colors.black26, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),

      // Bottom Nav Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}
