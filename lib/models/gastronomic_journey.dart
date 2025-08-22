import 'package:flutter/material.dart';

enum JourneyStatus { notStarted, inProgress, completed, failed }
enum JourneyDifficulty { beginner, intermediate, advanced, expert }

class GastronomicJourney {
  final String id;
  final String title;
  final String description;
  final String category;
  final JourneyDifficulty difficulty;
  final int targetCount;
  final int timeLimitDays;
  final List<String> requiredRestaurants;
  final List<String> requiredDishes;
  final double minPowoScore;
  final int powoCoinsReward;
  final String badgeReward;
  final String icon;
  final Color themeColor;
  final DateTime? startDate;
  final DateTime? endDate;
  final JourneyStatus status;
  final int currentProgress;
  final List<String> completedTasks;

  GastronomicJourney({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.targetCount,
    required this.timeLimitDays,
    required this.requiredRestaurants,
    required this.requiredDishes,
    required this.minPowoScore,
    required this.powoCoinsReward,
    required this.badgeReward,
    required this.icon,
    required this.themeColor,
    this.startDate,
    this.endDate,
    this.status = JourneyStatus.notStarted,
    this.currentProgress = 0,
    this.completedTasks = const [],
  });

  GastronomicJourney copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    JourneyDifficulty? difficulty,
    int? targetCount,
    int? timeLimitDays,
    List<String>? requiredRestaurants,
    List<String>? requiredDishes,
    double? minPowoScore,
    int? powoCoinsReward,
    String? badgeReward,
    String? icon,
    Color? themeColor,
    DateTime? startDate,
    DateTime? endDate,
    JourneyStatus? status,
    int? currentProgress,
    List<String>? completedTasks,
  }) {
    return GastronomicJourney(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      targetCount: targetCount ?? this.targetCount,
      timeLimitDays: timeLimitDays ?? this.timeLimitDays,
      requiredRestaurants: requiredRestaurants ?? this.requiredRestaurants,
      requiredDishes: requiredDishes ?? this.requiredDishes,
      minPowoScore: minPowoScore ?? this.minPowoScore,
      powoCoinsReward: powoCoinsReward ?? this.powoCoinsReward,
      badgeReward: badgeReward ?? this.badgeReward,
      icon: icon ?? this.icon,
      themeColor: themeColor ?? this.themeColor,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      currentProgress: currentProgress ?? this.currentProgress,
      completedTasks: completedTasks ?? this.completedTasks,
    );
  }

  bool get isExpired {
    if (startDate == null) return false;
    final deadline = startDate!.add(Duration(days: timeLimitDays));
    return DateTime.now().isAfter(deadline);
  }

  bool get isCompleted => currentProgress >= targetCount;
  
  double get progressPercentage => (currentProgress / targetCount).clamp(0.0, 1.0);
  
  int get remainingDays {
    if (startDate == null) return timeLimitDays;
    final deadline = startDate!.add(Duration(days: timeLimitDays));
    final remaining = deadline.difference(DateTime.now()).inDays;
    return remaining.clamp(0, timeLimitDays);
  }

  String get difficultyText {
    switch (difficulty) {
      case JourneyDifficulty.beginner:
        return 'Iniciante';
      case JourneyDifficulty.intermediate:
        return 'Intermediário';
      case JourneyDifficulty.advanced:
        return 'Avançado';
      case JourneyDifficulty.expert:
        return 'Expert';
    }
  }

  Color get difficultyColor {
    switch (difficulty) {
      case JourneyDifficulty.beginner:
        return Colors.green;
      case JourneyDifficulty.intermediate:
        return Colors.blue;
      case JourneyDifficulty.advanced:
        return Colors.orange;
      case JourneyDifficulty.expert:
        return Colors.red;
    }
  }

  String get statusText {
    switch (status) {
      case JourneyStatus.notStarted:
        return 'Não iniciada';
      case JourneyStatus.inProgress:
        return 'Em andamento';
      case JourneyStatus.completed:
        return 'Concluída';
      case JourneyStatus.failed:
        return 'Falhou';
    }
  }

  Color get statusColor {
    switch (status) {
      case JourneyStatus.notStarted:
        return Colors.grey;
      case JourneyStatus.inProgress:
        return Colors.blue;
      case JourneyStatus.completed:
        return Colors.green;
      case JourneyStatus.failed:
        return Colors.red;
    }
  }
}

