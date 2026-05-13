import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ─── Brand Palette ───────────────────────────────────────────
  static const Color brandPrimary    = Color(0xFFE8401C); // Chef's flame
  static const Color brandSecondary  = Color(0xFFF4A261); // Warm amber
  static const Color brandAccent     = Color(0xFF2EC4B6); // Fresh mint
  static const Color brandGold       = Color(0xFFE9C46A); // Saffron gold

  // Light Surface
  static const Color lightBackground  = Color(0xFFFAF9F7);
  static const Color lightSurface     = Color(0xFFFFFFFF);
  static const Color lightCard        = Color(0xFFF5F4F2);
  static const Color lightBorder      = Color(0xFFE8E6E1);
  static const Color lightTextPrimary = Color(0xFF1A1A1A);
  static const Color lightTextSecondary = Color(0xFF6B6B6B);
  static const Color lightTextHint    = Color(0xFFADADAD);

  // Dark Surface
  static const Color darkBackground   = Color(0xFF0F0E0D);
  static const Color darkSurface      = Color(0xFF1C1B18);
  static const Color darkCard         = Color(0xFF252420);
  static const Color darkBorder       = Color(0xFF363430);
  static const Color darkTextPrimary  = Color(0xFFF5F4F2);
  static const Color darkTextSecondary = Color(0xFF9E9C97);

  // Semantic
  static const Color success  = Color(0xFF52B788);
  static const Color warning  = Color(0xFFFFB627);
  static const Color error    = Color(0xFFE63946);
  static const Color info     = Color(0xFF4895EF);

  // Difficulty Colors
  static const Color beginnerColor     = Color(0xFF52B788);
  static const Color intermediateColor = Color(0xFFFFB627);
  static const Color advancedColor     = Color(0xFFE63946);

  // ─── Typography ─────────────────────────────────────────────
  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      // Display — Playfair for elegance
      displayLarge: GoogleFonts.playfairDisplay(
        fontSize: 57, fontWeight: FontWeight.w700,
        color: primary, letterSpacing: -0.25,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        fontSize: 45, fontWeight: FontWeight.w700,
        color: primary, letterSpacing: 0,
      ),
      displaySmall: GoogleFonts.playfairDisplay(
        fontSize: 36, fontWeight: FontWeight.w600,
        color: primary, letterSpacing: 0,
      ),
      // Headlines — Inter for readability
      headlineLarge: GoogleFonts.inter(
        fontSize: 32, fontWeight: FontWeight.w700,
        color: primary, letterSpacing: -0.5,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28, fontWeight: FontWeight.w600,
        color: primary, letterSpacing: -0.25,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24, fontWeight: FontWeight.w600,
        color: primary, letterSpacing: 0,
      ),
      // Titles
      titleLarge: GoogleFonts.inter(
        fontSize: 22, fontWeight: FontWeight.w600,
        color: primary, letterSpacing: 0,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w600,
        color: primary, letterSpacing: 0.15,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w500,
        color: primary, letterSpacing: 0.1,
      ),
      // Body
      bodyLarge: GoogleFonts.inter(
        fontSize: 16, fontWeight: FontWeight.w400,
        color: secondary, letterSpacing: 0.5,
        height: 1.6,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w400,
        color: secondary, letterSpacing: 0.25,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w400,
        color: secondary, letterSpacing: 0.4,
      ),
      // Labels
      labelLarge: GoogleFonts.inter(
        fontSize: 14, fontWeight: FontWeight.w600,
        color: primary, letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12, fontWeight: FontWeight.w600,
        color: primary, letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11, fontWeight: FontWeight.w500,
        color: secondary, letterSpacing: 0.5,
      ),
    );
  }

  // ─── Light Theme ────────────────────────────────────────────
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.light(
      primary: brandPrimary,
      onPrimary: Colors.white,
      primaryContainer: brandPrimary.withOpacity(0.12),
      onPrimaryContainer: brandPrimary,
      secondary: brandSecondary,
      onSecondary: Colors.white,
      tertiary: brandAccent,
      onTertiary: Colors.white,
      surface: lightSurface,
      onSurface: lightTextPrimary,
      surfaceContainerHighest: lightCard,
      outline: lightBorder,
      error: error,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: lightBackground,
      textTheme: _buildTextTheme(lightTextPrimary, lightTextSecondary),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 24, fontWeight: FontWeight.w700,
          color: lightTextPrimary,
        ),
        iconTheme: const IconThemeData(color: lightTextPrimary),
      ),

      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: lightBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: brandPrimary,
          side: const BorderSide(color: brandPrimary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: lightBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: brandPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: GoogleFonts.inter(color: lightTextHint, fontSize: 14),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: lightCard,
        selectedColor: brandPrimary.withOpacity(0.15),
        labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
        side: const BorderSide(color: lightBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: lightSurface,
        indicatorColor: brandPrimary.withOpacity(0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: brandPrimary, size: 24);
          }
          return IconThemeData(color: lightTextSecondary, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: brandPrimary);
          }
          return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: lightTextSecondary);
        }),
        elevation: 0,
        height: 70,
      ),

      dividerTheme: const DividerThemeData(
        color: lightBorder, thickness: 1, space: 0,
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: lightTextPrimary,
        contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ─── Dark Theme ─────────────────────────────────────────────
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.dark(
      primary: brandPrimary,
      onPrimary: Colors.white,
      primaryContainer: brandPrimary.withOpacity(0.18),
      onPrimaryContainer: Colors.white,
      secondary: brandSecondary,
      onSecondary: darkBackground,
      tertiary: brandAccent,
      surface: darkSurface,
      onSurface: darkTextPrimary,
      surfaceContainerHighest: darkCard,
      outline: darkBorder,
      error: error,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: darkBackground,
      textTheme: _buildTextTheme(darkTextPrimary, darkTextSecondary),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.playfairDisplay(
          fontSize: 24, fontWeight: FontWeight.w700,
          color: darkTextPrimary,
        ),
        iconTheme: const IconThemeData(color: darkTextPrimary),
      ),

      cardTheme: CardThemeData(
        color: darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: darkBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: darkBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: brandPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: GoogleFonts.inter(color: darkTextSecondary, fontSize: 14),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: darkCard,
        selectedColor: brandPrimary.withOpacity(0.25),
        labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: darkTextPrimary),
        side: const BorderSide(color: darkBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurface,
        indicatorColor: brandPrimary.withOpacity(0.20),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: brandPrimary, size: 24);
          }
          return IconThemeData(color: darkTextSecondary, size: 24);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: brandPrimary);
          }
          return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: darkTextSecondary);
        }),
        elevation: 0,
        height: 70,
      ),

      dividerTheme: const DividerThemeData(color: darkBorder, thickness: 1, space: 0),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: darkCard,
        contentTextStyle: GoogleFonts.inter(color: darkTextPrimary, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ─── Gradients ───────────────────────────────────────────────
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.transparent, Color(0xCC000000)],
    stops: [0.3, 1.0],
  );

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandPrimary, Color(0xFFC1440F)],
  );

  static const LinearGradient warmGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [brandSecondary, brandGold],
  );

  // ─── Shadows ─────────────────────────────────────────────────
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 20, offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 6, offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: brandPrimary.withOpacity(0.25),
      blurRadius: 20, offset: const Offset(0, 8),
    ),
  ];
}
