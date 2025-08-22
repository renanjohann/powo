import 'package:flutter/material.dart';
import '../models/models.dart';
import 'powo_score_calculator.dart';

class PredictiveAnalytics {
  /// Análise de tendências de mercado por região
  static List<MarketTrend> analyzeMarketTrends(String neighborhood, String category) {
    // Simulação de dados de tendências (em produção viria de APIs externas)
    final trends = <MarketTrend>[];
    
    if (category == 'Hambúrguer') {
      trends.add(MarketTrend(
        title: 'Opções Veganas em Alta',
        description: 'Aumento de 30% nas buscas por opções veganas no seu bairro',
        impact: TrendImpact.high,
        recommendation: 'Adicionar um hambúrguer vegano pode aumentar seu faturamento em 15-20%',
        searchGrowth: 30,
        category: 'Vegano',
        color: Colors.green,
      ));
      
      trends.add(MarketTrend(
        title: 'Hambúrgueres Gourmet',
        description: 'Busca por ingredientes premium cresceu 25% este mês',
        impact: TrendImpact.medium,
        recommendation: 'Considere uma linha premium com ingredientes especiais',
        searchGrowth: 25,
        category: 'Premium',
        color: Colors.orange,
      ));
    }
    
    if (category == 'Pizza') {
      trends.add(MarketTrend(
        title: 'Pizzas Artesanais',
        description: 'Demanda por massas artesanais aumentou 40%',
        impact: TrendImpact.high,
        recommendation: 'Destaque o processo artesanal da sua massa',
        searchGrowth: 40,
        category: 'Artesanal',
        color: Colors.brown,
      ));
    }
    
    if (category == 'Sushi') {
      trends.add(MarketTrend(
        title: 'Sushi Delivery',
        description: 'Pedidos de sushi para entrega cresceram 35%',
        impact: TrendImpact.medium,
        recommendation: 'Otimize seu cardápio para delivery',
        searchGrowth: 35,
        category: 'Delivery',
        color: Colors.blue,
      ));
    }
    
    return trends;
  }
  
  /// Análise preditiva de produtos
  static List<ProductInsight> analyzeProductPerformance(Restaurant restaurant, List<Post> reviews) {
    final insights = <ProductInsight>[];
    
    for (final product in restaurant.products) {
      final productReviews = reviews.where((r) => r.productName == product.name).toList();
      
      if (productReviews.isNotEmpty) {
        final averageRating = productReviews.map((r) => r.rating).reduce((a, b) => a + b) / productReviews.length;
        final powoScore = PowoScoreCalculator.calculateDishScore(product, productReviews);
        
        // Análise de comentários para insights
        final commentAnalysis = _analyzeComments(productReviews);
        
        // Previsão de performance
        final performancePrediction = _predictProductPerformance(averageRating, powoScore, commentAnalysis);
        
        insights.add(ProductInsight(
          product: product,
          currentRating: averageRating,
          currentPowoScore: powoScore,
          commentAnalysis: commentAnalysis,
          performancePrediction: performancePrediction,
          recommendations: _generateProductRecommendations(averageRating, powoScore, commentAnalysis),
        ));
      }
    }
    
    return insights;
  }
  
  /// Benchmarking competitivo anônimo
  static CompetitiveBenchmark getCompetitiveBenchmark(Restaurant restaurant, String category, String neighborhood) {
    // Simulação de dados competitivos (em produção viria de análise agregada)
    final competitorData = _getCompetitorData(category, neighborhood);
    
    return CompetitiveBenchmark(
      restaurant: restaurant,
      category: category,
      neighborhood: neighborhood,
      competitorMetrics: competitorData,
      recommendations: _generateCompetitiveRecommendations(restaurant, competitorData),
    );
  }
  
  /// CRM de fidelização
  static LoyaltyAnalysis analyzeCustomerLoyalty(Restaurant restaurant, List<Post> reviews) {
    final customerData = _analyzeCustomerBehavior(reviews);
    final loyaltySegments = _segmentCustomersByLoyalty(customerData);
    
    return LoyaltyAnalysis(
      restaurant: restaurant,
      customerSegments: loyaltySegments,
      retentionOpportunities: _identifyRetentionOpportunities(loyaltySegments),
      personalizedActions: _generatePersonalizedActions(loyaltySegments),
    );
  }
  
