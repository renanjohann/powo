import '../models/models.dart';

class PowoScoreCalculator {
  static const double _baseRatingWeight = 0.6;
  static const double _reviewCountWeight = 0.2;
  static const double _userLevelWeight = 0.15;
  static const double _sentimentWeight = 0.05;

  /// Calcula o POWO Score de um prato (0-10)
  static double calculateDishScore(Product product, List<Post> reviews) {
    if (reviews.isEmpty) return 0.0;

    double baseScore = _calculateBaseRatingScore(product.averageRating);
    double reviewCountScore = _calculateReviewCountScore(reviews.length);
    double userLevelScore = _calculateUserLevelScore(reviews);
    double sentimentScore = _calculateSentimentScore(reviews);

    double finalScore = (baseScore * _baseRatingWeight) +
                       (reviewCountScore * _reviewCountWeight) +
                       (userLevelScore * _userLevelWeight) +
                       (sentimentScore * _sentimentWeight);

    return double.parse(finalScore.toStringAsFixed(1));
  }

  /// Calcula o POWO Score de um restaurante (0-10)
  static double calculateRestaurantScore(Restaurant restaurant, List<Post> reviews) {
    if (reviews.isEmpty) return 0.0;

    double baseScore = _calculateBaseRatingScore(restaurant.averageRating);
    double reviewCountScore = _calculateReviewCountScore(reviews.length);
    double userLevelScore = _calculateUserLevelScore(reviews);
    double productVarietyScore = _calculateProductVarietyScore(restaurant.products);

    double finalScore = (baseScore * _baseRatingWeight) +
                       (reviewCountScore * _reviewCountWeight) +
                       (userLevelScore * _userLevelWeight) +
                       (productVarietyScore * _sentimentWeight);

    return double.parse(finalScore.toStringAsFixed(1));
  }

  /// Score baseado na avaliação média (0-10)
  static double _calculateBaseRatingScore(double averageRating) {
    return averageRating * 2; // Converte de 0-5 para 0-10
  }

  /// Score baseado no número de avaliações
  static double _calculateReviewCountScore(int reviewCount) {
    if (reviewCount >= 100) return 10.0;
    if (reviewCount >= 50) return 8.0;
    if (reviewCount >= 25) return 6.0;
    if (reviewCount >= 10) return 4.0;
    if (reviewCount >= 5) return 2.0;
    return 0.0;
  }

  /// Score baseado no nível dos usuários que avaliaram
  static double _calculateUserLevelScore(List<Post> reviews) {
    if (reviews.isEmpty) return 0.0;

    double totalUserLevel = 0;
    for (var review in reviews) {
      // Simulando o nível do usuário baseado no ID (para MVP)
      totalUserLevel += _getUserLevel(review.authorId.length);
    }

    double averageUserLevel = totalUserLevel / reviews.length;
    return (averageUserLevel / 10) * 10; // Normaliza para 0-10
  }

  /// Score baseado na variedade de produtos
  static double _calculateProductVarietyScore(List<Product> products) {
    if (products.isEmpty) return 0.0;
    
    // Simulando categorias baseadas no nome do produto (para MVP)
    int uniqueCategories = products.map((p) => _getProductCategory(p.name)).toSet().length;
    
    if (uniqueCategories >= 8) return 10.0;
    if (uniqueCategories >= 6) return 8.0;
    if (uniqueCategories >= 4) return 6.0;
    if (uniqueCategories >= 2) return 4.0;
    return 2.0;
  }

  /// Determina a categoria do produto baseada no nome (para MVP)
  static String _getProductCategory(String productName) {
    String lowerName = productName.toLowerCase();
    
    if (lowerName.contains('pizza') || lowerName.contains('massa')) return 'Pizza';
    if (lowerName.contains('hambúrguer') || lowerName.contains('burger')) return 'Hambúrguer';
    if (lowerName.contains('sushi') || lowerName.contains('japonês')) return 'Sushi';
    if (lowerName.contains('café') || lowerName.contains('cafe')) return 'Café';
    if (lowerName.contains('bebida') || lowerName.contains('drink')) return 'Bebida';
    if (lowerName.contains('sobremesa') || lowerName.contains('doce')) return 'Sobremesa';
    if (lowerName.contains('salada')) return 'Salada';
    if (lowerName.contains('sopa')) return 'Sopa';
    
    return 'Outros';
  }

