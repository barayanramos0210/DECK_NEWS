import 'package:flutter/material.dart';

class DeckNewsTheme {
  // Paleta de Colores Gamificada (Estilo Madera y Panel)
  static const Color bgWood = Color(0xFF2A1810); // Fondo madera oscura
  static const Color panelBg = Color(0xFFDCC2A3); // Beige panel
  static const Color panelBorder = Color(0xFF4A2C11); // Borde madera
  static const Color bubbleBg = Color(0xFFFEFEFE); // Blanco burbuja
  static const Color accentGreen = Color(0xFF7BB661); // Verde botón PDF
  static const Color accentGreenDark = Color(0xFF4D8038); // Verde oscuro
  static const Color textColor = Color(0xFF2B1A09); // Texto marrón oscuro
  static const Color white = Colors.white;

  // --- ALIASES DE COMPATIBILIDAD ---
  static const Color colorPrimario = panelBorder;
  static const Color colorFondo = bgWood;
  static const Color colorTextoOscuro = textColor;
  static const Color colorBlanco = white;

  // Colores de Categorías
  static const Color catRadiografia = Color(0xFFF4A261);
  static const Color catTrazabilidad = Color(0xFF2A9D8F);
  static const Color catArquitectura = Color(0xFF9B5DE5);
  static const Color catPreguntas = Color(0xFFE9C46A);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: panelBorder,
        secondary: accentGreen,
        surface: panelBg,
        background: bgWood,
        onPrimary: white,
        onSecondary: white,
        onSurface: textColor,
        onBackground: white,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textColor,
          fontFamily: 'Comic Sans MS',
        ),
        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: textColor,
          fontFamily: 'Comic Sans MS',
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          color: textColor,
          fontFamily: 'Comic Sans MS',
        ),
      ),
      scaffoldBackgroundColor: bgWood,
    );
  }

  // Definición estática para evitar errores de 'Type'
  static TextStyle get textColorStyle => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textColor,
        fontFamily: 'Comic Sans MS',
      );
}
