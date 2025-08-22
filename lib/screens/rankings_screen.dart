import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import '../utils/app_config.dart';

class RankingsScreen extends StatefulWidget {
  const RankingsScreen({super.key});

  @override
  State<RankingsScreen> createState() => _RankingsScreenState();
}

class _RankingsScreenState extends State<RankingsScreen> {
  String _selectedCategory = 'Geral';
  String _selectedRankingType = 'Melhor Nota';
  String _selectedScope = 'Região';

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Geral', 'icon': '🏆', 'color': AppConfig.primaryColor},
    {'name': 'Hambúrguer', 'icon': '🍔', 'color': Colors.orange},
    {'name': 'Pizza', 'icon': '🍕', 'color': Colors.red},
    {'name': 'Japonesa', 'icon': '🍱', 'color': Colors.pink},
    {'name': 'Vegetariana', 'icon': '🥗', 'color': Colors.green},
    {'name': 'Saudável', 'icon': '🥬', 'color': Colors.lightGreen},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header com título e filtros
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppConfig.primaryColor.withOpacity(0.1),
                      AppConfig.accentColor.withOpacity(0.1),
                    ],
                  ),
                ),
                                 child: SafeArea(
                   child: Padding(
                     padding: const EdgeInsets.all(16),
                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.center,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Row(
                           children: [
                             Container(
                               padding: const EdgeInsets.all(8),
                               decoration: BoxDecoration(
                                 color: AppConfig.primaryColor,
                                 borderRadius: BorderRadius.circular(12),
                               ),
                               child: const Icon(
                                 Icons.emoji_events,
                                 color: Colors.white,
                                 size: 24,
                               ),
                             ),
                             const SizedBox(width: 12),
                             const Expanded(
                               child: Column(
                                 crossAxisAlignment: CrossAxisAlignment.start,
                                 children: [
                                   Text(
                                     'Rankings',
                                     style: TextStyle(
                                       fontSize: 24,
                                       fontWeight: FontWeight.bold,
                                       color: Color(0xFF2C2C2C),
                                     ),
                                   ),
                                   Text(
                                     'Os melhores da sua região',
                                     style: TextStyle(
                                       fontSize: 14,
                                       color: Colors.grey,
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ],
                         ),
                       ],
                     ),
                   ),
                 ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    // Filtros de escopo
                    Row(
                      children: [
                        Expanded(
                          child: _buildScopeFilter(
                            'Região',
                            Icons.my_location,
                            _selectedScope == 'Região',
                            () => setState(() => _selectedScope = 'Região'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildScopeFilter(
                            'Cidade',
                            Icons.location_city,
                            _selectedScope == 'Cidade',
                            () => setState(() => _selectedScope = 'Cidade'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Filtros de tipo
                    Row(
                      children: [
                        Expanded(
                          child: _buildTypeFilter(
                            'Pratos',
                            Icons.restaurant_menu,
                            _selectedRankingType == 'Melhor Nota',
                            () => setState(() => _selectedRankingType = 'Melhor Nota'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTypeFilter(
                            'Restaurantes',
                            Icons.store,
                            _selectedRankingType == 'Mais Pedidos',
                            () => setState(() => _selectedRankingType = 'Mais Pedidos'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Seção de categorias
          SliverToBoxAdapter(
            child: _buildCategoriesSection(),
          ),

          // Seção de tipo de ranking
          SliverToBoxAdapter(
            child: _buildRankingTypeSection(),
          ),

          // Lista de rankings
          SliverToBoxAdapter(
            child: _buildRankingsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildScopeFilter(String title, IconData icon, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppConfig.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppConfig.primaryColor : Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppConfig.primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeFilter(String title, IconData icon, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppConfig.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? AppConfig.primaryColor : Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppConfig.primaryColor.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.grey[600],
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categoria',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.2,
            ),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category['name'];
              
              return GestureDetector(
                onTap: () => setState(() => _selectedCategory = category['name']),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? category['color'] : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? category['color'] : Colors.grey[300]!,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category['icon'],
                        style: TextStyle(
                          fontSize: isSelected ? 32 : 28,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['name'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : const Color(0xFF2C2C2C),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRankingTypeSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tipo de Ranking',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildRankingTypeButton(
                  'Melhor Nota',
                  Icons.star,
                  _selectedRankingType == 'Melhor Nota',
                  AppConfig.primaryColor,
                  () => setState(() => _selectedRankingType = 'Melhor Nota'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildRankingTypeButton(
                  'Mais Pedidos',
                  Icons.local_fire_department,
                  _selectedRankingType == 'Mais Pedidos',
                  Colors.orange,
                  () => setState(() => _selectedRankingType = 'Mais Pedidos'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankingTypeButton(String title, IconData icon, bool isSelected, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF2C2C2C),
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingsList() {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final restaurants = authProvider.restaurants;
        
        if (restaurants.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(32),
            child: const Center(
              child: Column(
                children: [
                  Icon(Icons.emoji_events, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Nenhum ranking disponível',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        // Simular ranking baseado na seleção
        List<Restaurant> rankedRestaurants = List.from(restaurants);
        if (_selectedRankingType == 'Melhor Nota') {
          rankedRestaurants.sort((a, b) => b.averageRating.compareTo(a.averageRating));
        } else {
          rankedRestaurants.sort((a, b) => b.totalReviews.compareTo(a.totalReviews));
        }

        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '$_selectedCategory - $_selectedRankingType',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppConfig.primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _selectedScope,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rankedRestaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = rankedRestaurants[index];
                  final rank = index + 1;
                  
                  return _buildRankingItem(restaurant, rank);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRankingItem(Restaurant restaurant, int rank) {
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
            // Posição do ranking
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getRankColor(rank),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  rank.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Imagem do restaurante
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [
                    AppConfig.primaryColor.withOpacity(0.8),
                    AppConfig.accentColor.withOpacity(0.8),
                  ],
                ),
              ),
              child: restaurant.image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        restaurant.image!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    )
                  : const Icon(
                      Icons.store,
                      color: Colors.white,
                      size: 30,
                    ),
            ),
            
            const SizedBox(width: 16),
            
            // Informações do restaurante
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C2C2C),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.address,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Medalha de ranking
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _getRankColor(rank).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.emoji_events,
                color: _getRankColor(rank),
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Ouro
      case 2:
        return const Color(0xFFC0C0C0); // Prata
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return AppConfig.primaryColor;
    }
  }
}