class JourneyManager {
  static List<GastronomicJourney> getAvailableJourneys() {
    return [
      // Jornada do Hambúrguer Perfeito
      GastronomicJourney(
        id: 'burger_master',
        title: 'A Jornada do Hambúrguer Perfeito',
        description: 'Explore os 5 melhores hambúrgueres da cidade com POWO Score 9.0+ e torne-se um Mestre Hamburgueiro!',
        category: 'Hambúrguer',
        difficulty: JourneyDifficulty.intermediate,
        targetCount: 5,
        timeLimitDays: 30,
        requiredRestaurants: [],
        requiredDishes: ['Hambúrguer'],
        minPowoScore: 9.0,
        powoCoinsReward: 500,
        badgeReward: '🍔 Mestre Hamburgueiro',
        icon: '🍔',
        themeColor: const Color(0xFFFFB300),
      ),

      // Jornada da Pizza Suprema
      GastronomicJourney(
        id: 'pizza_supreme',
        title: 'A Jornada da Pizza Suprema',
        description: 'Descubra as pizzas mais autênticas da região e conquiste o título de Especialista em Pizza!',
        category: 'Pizza',
        difficulty: JourneyDifficulty.advanced,
        targetCount: 8,
        timeLimitDays: 45,
        requiredRestaurants: [],
        requiredDishes: ['Pizza'],
        minPowoScore: 8.5,
        powoCoinsReward: 800,
        badgeReward: '🍕 Especialista em Pizza',
        icon: '🍕',
        themeColor: const Color(0xFFFF6B35),
      ),

      // Jornada do Sushi Gourmet
      GastronomicJourney(
        id: 'sushi_gourmet',
        title: 'A Jornada do Sushi Gourmet',
        description: 'Experimente os melhores sushis da cidade e torne-se um Connoisseur da culinária japonesa!',
        category: 'Sushi',
        difficulty: JourneyDifficulty.expert,
        targetCount: 10,
        timeLimitDays: 60,
        requiredRestaurants: [],
        requiredDishes: ['Sushi', 'Sashimi', 'Temaki'],
        minPowoScore: 9.2,
        powoCoinsReward: 1200,
        badgeReward: '🍣 Connoisseur do Sushi',
        icon: '🍣',
        themeColor: const Color(0xFF00C853),
      ),

      // Jornada do Café da Manhã
      GastronomicJourney(
        id: 'breakfast_explorer',
        title: 'A Jornada do Café da Manhã',
        description: 'Comece seus dias explorando os melhores cafés da manhã da cidade!',
        category: 'Café',
        difficulty: JourneyDifficulty.beginner,
        targetCount: 7,
        timeLimitDays: 21,
        requiredRestaurants: [],
        requiredDishes: ['Café', 'Pão', 'Croissant'],
        minPowoScore: 8.0,
        powoCoinsReward: 300,
        badgeReward: '☕ Explorador do Café',
        icon: '☕',
        themeColor: const Color(0xFF8D6E63),
      ),

      // Jornada do Happy Hour
      GastronomicJourney(
        id: 'happy_hour_master',
        title: 'A Jornada do Happy Hour',
        description: 'Descubra os melhores lugares para celebrar o final de semana com drinks e petiscos!',
        category: 'Happy Hour',
        difficulty: JourneyDifficulty.intermediate,
        targetCount: 6,
        timeLimitDays: 30,
        requiredRestaurants: [],
        requiredDishes: ['Drink', 'Petisco', 'Hambúrguer'],
        minPowoScore: 8.0,
        powoCoinsReward: 600,
        badgeReward: '🎉 Mestre do Happy Hour',
        icon: '🎉',
        themeColor: const Color(0xFFE91E63),
      ),
    ];
  }

  static GastronomicJourney? getJourneyById(String id) {
    return getAvailableJourneys().where((journey) => journey.id == id).firstOrNull;
  }

  static List<GastronomicJourney> getJourneysByCategory(String category) {
    return getAvailableJourneys().where((journey) => journey.category == category).toList();
  }

  static List<GastronomicJourney> getJourneysByDifficulty(JourneyDifficulty difficulty) {
    return getAvailableJourneys().where((journey) => journey.difficulty == difficulty).toList();
  }
}