  // Métodos auxiliares privados
  static CommentAnalysis _analyzeComments(List<Post> reviews) {
    final positiveKeywords = <String, int>{};
    final negativeKeywords = <String, int>{};
    final suggestions = <String, int>{};
    
    for (final review in reviews) {
      if (review.comment != null) {
        final comment = review.comment!.toLowerCase();
        
        // Análise de palavras-chave
        if (comment.contains('pão') && review.rating < 4) {
          suggestions['pão'] = (suggestions['pão'] ?? 0) + 1;
        }
        
        if (comment.contains('sabor') && review.rating >= 4) {
          positiveKeywords['sabor'] = (positiveKeywords['sabor'] ?? 0) + 1;
        }
        
        if (comment.contains('tempo') && review.rating < 3) {
          negativeKeywords['tempo'] = (negativeKeywords['tempo'] ?? 0) + 1;
        }
      }
    }
    
    return CommentAnalysis(
      positiveKeywords: positiveKeywords,
      negativeKeywords: negativeKeywords,
      suggestions: suggestions,
      mostFrequentComment: _getMostFrequentComment(reviews),
    );
  }
  
  static String _getMostFrequentComment(List<Post> reviews) {
    final commentCounts = <String, int>{};
    
    for (final review in reviews) {
      if (review.comment != null) {
        final comment = review.comment!.toLowerCase();
        commentCounts[comment] = (commentCounts[comment] ?? 0) + 1;
      }
    }
    
    if (commentCounts.isEmpty) return '';
    
    final mostFrequent = commentCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b);
    
