import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'providers/providers.dart';
import 'screens/screens.dart';
import 'screens/restaurant_home_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // Rota inicial - Splash Screen
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Rota de onboarding
      GoRoute(
        path: '/',
        builder: (context, state) => const OnboardingScreen(),
      ),
      
      // Rotas de autenticação
      GoRoute(
        path: '/auth/user',
        builder: (context, state) => const UserAuthScreen(),
      ),
      
      GoRoute(
        path: '/auth/restaurant',
        builder: (context, state) => const RestaurantAuthScreen(),
      ),
      
      // Rota principal - Home (requer autenticação)
      GoRoute(
        path: '/home',
        builder: (context, state) {
          // Determina qual tela mostrar baseado no tipo de usuário
          return Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.currentRestaurant != null) {
                // Usuário é um restaurante
                return const RestaurantHomeScreen();
              } else {
                // Usuário é um cliente
                return const HomeScreen();
              }
            },
          );
        },
        redirect: (context, state) {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          if (!authProvider.isAuthenticated) {
            return '/';
          }
          return null;
        },
      ),

      // Rota de avaliação (requer autenticação)
      GoRoute(
        path: '/evaluate',
        builder: (context, state) => const EvaluationScreen(),
        redirect: (context, state) {
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          if (!authProvider.isAuthenticated) {
            return '/';
          }
          return null;
        },
      ),

              // Rota do perfil do restaurante (requer autenticação)
        GoRoute(
          path: '/restaurant/:id',
          builder: (context, state) {
            final restaurantId = state.pathParameters['id']!;
            return RestaurantProfileScreen(restaurantId: restaurantId);
          },
          redirect: (context, state) {
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            if (!authProvider.isAuthenticated) {
              return '/';
            }
            return null;
          },
        ),

        // Rota de busca (requer autenticação)
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
          redirect: (context, state) {
            final authProvider = Provider.of<AuthProvider>(context, listen: false);
            if (!authProvider.isAuthenticated) {
              return '/';
            }
            return null;
          },
        ),
    ],
    
    // Redirecionamento baseado no estado de autenticação
    redirect: (context, state) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isAuthenticated = authProvider.isAuthenticated;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');
      // Se não está autenticado e não está em rota de auth, ir para onboarding
      if (!isAuthenticated && !isAuthRoute) {
        return '/';
      }
      
      // Se está autenticado e está em rota de auth, ir para home
      if (isAuthenticated && isAuthRoute) {
        return '/home';
      }
      
      // Se está autenticado e está na rota inicial, ir para home
      if (isAuthenticated && state.matchedLocation == '/') {
        return '/home';
      }
      
      return null;
    },
    
    // Tratamento de erros
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Página não encontrada',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'A rota "${state.matchedLocation}" não existe',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Voltar ao início'),
            ),
          ],
        ),
      ),
    ),
  );
}
