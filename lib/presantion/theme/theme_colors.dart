import 'package:flutter/material.dart';

class ThemeColors {
  // Royal Blue & Gold Theme (AppBar & Drawer)
  static const Color royalBlueDark = Color(0xFF0A1D37);
  static const Color royalBlueMedium = Color(0xFF102B4E);
  static const Color royalBlueLight = Color(0xFF1A3B64);
  static const Color goldPrimary = Color(0xFFFFD700);
  static const Color goldSecondary = Color(0xFFFFED4E);
  static const Color goldLight = Color(0xFFFFF9D6);
  
  // Neutral Colors
  static const Color ivoryWhite = Color(0xFFF8F5F0);
  static const Color parchment = Color(0xFFF3EDE2);
  static const Color antiqueWhite = Color(0xFFFAEBD7);
  static const Color charcoal = Color(0xFF333333);
  static const Color slateGray = Color(0xFF6E7E8A);
  
  // Accent Colors (for word categories)
  static const Color deepRed = Color(0xFF8B0000);
  static const Color forestGreen = Color(0xFF228B22);
  static const Color sapphire = Color(0xFF0F52BA);
  static const Color amethyst = Color(0xFF9966CC);
  static const Color bronze = Color(0xFFCD7F32);
  static const Color crimson = Color(0xFFDC143C);
  
  // Shadows
  static const List<BoxShadow> subtleShadow = [
    BoxShadow(
      color: Color(0x11000000),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];
  
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x15000000),
      blurRadius: 10,
      offset: Offset(0, 3),
    ),
  ];
  
  // Gradients
  static const Gradient royalGradient = LinearGradient(
    colors: [royalBlueDark, royalBlueMedium],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const Gradient goldGradient = LinearGradient(
    colors: [goldPrimary, goldSecondary],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}