    return mostFrequent.key;
  }
  
  static PerformancePrediction _predictProductPerformance(double rating, double powoScore, CommentAnalysis analysis) {
    double predictedRating = rating;
    double predictedPowoScore = powoScore;
    
    // Ajustes baseados na análise de comentários
    if (analysis.suggestions.isNotEmpty) {
      final mostFrequentSuggestion = analysis.suggestions.entries
          .reduce((a, b) => a.value > b.value ? a : b);
      
      if (mostFrequentSuggestion.value >= 3) {
        predictedRating = (rating + 0.5).clamp(0.0, 5.0);
        predictedPowoScore = (powoScore + 0.3).clamp(0.0, 10.0);
      }
    }
    
    return PerformancePrediction(
      currentRating: rating,
      predictedRating: predictedRating,
      currentPowoScore: powoScore,
      predictedPowoScore: predictedPowoScore,
      improvementPotential: predictedRating - rating,
      timeToImprovement: _estimateTimeToImprovement(rating, predictedRating),
    );
  }
  
  static int _estimateTimeToImprovement(double current, double predicted) {
    final improvement = predicted - current;
    if (improvement <= 0) return 0;
    
    // Estimativa baseada na magnitude da melhoria
    if (improvement <= 0.3) return 7; // 1 semana
    if (improvement <= 0.5) return 14; // 2 semanas
    return 30; // 1 mês
  }
  
  static List<String> _generateProductRecommendations(double rating, double powoScore, CommentAnalysis analysis) {
    final recommendations = <String>[];
    
    if (powoScore < 8.0) {
      recommendations.add('Foque em melhorar a qualidade geral para alcançar POWO Score 8.0+');
    }
    
    if (rating < 4.0) {
      recommendations.add('Identifique e corrija os principais pontos de insatisfação');
    }
    
    if (analysis.suggestions.isNotEmpty) {
      final mostFrequent = analysis.suggestions.entries
          .reduce((a, b) => a.value > b.value ? a : b);
      
      if (mostFrequent.value >= 2) {
        recommendations.add('Considere melhorar: ${mostFrequent.key}');
      }
    }
    
    if (powoScore >= 9.0) {
      recommendations.add('Mantenha a excelência! Seu produto já tem selo POWO Premium');
    }
    
    return recommendations;
  }
  
  static Map<String, dynamic> _getCompetitorData(String category, String neighborhood) {
    // Simulação de dados competitivos
    return {
      'averageRating': 8.7,
      'averagePowoScore': 8.9,
      'topKeywords': ['saboroso', 'fresco', 'atendimento', 'qualidade'],
      'priceRange': 'R\$ 25-45',
      'deliveryTime': '25-35 min',
      'customerSatisfaction': 87,
    };
  }
  
  static List<String> _generateCompetitiveRecommendations(Restaurant restaurant, Map<String, dynamic> competitorData) {
    final recommendations = <String>[];
    
    final avgCompetitorRating = competitorData['averageRating'] as double;
    final avgCompetitorPowoScore = competitorData['averagePowoScore'] as double;
    
    if (restaurant.averageRating < avgCompetitorRating) {
      recommendations.add('Sua nota média (${restaurant.averageRating.toStringAsFixed(1)}) está abaixo da concorrência (${avgCompetitorRating.toStringAsFixed(1)})');
    }
    
    if (restaurant.averageRating >= avgCompetitorRating) {
      recommendations.add('Parabéns! Você está acima da média da concorrência');
    }
    
    recommendations.add('Palavras-chave mais usadas pelos concorrentes: ${(competitorData['topKeywords'] as List).join(', ')}');
    
    return recommendations;
  }
  
  static Map<String, CustomerData> _analyzeCustomerBehavior(List<Post> reviews) {
    final customerMap = <String, List<Post>>{};
    
    for (final review in reviews) {
      customerMap.putIfAbsent(review.authorId, () => []).add(review);
    }
    
    final customerData = <String, CustomerData>{};
    
    for (final entry in customerMap.entries) {
      final customerReviews = entry.value;
      final totalReviews = customerReviews.length;
      final averageRating = customerReviews.map((r) => r.rating).reduce((a, b) => a + b) / totalReviews;
      
      customerData[entry.key] = CustomerData(
        customerId: entry.key,
        customerName: customerReviews.first.authorName,
        totalReviews: totalReviews,
        averageRating: averageRating,
        lastVisit: customerReviews.map((r) => r.createdAt).reduce((a, b) => a.isAfter(b) ? a : b),
        loyaltyScore: _calculateLoyaltyScore(totalReviews, averageRating),
      );
    }
    
    return customerData;
  }
  
  static double _calculateLoyaltyScore(int totalReviews, double averageRating) {
    // Score baseado no número de visitas e avaliações
    final visitScore = (totalReviews / 10.0).clamp(0.0, 1.0); // Máximo 10 visitas
    final ratingScore = (averageRating / 5.0).clamp(0.0, 1.0);
    
    return (visitScore * 0.6 + ratingScore * 0.4) * 100;
  }
  
  static List<CustomerSegment> _segmentCustomersByLoyalty(Map<String, CustomerData> customerData) {
    final segments = <CustomerSegment>[];
    
    for (final customer in customerData.values) {
      if (customer.loyaltyScore >= 80) {
        segments.add(CustomerSegment(
          type: LoyaltyType.vip,
          customers: [customer],
          description: 'Clientes VIP - Alta fidelidade',
          color: Colors.purple,
        ));
      } else if (customer.loyaltyScore >= 60) {
        segments.add(CustomerSegment(
          type: LoyaltyType.loyal,
          customers: [customer],
          description: 'Clientes Fiéis - Boa fidelidade',
          color: Colors.blue,
        ));
      } else if (customer.loyaltyScore >= 40) {
        segments.add(CustomerSegment(
          type: LoyaltyType.regular,
          customers: [customer],
          description: 'Clientes Regulares - Fidelidade média',
          color: Colors.green,
        ));
      } else {
        segments.add(CustomerSegment(
          type: LoyaltyType.occasional,
          customers: [customer],
          description: 'Clientes Ocasionais - Baixa fidelidade',
          color: Colors.orange,
        ));
      }
    }
    
    return segments;
  }
  
  static List<RetentionOpportunity> _identifyRetentionOpportunities(List<CustomerSegment> segments) {
    final opportunities = <RetentionOpportunity>[];
    
    for (final segment in segments) {
      if (segment.type == LoyaltyType.vip) {
        opportunities.add(RetentionOpportunity(
          segment: segment,
          action: 'Programa de recompensas exclusivas',
          impact: 'Alta',
          description: 'Mantenha seus clientes VIP engajados com benefícios especiais',
        ));
      } else if (segment.type == LoyaltyType.occasional) {
        opportunities.add(RetentionOpportunity(
          segment: segment,
          action: 'Campanha de reativação',
          impact: 'Média',
          description: 'Convide clientes ocasionais para experiências especiais',
        ));
      }
    }
    
    return opportunities;
  }
  
  static List<PersonalizedAction> _generatePersonalizedActions(List<CustomerSegment> segments) {
    final actions = <PersonalizedAction>[];
    
    for (final segment in segments) {
      switch (segment.type) {
        case LoyaltyType.vip:
          actions.add(PersonalizedAction(
            title: 'Voucher Exclusivo VIP',
            description: '10% de desconto para seus clientes mais fiéis',
            targetSegment: segment,
            actionType: ActionType.discount,
            estimatedImpact: 'Alto',
          ));
          actions.add(PersonalizedAction(
            title: 'Degustação VIP',
            description: 'Convide para degustação de novos pratos',
            targetSegment: segment,
            actionType: ActionType.experience,
            estimatedImpact: 'Alto',
          ));
          break;
          
        case LoyaltyType.loyal:
          actions.add(PersonalizedAction(
            title: 'Programa de Pontos',
            description: 'Acumule pontos e troque por descontos',
            targetSegment: segment,
            actionType: ActionType.loyalty,
            estimatedImpact: 'Médio',
          ));
          break;
          
        case LoyaltyType.regular:
          actions.add(PersonalizedAction(
            title: 'Oferta de Retorno',
            description: '15% de desconto na próxima visita',
            targetSegment: segment,
            actionType: ActionType.discount,
            estimatedImpact: 'Médio',
          ));
          break;
          
        case LoyaltyType.occasional:
          actions.add(PersonalizedAction(
            title: 'Primeira Impressão',
            description: 'Oferta especial para nova experiência',
            targetSegment: segment,
            actionType: ActionType.activation,
            estimatedImpact: 'Baixo',
          ));
          break;
      }
    }
    
    return actions;
  }
}

