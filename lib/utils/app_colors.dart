import 'package:flutter/material.dart';

/// Palette de couleurs cohérentes pour l'application SAMA UFR
class AppColors {
  // === DÉGRADÉS PRINCIPAUX ===

  // Bleu → Vert (Articles, Livres, Documents)
  static const List<Color> gradientBlueGreen = [
    Color(0xFF2E3192), // Bleu principal
    Color(0xFF2ECC71), // Vert menthe
  ];

  // Violet → Bleu (Événements, Actualités)
  static const List<Color> gradientPurpleBlue = [
    Color(0xFF9B59B6), // Violet
    Color(0xFF2E3192), // Bleu principal
  ];

  // Orange → Amber (Documents, Examens)
  static const List<Color> gradientOrangeAmber = [
    Color(0xFFF39C12), // Orange
    Color(0xFFE67E22), // Amber foncé
  ];

  // Rose → Violet (Notifications, Favoris)
  static const List<Color> gradientPinkPurple = [
    Color(0xFFE74C3C), // Rose rouge
    Color(0xFF9B59B6), // Violet
  ];

  // Vert → Turquoise (Résultats, Statistiques)
  static const List<Color> gradientGreenTurquoise = [
    Color(0xFF2ECC71), // Vert menthe
    Color(0xFF1ABC9C), // Turquoise
  ];

  // Bleu foncé → Cyan (Emploi du temps, Horaires) - Gradient principal de l'app
  static const List<Color> gradientNavyBlue = [
    Color(0xFF2E3192), // Bleu principal
    Color(0xFF1BFFFF), // Cyan
  ];

  // === COULEURS INDIVIDUELLES ===

  static const Color primary = Color(0xFF2E3192); // Bleu principal
  static const Color secondary = Color(0xFF2ECC71); // Vert secondaire
  static const Color accent = Color(0xFF9B59B6); // Violet accent
  static const Color danger = Color(0xFFE74C3C); // Rouge danger
  static const Color warning = Color(0xFFF39C12); // Orange warning
  static const Color success = Color(0xFF2ECC71); // Vert succès
  static const Color info = Color(0xFF2E3192); // Bleu info

  // Couleurs neutres
  static const Color darkText = Color(0xFF2C3E50); // Texte foncé
  static const Color lightText = Color(0xFF7F8C8D); // Texte clair
  static const Color background = Color(0xFFFFFFFF); // Fond blanc
  static const Color border = Color(0xFFEEEEEE); // Bordures légères

  // === MÉTHODES UTILITAIRES ===

  /// Obtenir un dégradé linéaire
  static LinearGradient getGradient(
    List<Color> colors, {
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    return LinearGradient(begin: begin, end: end, colors: colors);
  }

  /// Obtenir un dégradé pour un type de section
  static LinearGradient getGradientForSection(String section) {
    switch (section.toLowerCase()) {
      case 'article':
      case 'livre':
      case 'document':
        return getGradient(gradientBlueGreen);
      case 'event':
      case 'evenement':
      case 'news':
      case 'actualite':
        return getGradient(gradientPurpleBlue);
      case 'exam':
      case 'examen':
      case 'test':
        return getGradient(gradientOrangeAmber);
      case 'favorite':
      case 'favori':
      case 'notification':
        return getGradient(gradientPinkPurple);
      case 'result':
      case 'resultat':
      case 'statistique':
        return getGradient(gradientGreenTurquoise);
      case 'schedule':
      case 'emploi du temps':
      case 'horaire':
        return getGradient(gradientNavyBlue);
      default:
        return getGradient(gradientBlueGreen);
    }
  }

  /// Obtenir une couleur pour un type de section
  static Color getColorForSection(String section) {
    switch (section.toLowerCase()) {
      case 'article':
      case 'livre':
        return primary;
      case 'event':
      case 'evenement':
        return accent;
      case 'exam':
      case 'examen':
        return warning;
      case 'result':
      case 'resultat':
        return success;
      case 'document':
        return warning;
      case 'notification':
      case 'favorite':
        return danger;
      default:
        return primary;
    }
  }
}