  /// Score baseado na análise de sentimento dos comentários
  static double _calculateSentimentScore(List<Post> reviews) {
    if (reviews.isEmpty) return 0.0;

    double positiveScore = 0;
    double totalComments = 0;

    for (var review in reviews) {
      if (review.comment != null && review.comment!.isNotEmpty) {
        totalComments++;
        positiveScore += _analyzeSentiment(review.comment!);
      }
    }

    if (totalComments == 0) return 5.0; // Score neutro se não há comentários

    double averageSentiment = positiveScore / totalComments;
    return (averageSentiment + 1) * 5; // Converte de -1 a 1 para 0 a 10
  }

  /// Análise simples de sentimento baseada em palavras-chave
  static double _analyzeSentiment(String comment) {
    String lowerComment = comment.toLowerCase();
    
    List<String> positiveWords = [
      'delicioso', 'excelente', 'ótimo', 'maravilhoso', 'perfeito',
      'incrível', 'fantástico', 'saboroso', 'gostoso', 'bom',
      'recomendo', 'vale a pena', 'surpreendente', 'espetacular'
    ];
    
    List<String> negativeWords = [
      'ruim', 'péssimo', 'horrível', 'terrível', 'disgusting',
      'não gostei', 'decepcionante', 'fraco', 'sem sabor', 'caro'
    ];

    int positiveCount = positiveWords.where((word) => lowerComment.contains(word)).length;
    int negativeCount = negativeWords.where((word) => lowerComment.contains(word)).length;

    if (positiveCount == 0 && negativeCount == 0) return 0.0;
    
    double sentiment = (positiveCount - negativeCount) / (positiveCount + negativeCount);
    return sentiment.clamp(-1.0, 1.0);
  }

  /// Calcula o nível do usuário baseado no número de avaliações
  static int _getUserLevel(int totalReviews) {
    if (totalReviews >= 100) return 10; // Mestre
    if (totalReviews >= 75) return 9;   // Expert
    if (totalReviews >= 50) return 8;   // Avançado
    if (totalReviews >= 30) return 7;   // Intermediário
    if (totalReviews >= 20) return 6;   // Regular
    if (totalReviews >= 10) return 5;   // Iniciante
    if (totalReviews >= 5) return 4;    // Novato
    if (totalReviews >= 2) return 3;    // Primeiros passos
    if (totalReviews >= 1) return 2;    // Debutante
    return 1; // Iniciante
  }

  /// Retorna o selo de qualidade baseado no POWO Score
  static String getQualityBadge(double powoScore) {
    if (powoScore >= 9.5) return '🏆 Excelência POWO';
    if (powoScore >= 9.0) return '⭐ Premium POWO';
    if (powoScore >= 8.5) return '✨ Recomendado POWO';
    if (powoScore >= 8.0) return '👍 Bom POWO';
    if (powoScore >= 7.0) return '✅ Aprovado POWO';
    if (powoScore >= 6.0) return '🆗 Regular POWO';
    return '📝 Em avaliação';
  }

  /// Retorna a cor do selo baseado no POWO Score
  static int getQualityBadgeColor(double powoScore) {
    if (powoScore >= 9.5) return 0xFFFFD700; // Dourado
    if (powoScore >= 9.0) return 0xFFC0C0C0; // Prata
    if (powoScore >= 8.5) return 0xFFCD7F32; // Bronze
    if (powoScore >= 8.0) return 0xFF4CAF50; // Verde
    if (powoScore >= 7.0) return 0xFF2196F3; // Azul
    if (powoScore >= 6.0) return 0xFFFF9800; // Laranja
    return 0xFF9E9E9E; // Cinza
  }
}