// Modelos de dados para análise preditiva
class MarketTrend {
  final String title;
  final String description;
  final TrendImpact impact;
  final String recommendation;
  final int searchGrowth;
  final String category;
  final Color color;
  
  MarketTrend({
    required this.title,
    required this.description,
    required this.impact,
    required this.recommendation,
    required this.searchGrowth,
    required this.category,
    required this.color,
  });
}

enum TrendImpact { low, medium, high }

class ProductInsight {
  final Product product;
  final double currentRating;
  final double currentPowoScore;
  final CommentAnalysis commentAnalysis;
  final PerformancePrediction performancePrediction;
  final List<String> recommendations;
  
  ProductInsight({
    required this.product,
    required this.currentRating,
    required this.currentPowoScore,
    required this.commentAnalysis,
    required this.performancePrediction,
    required this.recommendations,
  });
}

class CommentAnalysis {
  final Map<String, int> positiveKeywords;
  final Map<String, int> negativeKeywords;
  final Map<String, int> suggestions;
  final String mostFrequentComment;
  
  CommentAnalysis({
    required this.positiveKeywords,
    required this.negativeKeywords,
    required this.suggestions,
    required this.mostFrequentComment,
  });
}

class PerformancePrediction {
  final double currentRating;
  final double predictedRating;
  final double currentPowoScore;
  final double predictedPowoScore;
  final double improvementPotential;
  final int timeToImprovement;
  
  PerformancePrediction({
    required this.currentRating,
    required this.predictedRating,
    required this.currentPowoScore,
    required this.predictedPowoScore,
    required this.improvementPotential,
    required this.timeToImprovement,
  });
}

class CompetitiveBenchmark {
  final Restaurant restaurant;
  final String category;
  final String neighborhood;
  final Map<String, dynamic> competitorMetrics;
  final List<String> recommendations;
  
  CompetitiveBenchmark({
    required this.restaurant,
    required this.category,
    required this.neighborhood,
    required this.competitorMetrics,
    required this.recommendations,
  });
}

class CustomerData {
  final String customerId;
  final String customerName;
  final int totalReviews;
  final double averageRating;
  final DateTime lastVisit;
  final double loyaltyScore;
  
  CustomerData({
    required this.customerId,
    required this.customerName,
    required this.totalReviews,
    required this.averageRating,
    required this.lastVisit,
    required this.loyaltyScore,
  });
}

class CustomerSegment {
  final LoyaltyType type;
  final List<CustomerData> customers;
  final String description;
  final Color color;
  
  CustomerSegment({
    required this.type,
    required this.customers,
    required this.description,
    required this.color,
  });
}

enum LoyaltyType { vip, loyal, regular, occasional }

class RetentionOpportunity {
  final CustomerSegment segment;
  final String action;
  final String impact;
  final String description;
  
  RetentionOpportunity({
    required this.segment,
    required this.action,
    required this.impact,
    required this.description,
  });
}

class PersonalizedAction {
  final String title;
  final String description;
  final CustomerSegment targetSegment;
  final ActionType actionType;
  final String estimatedImpact;
  
  PersonalizedAction({
    required this.title,
    required this.description,
    required this.targetSegment,
    required this.actionType,
    required this.estimatedImpact,
  });
}

enum ActionType { discount, experience, loyalty, activation }

class LoyaltyAnalysis {
  final Restaurant restaurant;
  final List<CustomerSegment> customerSegments;
  final List<RetentionOpportunity> retentionOpportunities;
  final List<PersonalizedAction> personalizedActions;
  
  LoyaltyAnalysis({
    required this.restaurant,
    required this.customerSegments,
    required this.retentionOpportunities,
    required this.personalizedActions,
  });
}
