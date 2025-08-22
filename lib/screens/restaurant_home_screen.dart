import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../utils/app_config.dart';
import 'restaurant_dashboard.dart';
import 'restaurant_analytics_screen.dart';

class RestaurantHomeScreen extends StatefulWidget {
  const RestaurantHomeScreen({super.key});

  @override
  State<RestaurantHomeScreen> createState() => _RestaurantHomeScreenState();
}

class _RestaurantHomeScreenState extends State<RestaurantHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const RestaurantDashboard(),
    const RestaurantProductsScreen(),
    const RestaurantReviewsScreen(),
    const RestaurantAnalyticsScreen(),
    const RestaurantSettingsScreen(),
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
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.dashboard, 'Dashboard'),
                _buildNavItem(1, Icons.restaurant_menu, 'Produtos'),
                _buildNavItem(2, Icons.reviews, 'Avaliações'),
                _buildNavItem(3, Icons.analytics, 'Analytics'),
                _buildNavItem(4, Icons.business, 'Perfil'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppConfig.primaryColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected 
                  ? AppConfig.primaryColor 
                  : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected 
                    ? AppConfig.primaryColor 
                    : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Screens temporárias (serão implementadas depois)
class RestaurantProductsScreen extends StatelessWidget {
  const RestaurantProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Produtos'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Gestão de Produtos',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Adicione, edite e gerencie seu cardápio',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class RestaurantReviewsScreen extends StatelessWidget {
  const RestaurantReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestão de Avaliações'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer2<AuthProvider, PostProvider>(
        builder: (context, authProvider, postProvider, child) {
          final restaurant = authProvider.currentRestaurant;
          final reviews = postProvider.posts.where(
            (post) => post.restaurantId == restaurant?.id,
          ).toList();

          if (reviews.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.reviews, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Nenhuma avaliação ainda',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'As avaliações dos clientes aparecerão aqui',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              final review = reviews[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppConfig.primaryColor.withOpacity(0.1),
                            child: Text(
                              review.authorName.substring(0, 1).toUpperCase(),
                              style: TextStyle(
                                color: AppConfig.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.authorName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  children: List.generate(5, (starIndex) => Icon(
                                    starIndex < review.rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.orange,
                                    size: 16,
                                  )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (review.comment != null && review.comment!.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(review.comment!),
                      ],
                      if (review.productName != null) ...[
                        const SizedBox(height: 8),
                        Chip(
                          label: Text(review.productName!),
                          backgroundColor: AppConfig.primaryColor.withOpacity(0.1),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Removido - agora usa a tela real de analytics

class RestaurantSettingsScreen extends StatelessWidget {
  const RestaurantSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do Restaurante'),
        backgroundColor: AppConfig.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          final restaurant = authProvider.currentRestaurant;
          
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Informações Básicas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.restaurant),
                          title: const Text('Nome'),
                          subtitle: Text(restaurant?.name ?? 'Meu Restaurante'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.location_on),
                          title: const Text('Endereço'),
                          subtitle: Text(restaurant?.address ?? 'Endereço não informado'),
                        ),
                        ListTile(
                          leading: const Icon(Icons.phone),
                          title: const Text('Contato'),
                          subtitle: Text(restaurant?.contact ?? 'Contato não informado'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.edit, color: Colors.blue),
                    title: const Text('Editar Perfil'),
                    subtitle: const Text('Atualize as informações do seu restaurante'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Implementar edição de perfil
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.settings, color: Colors.grey),
                    title: const Text('Configurações'),
                    subtitle: const Text('Ajustar preferências e notificações'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Implementar configurações
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.help, color: Colors.orange),
                    title: const Text('Ajuda'),
                    subtitle: const Text('FAQ e suporte técnico'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Implementar ajuda
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
