import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import '../utils/app_config.dart';
import '../widgets/restaurant_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  List<Restaurant> _searchResults = [];
  bool _isSearching = false;
  String _lastQuery = '';
  String _selectedCategory = 'Todos';
  double _minRating = 0;
  double _maxDistance = 50;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Todos', 'icon': '🍽️'},
    {'name': 'Pizza', 'icon': '🍕'},
    {'name': 'Burger', 'icon': '🍔'},
    {'name': 'Sushi', 'icon': '🍣'},
    {'name': 'Doces', 'icon': '🍰'},
    {'name': 'Bebidas', 'icon': '🥤'},
    {'name': 'Vegetariano', 'icon': '🥗'},
    {'name': 'Brasileiro', 'icon': '🇧🇷'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header de busca
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppConfig.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppConfig.primaryColor,
                      AppConfig.primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.search,
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
                                    'Buscar',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    'Encontre o que você procura',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
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
              preferredSize: const Size.fromHeight(80),
              child: Container(
                padding: const EdgeInsets.all(16),
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
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        ),
                        onChanged: _onSearchChanged,
                        onSubmitted: _onSearchSubmitted,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppConfig.primaryColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.tune, color: Colors.white),
                        onPressed: () => _showFiltersBottomSheet(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Categorias rápidas
          SliverToBoxAdapter(
            child: _buildQuickCategories(),
          ),

          // Tabs de busca
          SliverToBoxAdapter(
            child: Container(
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
                  Tab(text: 'Restaurantes'),
                  Tab(text: 'Produtos'),
                ],
              ),
            ),
          ),

          // Resultados da busca
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRestaurantResults(),
                _buildProductResults(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickCategories() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Categorias',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C2C2C),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category['name'];
                
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category['name'] as String;
                    });
                    _performSearch(_searchController.text);
                  },
                  child: Container(
                    width: 80,
                    margin: const EdgeInsets.only(right: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? AppConfig.primaryColor 
                                : Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected 
                                  ? AppConfig.primaryColor 
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              category['icon'] as String,
                              style: TextStyle(
                                fontSize: isSelected ? 28 : 24,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          category['name'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: isSelected 
                                ? AppConfig.primaryColor 
                                : const Color(0xFF2C2C2C),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestaurantResults() {
    if (_searchController.text.isEmpty && _selectedCategory == 'Todos') {
      return _buildEmptyState();
    }

    if (_isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Buscando restaurantes...'),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return _buildNoResultsState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final restaurant = _searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: RestaurantCard(restaurant: restaurant),
        );
      },
    );
  }

  Widget _buildProductResults() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Busca por produtos',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Em desenvolvimento',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 80, color: Colors.grey),
          SizedBox(height: 24),
          Text(
            'Encontre os melhores restaurantes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Use a barra de pesquisa ou escolha uma categoria',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Nenhum resultado encontrado',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tente outros termos de busca',
            style: TextStyle(color: Colors.grey),
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

  void _onSearchChanged(String query) {
    if (query.trim().isEmpty) {
      _clearSearch();
      return;
    }

    // Debounce para evitar muitas buscas
    Future.delayed(const Duration(milliseconds: 500), () {
      if (query == _searchController.text) {
        _performSearch(query);
      }
    });
  }

  void _onSearchSubmitted(String query) {
    _performSearch(query);
  }

  Future<void> _performSearch(String query) async {
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
        // Filtro por categoria
        bool categoryMatch = _selectedCategory == 'Todos' || 
            restaurant.name.toLowerCase().contains(_selectedCategory.toLowerCase()) ||
            restaurant.products.any((product) => 
                product.name.toLowerCase().contains(_selectedCategory.toLowerCase()));

        // Filtro por avaliação
        bool ratingMatch = restaurant.averageRating >= _minRating;

        // Filtro por busca
        bool searchMatch = query.trim().isEmpty || 
            restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
            restaurant.address.toLowerCase().contains(query.toLowerCase()) ||
            restaurant.products.any((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()));

        return categoryMatch && ratingMatch && searchMatch;
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
      _selectedCategory = 'Todos';
    });
  }

  void _showFiltersBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
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
              // Handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Filtros de Busca',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Filtro de avaliação
                      const Text(
                        'Avaliação Mínima',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _minRating,
                              min: 0,
                              max: 5,
                              divisions: 10,
                              activeColor: AppConfig.primaryColor,
                              label: '${_minRating.toStringAsFixed(1)} ⭐',
                              onChanged: (value) {
                                setModalState(() {
                                  _minRating = value;
                                });
                              },
                            ),
                          ),
                          Text(
                            '${_minRating.toStringAsFixed(1)} ⭐',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Filtro de distância
                      const Text(
                        'Distância Máxima',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Slider(
                              value: _maxDistance,
                              min: 1,
                              max: 100,
                              divisions: 20,
                              activeColor: AppConfig.primaryColor,
                              label: '${_maxDistance.toInt()} km',
                              onChanged: (value) {
                                setModalState(() {
                                  _maxDistance = value;
                                });
                              },
                            ),
                          ),
                          Text(
                            '${_maxDistance.toInt()} km',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              // Botões de ação
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setModalState(() {
                            _minRating = 0;
                            _maxDistance = 50;
                          });
                        },
                        child: const Text('Limpar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            // Aplicar filtros
                          });
                          Navigator.of(context).pop();
                          _performSearch(_searchController.text);
                        },
                        child: const Text('Aplicar'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
