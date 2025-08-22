import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import '../widgets/post_card.dart';
import '../widgets/restaurant_card.dart';
import '../utils/time_based_content.dart';
import '../utils/powo_score_calculator.dart';
import 'rankings_screen.dart';
import 'rewards_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const FeedTab(),
    const RankingsScreen(),
    const RewardsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_outlined, Icons.home, 'Feed'),
                _buildNavItem(1, Icons.emoji_events_outlined, Icons.emoji_events, 'Rankings'),
                _buildCenterNavItem(),
                _buildNavItem(2, Icons.card_giftcard_outlined, Icons.card_giftcard, 'Recompensas'),
                _buildNavItem(3, Icons.person_outline, Icons.person, 'Perfil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlinedIcon, IconData filledIcon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
          setState(() {
            _currentIndex = index;
          });
        },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEA1D2C).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : outlinedIcon,
              color: isSelected ? const Color(0xFFEA1D2C) : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFEA1D2C) : Colors.grey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterNavItem() {
    return GestureDetector(
      onTap: () {
        context.go('/evaluate');
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFEA1D2C), Color(0xFFFF4569)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFEA1D2C).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
          ),
        ],
      ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}

// Tab do Feed
class FeedTab extends StatelessWidget {
  const FeedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header moderno estilo iFood
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: const Color(0xFFEA1D2C),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFEA1D2C), Color(0xFFFF4569)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                                                 Consumer<AuthProvider>(
                                   builder: (context, authProvider, child) {
                                     final user = authProvider.currentUser;
                                     return Text(
                                       '${TimeBasedContent.getGreeting()}, ${user?.name.split(' ').first ?? 'Usuário'}! 👋',
                                       style: const TextStyle(
                                         color: Colors.white,
                                         fontSize: 18,
                                         fontWeight: FontWeight.w600,
                                       ),
                                     );
                                   },
                                 ),
                                 const SizedBox(height: 4),
                                 Text(
                                   TimeBasedContent.getTimeBasedMessage(),
                                   style: const TextStyle(
                                     color: Colors.white70,
                                     fontSize: 14,
                                   ),
                                 ),
                              ],
                            ),
                                                         Row(
                               children: [
                                 IconButton(
                                   icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                                   onPressed: () {
                                     ScaffoldMessenger.of(context).showSnackBar(
                                       const SnackBar(content: Text('Notificações em breve!')),
                                     );
                                   },
                                 ),
                                 IconButton(
                                   icon: const Icon(Icons.logout, color: Colors.white),
                                   onPressed: () async {
                                     final authProvider = context.read<AuthProvider>();
                                     await authProvider.logout();
                                     if (context.mounted) {
                                       context.go('/');
                                     }
                                   },
                                 ),
                               ],
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
              preferredSize: const Size.fromHeight(60),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // Navegar para tela de busca
                          context.go('/search');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.grey[600], size: 20),
                              const SizedBox(width: 12),
                              Text(
                                'Buscar restaurantes...',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEA1D2C),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.tune, color: Colors.white),
                        onPressed: () {
                          // Mostrar filtros
                          _showFiltersBottomSheet(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Conteúdo do feed
          SliverToBoxAdapter(
            child: _buildFeedContent(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedContent(BuildContext context) {
    return Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          if (postProvider.isLoading) {
            return const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final posts = postProvider.getPublicPosts();
          
          if (posts.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(32),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.restaurant, size: 80, color: Colors.grey),
                    SizedBox(height: 24),
                    Text(
                      'Nenhuma avaliação ainda',
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Seja o primeiro a compartilhar sua experiência!',
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seção de categorias (estilo iFood)
              _buildCategoriesSection(context),
              
              // Seção de restaurantes populares
              _buildPopularRestaurantsSection(context),
              
              // Feed de avaliações
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 32, 16, 16),
                child: Text(
                  'Avaliações Recentes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: PostCard(post: post),
                  );
                },
              ),
            ],
          );
        },
      );
  }

  Widget _buildCategoriesSection(BuildContext context) {
    final categoryNames = TimeBasedContent.getTimeBasedCategories();
    final categoryIcons = {
      'Café': '☕',
      'Padaria': '🥐',
      'Sucos': '🥤',
      'Pães': '🥖',
      'Doces': '🍰',
      'Prato do Dia': '🍽️',
      'Marmita': '🍱',
      'Restaurante': '🍴',
      'Saladas': '🥗',
      'Sopas': '🍲',
      'Lanches': '🥪',
      'Sorvetes': '🍦',
      'Promoções': '🎉',
      'Bebidas': '🍺',
      'Petiscos': '🍟',
      'Jantar': '🌙',
      'Hambúrguer': '🍔',
      'Sushi': '🍣',
      'Churrasco': '🥩',
      'Madrugada': '🌙',
      'Pizza': '🍕',
      'Mais': '➕',
    };
    
    final categoryColors = {
      'Café': const Color(0xFF8D6E63),
      'Padaria': const Color(0xFFFFB300),
      'Sucos': const Color(0xFF4CAF50),
      'Pães': const Color(0xFF8D6E63),
      'Doces': const Color(0xFFE91E63),
      'Prato do Dia': const Color(0xFF00C853),
      'Marmita': const Color(0xFF795548),
      'Restaurante': const Color(0xFF607D8B),
      'Saladas': const Color(0xFF4CAF50),
      'Sopas': const Color(0xFFFF9800),
      'Lanches': const Color(0xFFFFB300),
      'Sorvetes': const Color(0xFF2196F3),
      'Promoções': const Color(0xFFE91E63),
      'Bebidas': const Color(0xFF9C27B0),
      'Petiscos': const Color(0xFFFF9800),
      'Jantar': const Color(0xFF673AB7),
      'Hambúrguer': const Color(0xFFFFB300),
      'Sushi': const Color(0xFF00C853),
      'Churrasco': const Color(0xFF795548),
      'Madrugada': const Color(0xFF607D8B),
      'Pizza': const Color(0xFFFF6B35),
      'Mais': const Color(0xFF9C27B0),
    };

    final categories = categoryNames.map((name) => {
      'name': name,
      'icon': categoryIcons[name] ?? '🍽️',
      'color': categoryColors[name] ?? const Color(0xFF607D8B),
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Categorias',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C2C2C),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: TimeBasedContent.getTimeBasedColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: TimeBasedContent.getTimeBasedColor().withOpacity(0.3),
                  ),
                ),
                child: Text(
                  TimeBasedContent.getTimeBasedHighlight(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: TimeBasedContent.getTimeBasedColor(),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Container(
                width: 70,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: (category['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: (category['color'] as Color).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          category['icon'] as String,
                          style: const TextStyle(fontSize: 24),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      category['name'] as String,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPopularRestaurantsSection(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final restaurants = authProvider.restaurants.take(5).toList();
        
        if (restaurants.isEmpty) return const SizedBox.shrink();
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    TimeBasedContent.isHappyHour() 
                        ? 'Happy Hour' 
                        : TimeBasedContent.isLunchTime() 
                            ? 'Almoço' 
                            : TimeBasedContent.isBreakfastTime() 
                                ? 'Café da Manhã' 
                                : 'Populares',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C2C2C),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navegar para aba de rankings
                      DefaultTabController.of(context).animateTo(1);
                    },
                    child: const Text(
                      'Ver todos',
                      style: TextStyle(
                        color: Color(0xFFEA1D2C),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  final restaurant = restaurants[index];
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: InkWell(
                        onTap: () => context.go('/restaurant/${restaurant.id}'),
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    const Color(0xFFEA1D2C).withOpacity(0.8),
                                    const Color(0xFFFF4569).withOpacity(0.8),
                                  ],
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.store,
                                  size: 40,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    restaurant.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Color(0xFFFFB300),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        restaurant.averageRating.toStringAsFixed(1),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${restaurant.totalReviews} avaliações',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFiltersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
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
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Filtros',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  'Filtros em desenvolvimento',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// Tab de Pesquisa
class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final _searchController = TextEditingController();
  List<Restaurant> _searchResults = [];
  bool _isSearching = false;
  String _lastQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesquisar'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Campo de busca
          Padding(
        padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar restaurantes ou produtos...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _isSearching
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _clearSearch();
                            },
                          )
                        : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              onChanged: _onSearchChanged,
              onSubmitted: _onSearchSubmitted,
            ),
          ),
          
          // Resultados da busca
          Expanded(
            child: _buildSearchResults(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    if (_searchController.text.isEmpty) {
      return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'Pesquise por restaurantes',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'ou produtos para avaliar',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
      ),
    );
  }

    if (_isSearching) {
      return const Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Buscando...'),
        ],
      ),
    );
  }

    if (_searchResults.isEmpty) {
      return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
            const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
              'Nenhum resultado encontrado',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
          Text(
              'Tente outros termos de busca',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _clearSearch,
              child: const Text('Limpar Busca'),
          ),
        ],
      ),
    );
  }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final restaurant = _searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: RestaurantCard(restaurant: restaurant),
        );
      },
    );
  }

  void _onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      _clearSearch();
      return;
    }

    // Debounce para evitar muitas buscas
    Future.delayed(const Duration(milliseconds: 300), () {
      if (query == _searchController.text) {
        _performSearch(query);
      }
    });
  }

  void _onSearchSubmitted(String query) {
    _performSearch(query);
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isSearching = true;
      _lastQuery = query;
    });

    try {
      // Simular delay de rede
      await Future.delayed(const Duration(milliseconds: 500));
      
      final authProvider = context.read<AuthProvider>();
      final restaurants = authProvider.restaurants;
      
      final results = restaurants.where((restaurant) {
        final searchQuery = query.toLowerCase();
        return restaurant.name.toLowerCase().contains(searchQuery) ||
               restaurant.address.toLowerCase().contains(searchQuery) ||
               restaurant.products.any((product) =>
                   product.name.toLowerCase().contains(searchQuery));
      }).toList();

      if (mounted && query == _lastQuery) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro na busca: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _clearSearch() {
    setState(() {
      _searchResults = [];
      _isSearching = false;
      _lastQuery = '';
    });
  }
}


