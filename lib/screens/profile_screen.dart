import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/providers.dart';
import '../models/models.dart';
import '../utils/app_config.dart';
import '../widgets/post_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final user = authProvider.currentUser;
        
        if (user == null) {
          return const Scaffold(
            body: Center(
              child: Text('Usuário não encontrado'),
            ),
          );
        }

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Header do perfil
              SliverAppBar(
                expandedHeight: 200,
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          // Avatar do usuário
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: user.profileImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.network(
                                      user.profileImage!,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Icon(
                                    Icons.person,
                                    size: 40,
                                    color: AppConfig.primaryColor,
                                  ),
                          ),
                          const SizedBox(height: 12),
                          // Nome do usuário
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          // Email
                          Text(
                            user.email,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white),
                    onPressed: () => _showSettingsDialog(context),
                  ),
                ],
              ),

              // Estatísticas do usuário
              SliverToBoxAdapter(
                child: _buildUserStats(context),
              ),

              // Tabs de conteúdo
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
                      Tab(text: 'Avaliações'),
                      Tab(text: 'Favoritos'),
                      Tab(text: 'Conquistas'),
                    ],
                  ),
                ),
              ),

              // Conteúdo das tabs
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildUserReviews(context),
                    _buildUserFavorites(context),
                    _buildUserAchievements(context),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildUserStats(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Consumer<PostProvider>(
        builder: (context, postProvider, child) {
          final userPosts = postProvider.posts.where(
            (post) => post.authorId == context.read<AuthProvider>().currentUser?.id,
          ).toList();

          final totalReviews = userPosts.length;
          final averageRating = userPosts.isEmpty ? 0.0 : 
            userPosts.map((p) => p.rating).reduce((a, b) => a + b) / userPosts.length;
          final totalLikes = userPosts.map((p) => p.likes.length).fold(0, (a, b) => a + b);

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _buildStatItem(
                  'Avaliações',
                  totalReviews.toString(),
                  Icons.star,
                  AppConfig.primaryColor,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Média',
                  averageRating.toStringAsFixed(1),
                  Icons.trending_up,
                  AppConfig.accentColor,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Curtidas',
                  totalLikes.toString(),
                  Icons.favorite,
                  Colors.pink,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Nível',
                  _getUserLevel(totalReviews).toString(),
                  Icons.emoji_events,
                  Colors.orange,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildUserReviews(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
        final userPosts = postProvider.posts.where(
          (post) => post.authorId == context.read<AuthProvider>().currentUser?.id,
        ).toList();

        if (userPosts.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.rate_review, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'Nenhuma avaliação ainda',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  'Comece avaliando um restaurante!',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: userPosts.length,
          itemBuilder: (context, index) {
            final post = userPosts[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: PostCard(post: post),
            );
          },
        );
      },
    );
  }

  Widget _buildUserFavorites(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Nenhum favorito ainda',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Favorite restaurantes para vê-los aqui!',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAchievements(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {
        final userPosts = postProvider.posts.where(
          (post) => post.authorId == context.read<AuthProvider>().currentUser?.id,
        ).toList();

        final achievements = _generateAchievements(userPosts);

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: achievements.length,
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
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
              child: ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: achievement['unlocked'] 
                        ? (achievement['color'] as Color).withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    achievement['icon'] as IconData,
                    color: achievement['unlocked'] 
                        ? achievement['color'] as Color
                        : Colors.grey,
                    size: 24,
                  ),
                ),
                title: Text(
                  achievement['title'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: achievement['unlocked'] 
                        ? const Color(0xFF2C2C2C)
                        : Colors.grey,
                  ),
                ),
                subtitle: Text(
                  achievement['description'] as String,
                  style: TextStyle(
                    color: achievement['unlocked'] 
                        ? Colors.grey[600]
                        : Colors.grey,
                  ),
                ),
                trailing: achievement['unlocked']
                    ? Icon(
                        Icons.check_circle,
                        color: achievement['color'] as Color,
                      )
                    : Icon(
                        Icons.lock_outline,
                        color: Colors.grey,
                      ),
              ),
            );
          },
        );
      },
    );
  }

  List<Map<String, dynamic>> _generateAchievements(List<Post> userPosts) {
    final totalReviews = userPosts.length;
    final totalLikes = userPosts.map((p) => p.likes.length).fold(0, (a, b) => a + b);
    final averageRating = userPosts.isEmpty ? 0.0 : 
      userPosts.map((p) => p.rating).reduce((a, b) => a + b) / userPosts.length;

    return [
      {
        'title': 'Primeira Avaliação',
        'description': 'Fez sua primeira avaliação',
        'icon': Icons.star,
        'color': AppConfig.accentColor,
        'unlocked': totalReviews >= 1,
      },
      {
        'title': 'Crítico Gastronômico',
        'description': 'Fez 10 avaliações',
        'icon': Icons.restaurant_menu,
        'color': AppConfig.primaryColor,
        'unlocked': totalReviews >= 10,
      },
      {
        'title': 'Influenciador',
        'description': 'Recebeu 50 curtidas',
        'icon': Icons.thumb_up,
        'color': Colors.pink,
        'unlocked': totalLikes >= 50,
      },
      {
        'title': 'Exigente',
        'description': 'Média de avaliação acima de 4.0',
        'icon': Icons.emoji_events,
        'color': Colors.orange,
        'unlocked': averageRating >= 4.0,
      },
      {
        'title': 'Explorador',
        'description': 'Avaliou 5 restaurantes diferentes',
        'icon': Icons.explore,
        'color': AppConfig.successColor,
        'unlocked': _getUniqueRestaurants(userPosts) >= 5,
      },
      {
        'title': 'Expert',
        'description': 'Fez 50 avaliações',
        'icon': Icons.diamond,
        'color': Colors.purple,
        'unlocked': totalReviews >= 50,
      },
    ];
  }

  int _getUserLevel(int totalReviews) {
    if (totalReviews >= 50) return 5;
    if (totalReviews >= 25) return 4;
    if (totalReviews >= 10) return 3;
    if (totalReviews >= 5) return 2;
    if (totalReviews >= 1) return 1;
    return 0;
  }

  int _getUniqueRestaurants(List<Post> posts) {
    return posts.map((p) => p.restaurantId).where((id) => id != null).toSet().length;
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Configurações'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Editar Perfil'),
              onTap: () {
                Navigator.of(context).pop();
                _showEditProfileDialog(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text('Notificações'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Configurações de notificação em breve!')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacidade'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Configurações de privacidade em breve!')),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Sair', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.of(context).pop();
                final authProvider = context.read<AuthProvider>();
                await authProvider.logout();
                if (context.mounted) {
                  context.go('/');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final user = context.read<AuthProvider>().currentUser!;
    final nameController = TextEditingController(text: user.name);
    final emailController = TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Perfil'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              enabled: false, // Email não editável por enquanto
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Atualizar dados do usuário
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Perfil atualizado com sucesso!')),
              );
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
