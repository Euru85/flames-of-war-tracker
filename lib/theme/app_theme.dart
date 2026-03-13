import 'package:flutter/material.dart';

class AppColors {
  // Military palette
  static const Color darkOlive = Color(0xFF2D3A1E);
  static const Color olive = Color(0xFF4A5C2A);
  static const Color lightOlive = Color(0xFF6B7C3D);
  static const Color khaki = Color(0xFFB5A469);
  static const Color sand = Color(0xFFD4C48A);
  static const Color cream = Color(0xFFF2E9C9);

  static const Color bloodRed = Color(0xFF8B1A1A);
  static const Color red = Color(0xFFCC2222);
  static const Color amber = Color(0xFFD4870A);
  static const Color gold = Color(0xFFCFA82E);

  static const Color darkGrey = Color(0xFF1C1F17);
  static const Color darkCard = Color(0xFF252A1A);
  static const Color cardBg = Color(0xFF2E3520);
  static const Color divider = Color(0xFF3D4A25);

  static const Color textPrimary = Color(0xFFE8DFB8);
  static const Color textSecondary = Color(0xFFA8A080);
  static const Color textMuted = Color(0xFF6A6448);

  static const Color attackerBlue = Color(0xFF2A5C8B);
  static const Color defenderBrown = Color(0xFF7A4A1E);
}

class AppTheme {
  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.darkGrey,
      primaryColor: AppColors.olive,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.olive,
        secondary: AppColors.khaki,
        surface: AppColors.darkCard,
        error: AppColors.red,
        onPrimary: AppColors.cream,
        onSecondary: AppColors.darkGrey,
        onSurface: AppColors.textPrimary,
      ),
      cardTheme: const CardTheme(
        color: AppColors.cardBg,
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkOlive,
        foregroundColor: AppColors.cream,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.cream,
          letterSpacing: 1.5,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.cream,
          fontSize: 32,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
        ),
        displayMedium: TextStyle(
          color: AppColors.cream,
          fontSize: 26,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
        ),
        headlineLarge: TextStyle(
          color: AppColors.cream,
          fontSize: 22,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
        headlineMedium: TextStyle(
          color: AppColors.sand,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.0,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
          fontSize: 13,
        ),
        labelLarge: TextStyle(
          color: AppColors.cream,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.olive,
          foregroundColor: AppColors.cream,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            letterSpacing: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.khaki,
          side: const BorderSide(color: AppColors.khaki, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            letterSpacing: 1.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(color: AppColors.khaki, width: 1.5),
        ),
        labelStyle: TextStyle(color: AppColors.textSecondary),
        hintStyle: TextStyle(color: AppColors.textMuted),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
      chipTheme: const ChipThemeData(
        backgroundColor: AppColors.darkCard,
        labelStyle: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        side: BorderSide(color: AppColors.divider),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.cardBg,
        contentTextStyle: TextStyle(color: AppColors.textPrimary),
      ),
    );
  }
}

// ── Reusable Widgets ─────────────────────────────────────────────────────────

class SectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final Color color;

  const SectionHeader({
    super.key,
    required this.title,
    this.icon,
    this.color = AppColors.khaki,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 8),
          ],
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(height: 1, color: color.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String body;
  final IconData? icon;
  final Color borderColor;

  const InfoCard({
    super.key,
    required this.title,
    required this.body,
    this.icon,
    this.borderColor = AppColors.divider,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(6),
        border: Border(left: BorderSide(color: borderColor, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: borderColor, size: 15),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.sand,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class MilitaryBadge extends StatelessWidget {
  final String label;
  final Color color;

  const MilitaryBadge({
    super.key,
    required this.label,
    this.color = AppColors.olive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: color.withOpacity(0.7)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
