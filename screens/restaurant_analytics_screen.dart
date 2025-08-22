import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import '../utils/app_config.dart';
import '../utils/predictive_analytics.dart';

class RestaurantAnalyticsScreen extends StatefulWidget {
  const RestaurantAnalyticsScreen({super.key});

  @override
  State<RestaurantAnalyticsScreen> createState() => _RestaurantAnalyticsScreenState();
}

class _RestaurantAnalyticsScreenState extends State<RestaurantAnalyticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCategory = 'Hambúrguer';
  String _selectedNeighborhood = 'Vila Madalena';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Avançados'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Tendências'),
            Tab(text: 'Produtos'),
            Tab(text: 'Concorrência'),
            Tab(text: 'Fidelização'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMarketTrendsTab(),
          _buildProductAnalyticsTab(),
          _buildCompetitiveBenchmarkTab(),
          _buildLoyaltyAnalyticsTab(),
        ],
      ),
    );
  }

  // Tab 1: Análise de Tendências de Mercado
  Widget _buildMarketTrendsTab() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final restaurant = authProvider.currentRestaurant;
        if (restaurant == null) return const Center(child: Text('Restaurante não encontrado'));

        final trends = PredictiveAnalytics.analyzeMarketTrends(_selectedNeighborhood, _selectedCategory);

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategorySelector(),
              const SizedBox(height: 24),
              const Text(
                'Tendências de Mercado',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C2C2C),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Análise preditiva para ${_selectedCategory} em $_selectedNeighborhood',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              ...trends.map((trend) => _buildTrendCard(trend)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategorySelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categoria de Análise',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Categoria',
              border: OutlineInputBorder(),
            ),
            items: ['Hambúrguer', 'Pizza', 'Sushi', 'Café', 'Restaurante'].map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _selectedCategory = value);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTrendCard(MarketTrend trend) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: trend.color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: trend.color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: trend.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getTrendIcon(trend.impact),
                  color: trend.color,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trend.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Crescimento: +${trend.searchGrowth}%',
                      style: TextStyle(
                        color: trend.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: trend.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  trend.category,
                  style: TextStyle(
                    color: trend.color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            trend.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: trend.color.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: trend.color.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: trend.color,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    trend.recommendation,
                    style: TextStyle(
                      fontSize: 14,
                      color: trend.color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTrendIcon(TrendImpact impact) {
    switch (impact) {
      case TrendImpact.high:
        return Icons.trending_up;
      case TrendImpact.medium:
        return Icons.trending_flat;
      case TrendImpact.low:
        return Icons.trending_down;
    }
  }

  // Tab 2: Análise Preditiva de Produtos
  Widget _buildProductAnalyticsTab() {
    return Consumer2<AuthProvider, PostProvider>(
      builder: (context, authProvider, postProvider, child) {
        final restaurant = authProvider.currentRestaurant;
        if (restaurant == null) return const Center(child: Text('Restaurante não encontrado'));

        final reviews = postProvider.posts.where((r) => r.restaurantId == restaurant.id).toList();
        final insights = PredictiveAnalytics.analyzeProductPerformance(restaurant, reviews);

        if (insights.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.analytics, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Nenhum produto analisado ainda',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'As análises aparecerão após receber avaliações',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: insights.length,
          itemBuilder: (context, index) {
            final insight = insights[index];
            return _buildProductInsightCard(insight);
          },
        );
      },
    );
  }

  Widget _buildProductInsightCard(ProductInsight insight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppConfig.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: AppConfig.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insight.product.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Rating: ${insight.currentRating.toStringAsFixed(1)}/5.0',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'POWO: ${insight.currentPowoScore.toStringAsFixed(1)}/10',
                          style: TextStyle(
                            color: AppConfig.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Análise de Comentários
          if (insight.commentAnalysis.suggestions.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.orange),
                      const SizedBox(width: 8),
                      const Text(
                        'Sugestões de Melhoria',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...insight.commentAnalysis.suggestions.entries.map((entry) => 
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '• ${entry.key}: ${entry.value} menções',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Previsão de Performance
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.trending_up, color: Colors.blue),
                    const SizedBox(width: 8),
                    const Text(
                      'Previsão de Melhoria',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildPredictionItem(
                        'Atual',
                        insight.performancePrediction.currentRating.toStringAsFixed(1),
                        Colors.grey,
                      ),
                    ),
                    const Icon(Icons.arrow_forward, color: Colors.blue),
                    Expanded(
                      child: _buildPredictionItem(
                        'Previsto',
                        insight.performancePrediction.predictedRating.toStringAsFixed(1),
                        Colors.blue,
                      ),
                    ),
                  ],
                ),
                if (insight.performancePrediction.improvementPotential > 0) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Potencial de melhoria: +${insight.performancePrediction.improvementPotential.toStringAsFixed(1)} pontos',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Tempo estimado: ${insight.performancePrediction.timeToImprovement} dias',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Recomendações
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.green),
                    const SizedBox(width: 8),
                    const Text(
                      'Recomendações',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...insight.recommendations.map((rec) => 
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(color: Colors.green)),
                        Expanded(child: Text(rec)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // Tab 3: Benchmarking Competitivo
  Widget _buildCompetitiveBenchmarkTab() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final restaurant = authProvider.currentRestaurant;
        if (restaurant == null) return const Center(child: Text('Restaurante não encontrado'));

        final benchmark = PredictiveAnalytics.getCompetitiveBenchmark(
          restaurant,
          _selectedCategory,
          _selectedNeighborhood,
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategorySelector(),
              const SizedBox(height: 24),
              const Text(
                'Benchmarking Competitivo',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C2C2C),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Comparação anônima com concorrentes em $_selectedNeighborhood',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              
              // Métricas Comparativas
              _buildComparisonCard(benchmark),
              const SizedBox(height: 24),
              
              // Recomendações Competitivas
              _buildCompetitiveRecommendationsCard(benchmark),
            ],
          ),
        );
      },
    );
  }

  Widget _buildComparisonCard(CompetitiveBenchmark benchmark) {
    final competitorData = benchmark.competitorMetrics;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Métricas Comparativas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          
          Row(
            children: [
              Expanded(
                child: _buildMetricComparison(
                  'Rating',
                  benchmark.restaurant.averageRating.toStringAsFixed(1),
                  (competitorData['averageRating'] as double).toStringAsFixed(1),
                  benchmark.restaurant.averageRating >= (competitorData['averageRating'] as double),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricComparison(
                  'POWO Score',
                  '8.2', // Simulado
                  (competitorData['averagePowoScore'] as double).toStringAsFixed(1),
                  8.2 >= (competitorData['averagePowoScore'] as double),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Outras métricas
          _buildAdditionalMetrics(competitorData),
        ],
      ),
    );
  }

  Widget _buildMetricComparison(String label, String yourValue, String competitorValue, bool isBetter) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isBetter ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isBetter ? Colors.green.withOpacity(0.3) : Colors.orange.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text(
                    'Você',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    yourValue,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isBetter ? Colors.green : Colors.orange,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    'Concorrência',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    competitorValue,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalMetrics(Map<String, dynamic> competitorData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Outras Métricas',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildMetricItem(
                'Faixa de Preço',
                competitorData['priceRange'] as String,
                Icons.attach_money,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMetricItem(
                'Tempo de Entrega',
                competitorData['deliveryTime'] as String,
                Icons.access_time,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildMetricItem(
          'Satisfação do Cliente',
          '${competitorData['customerSatisfaction']}%',
          Icons.sentiment_satisfied,
        ),
      ],
    );
  }

  Widget _buildMetricItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCompetitiveRecommendationsCard(CompetitiveBenchmark benchmark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb, color: Colors.blue),
              const SizedBox(width: 8),
              const Text(
                'Recomendações Competitivas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...benchmark.recommendations.map((rec) => 
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text(rec)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Tab 4: CRM de Fidelização
  Widget _buildLoyaltyAnalyticsTab() {
    return Consumer2<AuthProvider, PostProvider>(
      builder: (context, authProvider, postProvider, child) {
        final restaurant = authProvider.currentRestaurant;
        if (restaurant == null) return const Center(child: Text('Restaurante não encontrado'));

        final reviews = postProvider.posts.where((r) => r.restaurantId == restaurant.id).toList();
        final loyaltyAnalysis = PredictiveAnalytics.analyzeCustomerLoyalty(restaurant, reviews);

        if (loyaltyAnalysis.customerSegments.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Nenhum cliente analisado ainda',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'As análises de fidelização aparecerão após receber avaliações',
                  style: TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Análise de Fidelização',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C2C2C),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Segmentação de clientes e oportunidades de retenção',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              
              // Segmentos de Clientes
              _buildCustomerSegmentsCard(loyaltyAnalysis),
              const SizedBox(height: 24),
              
              // Oportunidades de Retenção
              _buildRetentionOpportunitiesCard(loyaltyAnalysis),
              const SizedBox(height: 24),
              
              // Ações Personalizadas
              _buildPersonalizedActionsCard(loyaltyAnalysis),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomerSegmentsCard(LoyaltyAnalysis analysis) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Segmentos de Clientes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ...analysis.customerSegments.map((segment) => 
            _buildSegmentItem(segment),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentItem(CustomerSegment segment) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: segment.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: segment.color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: segment.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getLoyaltyIcon(segment.type),
              color: segment.color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  segment.description,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: segment.color,
                  ),
                ),
                Text(
                  '${segment.customers.length} cliente(s)',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getLoyaltyIcon(LoyaltyType type) {
    switch (type) {
      case LoyaltyType.vip:
        return Icons.star;
      case LoyaltyType.loyal:
        return Icons.favorite;
      case LoyaltyType.regular:
        return Icons.person;
      case LoyaltyType.occasional:
        return Icons.person_outline;
    }
  }

  Widget _buildRetentionOpportunitiesCard(LoyaltyAnalysis analysis) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up, color: Colors.green),
              const SizedBox(width: 8),
              const Text(
                'Oportunidades de Retenção',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...analysis.retentionOpportunities.map((opportunity) => 
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        opportunity.action,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Impacto: ${opportunity.impact}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    opportunity.description,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalizedActionsCard(LoyaltyAnalysis analysis) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.campaign, color: Colors.purple),
              const SizedBox(width: 8),
              const Text(
                'Ações Personalizadas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...analysis.personalizedActions.map((action) => 
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          action.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Impacto: ${action.estimatedImpact}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.purple,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action.description,
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Segmento: ${action.targetSegment.description}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
