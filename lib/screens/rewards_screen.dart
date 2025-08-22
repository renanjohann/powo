import 'package:flutter/material.dart';
import '../utils/app_config.dart';
import '../models/gastronomic_journey.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _powoCoins = 1250;
  int _fidelityCoins = 208;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
        title: const Text('Recompensas'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Seção de resumo dos pontos
          _buildPointsSummary(),
          
          // Botões de ação
          _buildActionButtons(),
          
          // Tabs de recompensas
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppConfig.primaryColor,
                borderRadius: BorderRadius.circular(25),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
              tabs: const [
                Tab(text: 'Disponíveis'),
                Tab(text: 'Jornadas'),
                Tab(text: 'Histórico'),
              ],
            ),
          ),
          
          // Conteúdo das tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAvailableRewards(),
                _buildGastronomicJourneys(),
                _buildRewardsHistory(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsSummary() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Row(
        children: [
          // POWO Coins
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFFB74D),
                    const Color(0xFFFFCC02),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFB74D).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: Colors.white,
                        size: 24,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.trending_up,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '+50 hoje',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _powoCoins.toString(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'POWO Coins',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Fidelity Coins
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFE91E63),
                    const Color(0xFF9C27B0),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE91E63).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 24,
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '4 locais',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _fidelityCoins.toString(),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Fidelity Coins',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
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

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                _showHowToEarnDialog(context);
              },
              icon: const Icon(Icons.emoji_events),
              label: const Text('Como Ganhar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConfig.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                _showMissionsDialog(context);
              },
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Missões'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConfig.accentColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableRewards() {
    final List<Map<String, dynamic>> rewards = [
      {
        'title': '15% OFF',
        'description': 'Em qualquer pedido acima de R\$ 30',
        'validUntil': '14/03',
        'cost': 500,
        'image': '🍖',
        'type': 'discount',
      },
      {
        'title': 'Frete Grátis',
        'description': 'Para qualquer restaurante da região',
        'validUntil': '19/03',
        'cost': 300,
        'image': '🚚',
        'type': 'shipping',
      },
      {
        'title': '2x Pontos',
        'description': 'Dobrar pontos na próxima avaliação',
        'validUntil': '25/03',
        'cost': 200,
        'image': '⭐',
        'type': 'bonus',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        final reward = rewards[index];
        final canRedeem = _powoCoins >= (reward['cost'] as int);
        
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Imagem da recompensa
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getRewardColor(reward['type'] as String).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                                          child: Text(
                        reward['image'] as String,
                        style: const TextStyle(fontSize: 24),
                      ),
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Informações da recompensa
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                                              Text(
                          reward['title'] as String,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C2C2C),
                          ),
                        ),
                      const SizedBox(height: 4),
                                              Text(
                          reward['description'] as String,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                                                      Icon(
                              _getRewardIcon(reward['type'] as String),
                              size: 16,
                              color: Colors.grey[600],
                            ),
                          const SizedBox(width: 4),
                                                  Text(
                          'Válido até ${reward['validUntil'] as String}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(width: 16),
                
                // Custo e botão
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          reward['cost'].toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: canRedeem ? AppConfig.primaryColor : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.monetization_on,
                          size: 18,
                          color: canRedeem ? AppConfig.primaryColor : Colors.grey,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: canRedeem ? () => _redeemReward(reward) : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canRedeem ? AppConfig.primaryColor : Colors.grey[300],
                        foregroundColor: canRedeem ? Colors.white : Colors.grey[600],
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        canRedeem ? 'Resgatar' : 'Insuficiente',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGastronomicJourneys() {
    final journeys = JourneyManager.getAvailableJourneys();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: journeys.length,
      itemBuilder: (context, index) {
        final journey = journeys[index];
        return _buildJourneyCard(journey);
      },
    );
  }

  Widget _buildJourneyCard(GastronomicJourney journey) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: journey.themeColor.withOpacity(0.3),
          width: 2,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            journey.themeColor.withOpacity(0.05),
            journey.themeColor.withOpacity(0.1),
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showJourneyDetails(journey),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: journey.themeColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        journey.icon,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            journey.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C2C2C),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            journey.description,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: journey.difficultyColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        journey.difficultyText,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: journey.difficultyColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${journey.targetCount} pratos',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${journey.powoCoinsReward} coins',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${journey.timeLimitDays} dias',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'POWO Score ${journey.minPowoScore}+',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: journey.themeColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showJourneyDetails(GastronomicJourney journey) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: journey.themeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      journey.icon,
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    journey.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    journey.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  _buildJourneyStats(journey),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Jornada "${journey.title}" iniciada!'),
                            backgroundColor: AppConfig.primaryColor,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: journey.themeColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Iniciar Jornada',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJourneyStats(GastronomicJourney journey) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            'Dificuldade',
            journey.difficultyText,
            Icons.trending_up,
            journey.difficultyColor,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            'Meta',
            '${journey.targetCount} pratos',
            Icons.flag,
            Colors.orange,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            'Prazo',
            '${journey.timeLimitDays} dias',
            Icons.schedule,
            Colors.blue,
          ),
        ),
        Expanded(
          child: _buildStatItem(
            'Recompensa',
            '${journey.powoCoinsReward} coins',
            Icons.monetization_on,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRewardsHistory() {
    final List<Map<String, dynamic>> history = [
      {
        'title': '10% OFF Pizza',
        'date': '10/03/2024',
        'status': 'Utilizado',
        'type': 'discount',
      },
      {
        'title': 'Frete Grátis',
        'date': '05/03/2024',
        'status': 'Expirado',
        'type': 'shipping',
      },
      {
        'title': '2x Pontos',
        'date': '01/03/2024',
        'status': 'Utilizado',
        'type': 'bonus',
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getRewardColor(item['type'] as String).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
                              child: Icon(
                  _getRewardIcon(item['type'] as String),
                  color: _getRewardColor(item['type'] as String),
                  size: 20,
                ),
            ),
            title: Text(
              item['title'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: Text(
              'Utilizado em ${item['date'] as String}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _getStatusColor(item['status'] as String),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                item['status'] as String,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getRewardColor(String? type) {
    switch (type) {
      case 'discount':
        return AppConfig.primaryColor;
      case 'shipping':
        return AppConfig.successColor;
      case 'bonus':
        return AppConfig.accentColor;
      default:
        return Colors.grey;
    }
  }

  IconData _getRewardIcon(String? type) {
    switch (type) {
      case 'discount':
        return Icons.local_offer;
      case 'shipping':
        return Icons.local_shipping;
      case 'bonus':
        return Icons.star;
      default:
        return Icons.card_giftcard;
    }
  }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'Utilizado':
        return AppConfig.successColor;
      case 'Expirado':
        return AppConfig.errorColor;
      default:
        return Colors.grey;
    }
  }

  void _redeemReward(Map<String, dynamic> reward) {
    setState(() {
      _powoCoins -= (reward['cost'] as int);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${reward['title']} resgatado com sucesso!'),
        backgroundColor: AppConfig.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sobre as Recompensas'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• POWO Coins: Ganhe avaliando restaurantes e produtos'),
            SizedBox(height: 8),
            Text('• Fidelity Coins: Acumule visitando os mesmos lugares'),
            SizedBox(height: 8),
            Text('• Resgate descontos, frete grátis e bônus especiais'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendi'),
          ),
        ],
      ),
    );
  }

  void _showHowToEarnDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Como Ganhar Pontos'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🏆 Avaliar restaurantes: +50 pontos'),
            SizedBox(height: 8),
            Text('📸 Fazer upload de fotos: +25 pontos'),
            SizedBox(height: 8),
            Text('💬 Comentar avaliações: +15 pontos'),
            SizedBox(height: 8),
            Text('📍 Visitar novos lugares: +100 pontos'),
            SizedBox(height: 8),
            Text('⭐ Avaliações detalhadas: +75 pontos'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Vou começar!'),
          ),
        ],
      ),
    );
  }

  void _showMissionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Missões Disponíveis'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🎯 Missão Diária: Avaliar 1 restaurante'),
            SizedBox(height: 8),
            Text('🔥 Missão Semanal: Visitar 5 lugares novos'),
            SizedBox(height: 8),
            Text('🌟 Missão Mensal: 20 avaliações completas'),
            SizedBox(height: 8),
            Text('💎 Missão Especial: Primeira foto de prato'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Aceitar'),
          ),
        ],
      ),
    );
  }
}
