import 'package:flutter/material.dart';

class AppConfig {
  // Cores principais (estilo iFood/99Food)
  static const Color primaryColor = Color(0xFFEA1D2C);      // Vermelho vibrante
  static const Color primaryDark = Color(0xFFB71C1C);       // Vermelho escuro
  static const Color secondaryColor = Color(0xFF2C2C2C);    // Cinza escuro moderno
  static const Color accentColor = Color(0xFFFFB300);       // Amarelo dourado
  static const Color successColor = Color(0xFF00C853);      // Verde sucesso
  static const Color errorColor = Color(0xFFFF1744);        // Vermelho erro
  static const Color warningColor = Color(0xFFFF9100);
  
  // Cores de fundo
  static const Color backgroundColor = Color(0xFFFAFAFA);
  static const Color surfaceColor = Colors.white;
  static const Color cardColor = Colors.white;
  
  // Cores de texto
  static const Color textPrimaryColor = Color(0xFF3F3D56);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color textHintColor = Color(0xFFBDBDBD);
  
  // Gradientes modernos
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEA1D2C), Color(0xFFFF4569)],
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFB300), Color(0xFFFFD54F)],
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFAFAFA), Color(0xFFF5F5F5)],
  );
  
  // Sombras
  static List<BoxShadow> get defaultShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 10,
      offset: const Offset(0, 5),
    ),
  ];
  
  static List<BoxShadow> get elevatedShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
  
  // Bordas arredondadas
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;
  static const double borderRadiusExtraLarge = 24.0;
  
  // Espaçamentos
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;
  
  // Tamanhos de fonte
  static const double fontSizeXS = 10.0;
  static const double fontSizeS = 12.0;
  static const double fontSizeM = 14.0;
  static const double fontSizeL = 16.0;
  static const double fontSizeXL = 18.0;
  static const double fontSizeXXL = 20.0;
  static const double fontSizeXXXL = 24.0;
  
  // Durações de animação
  static const Duration animationDurationFast = Duration(milliseconds: 200);
  static const Duration animationDurationNormal = Duration(milliseconds: 300);
  static const Duration animationDurationSlow = Duration(milliseconds: 500);
  
  // Curvas de animação
  static const Curve animationCurve = Curves.easeInOut;
  static const Curve animationCurveFast = Curves.easeOut;
  static const Curve animationCurveSlow = Curves.easeIn;
  
  // Configurações de tema
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textPrimaryColor,
        fontSize: fontSizeXXL,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: textPrimaryColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingL,
          vertical: spacingM,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadiusMedium),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingL,
          vertical: spacingM,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(borderRadiusMedium),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 2,
        ),
      ),
      filled: true,
      fillColor: backgroundColor,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusLarge),
      ),
    ),
  );
  
  // Configurações de texto
  static const TextStyle headingStyle = TextStyle(
    fontSize: fontSizeXXXL,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );
  
  static const TextStyle subheadingStyle = TextStyle(
    fontSize: fontSizeXXL,
    fontWeight: FontWeight.w600,
    color: textPrimaryColor,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: fontSizeL,
    color: textPrimaryColor,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: fontSizeS,
    color: textSecondaryColor,
  );
  
  // Configurações de padding
  static const EdgeInsets defaultPadding = EdgeInsets.all(spacingM);
  static const EdgeInsets horizontalPadding = EdgeInsets.symmetric(horizontal: spacingM);
  static const EdgeInsets verticalPadding = EdgeInsets.symmetric(vertical: spacingM);
  
  // Configurações de margem
  static const EdgeInsets defaultMargin = EdgeInsets.all(spacingM);
  static const EdgeInsets horizontalMargin = EdgeInsets.symmetric(horizontal: spacingM);
  static const EdgeInsets verticalMargin = EdgeInsets.symmetric(vertical: spacingM);
}
