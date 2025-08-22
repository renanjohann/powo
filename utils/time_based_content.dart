import 'package:flutter/material.dart';

class TimeBasedContent {
  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Bom dia';
    } else if (hour >= 12 && hour < 18) {
      return 'Boa tarde';
    } else {
      return 'Boa noite';
    }
  }

  static String getTimeBasedMessage() {
    final hour = DateTime.now().hour;
    final weekday = DateTime.now().weekday;
    
    if (hour >= 6 && hour < 11) {
      return 'Que tal um café da manhã especial?';
    } else if (hour >= 11 && hour < 15) {
      return 'Hora do almoço! Que tal experimentar algo novo?';
    } else if (hour >= 15 && hour < 18) {
      return 'Café da tarde? Temos opções deliciosas!';
    } else if (hour >= 18 && hour < 22) {
      if (weekday == 5) { // Sexta-feira
        return 'Sextou! Hora de celebrar com boa comida!';
      } else {
        return 'Jantar especial? Temos as melhores opções!';
      }
    } else {
      return 'Madrugada? Temos opções que ficam abertas até tarde!';
    }
  }

  static List<String> getTimeBasedCategories() {
    final hour = DateTime.now().hour;
    final weekday = DateTime.now().weekday;
    
    if (hour >= 6 && hour < 11) {
      // Manhã: Padarias e Cafeterias
      return ['Café', 'Padaria', 'Sucos', 'Pães', 'Doces', 'Mais'];
    } else if (hour >= 11 && hour < 15) {
      // Almoço: Restaurantes e Marmitas
      return ['Prato do Dia', 'Marmita', 'Restaurante', 'Saladas', 'Sopas', 'Mais'];
    } else if (hour >= 15 && hour < 18) {
      // Tarde: Lanches e Doces
      return ['Lanches', 'Doces', 'Café', 'Sucos', 'Sorvetes', 'Mais'];
    } else if (hour >= 18 && hour < 22) {
      if (weekday == 5) { // Sexta-feira: Happy Hour
        return ['Pizza', 'Hambúrguer', 'Promoções', 'Bebidas', 'Petiscos', 'Mais'];
      } else {
        // Jantar: Variedade
        return ['Jantar', 'Pizza', 'Hambúrguer', 'Sushi', 'Churrasco', 'Mais'];
      }
    } else {
      // Madrugada: Opções que ficam abertas
      return ['Madrugada', 'Hambúrguer', 'Pizza', 'Lanches', 'Bebidas', 'Mais'];
    }
  }

  static String getTimeBasedHighlight() {
    final hour = DateTime.now().hour;
    final weekday = DateTime.now().weekday;
    
    if (hour >= 6 && hour < 11) {
      return '☕ Café da manhã especial';
    } else if (hour >= 11 && hour < 15) {
      return '🍽️ Prato do dia em destaque';
    } else if (hour >= 15 && hour < 18) {
      return '🍰 Café da tarde gourmet';
    } else if (hour >= 18 && hour < 22) {
      if (weekday == 5) {
        return '🎉 Happy Hour com descontos';
      } else {
        return '🌙 Jantar especial';
      }
    } else {
      return '🌙 Opções até tarde';
    }
  }

  static Color getTimeBasedColor() {
    final hour = DateTime.now().hour;
    
    if (hour >= 6 && hour < 12) {
      return const Color(0xFFFFB300); // Dourado manhã
    } else if (hour >= 12 && hour < 18) {
      return const Color(0xFF00C853); // Verde tarde
    } else {
      return const Color(0xFF9C27B0); // Roxo noite
    }
  }

  static bool isHappyHour() {
    final hour = DateTime.now().hour;
    final weekday = DateTime.now().weekday;
    return weekday == 5 && hour >= 18 && hour < 22; // Sexta 18h-22h
  }

  static bool isLunchTime() {
    final hour = DateTime.now().hour;
    return hour >= 11 && hour < 15;
  }

  static bool isBreakfastTime() {
    final hour = DateTime.now().hour;
    return hour >= 6 && hour < 11;
  }
}
