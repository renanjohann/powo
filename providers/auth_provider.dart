import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

enum UserType { user, restaurant }

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  Restaurant? _currentRestaurant;
  UserType? _userType;
  bool _isLoading = false;
  bool _isAuthenticated = false;

  User? get currentUser => _currentUser;
  Restaurant? get currentRestaurant => _currentRestaurant;
  UserType? get userType => _userType;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;

  // Simulação de dados em memória para o MVP
  final List<User> _users = [];
  final List<Restaurant> _restaurants = [];

  AuthProvider() {
    _loadStoredAuth();
    _initializeMockData();
  }

  void _initializeMockData() {
    // Dados mock para teste
    if (_users.isEmpty) {
      _users.add(User(
        id: '1',
        name: 'João Silva',
        email: 'joao@email.com',
        createdAt: DateTime.now(),
      ));
    }

    if (_restaurants.isEmpty) {
      _restaurants.add(Restaurant(
        id: '1',
        name: 'Restaurante Exemplo',
        address: 'Rua das Flores, 123',
        contact: '(11) 99999-9999',
        createdAt: DateTime.now(),
      ));
    }
  }

  Future<void> _loadStoredAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userTypeString = prefs.getString('userType');
      final userId = prefs.getString('userId');

      if (userTypeString != null && userId != null) {
        _userType = userTypeString == 'user' ? UserType.user : UserType.restaurant;
        
        if (_userType == UserType.user) {
          _currentUser = _users.firstWhere((user) => user.id == userId);
        } else {
          _currentRestaurant = _restaurants.firstWhere((rest) => rest.id == userId);
        }
        
        _isAuthenticated = true;
        notifyListeners();
      }
    } catch (e) {
      // Log de erro (em produção, usar um sistema de logging apropriado)
      debugPrint('Erro ao carregar autenticação: $e');
    }
  }

  Future<bool> loginUser(String email, String password) async {
    _setLoading(true);
    
    try {
      // Simulação de delay de rede
      await Future.delayed(const Duration(seconds: 1));
      
      final user = _users.firstWhere(
        (u) => u.email == email,
        orElse: () => throw Exception('Usuário não encontrado'),
      );

      _currentUser = user;
      _userType = UserType.user;
      _isAuthenticated = true;

      // Salvar no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userType', 'user');
      await prefs.setString('userId', user.id);

      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      return false;
    }
  }

  Future<bool> loginRestaurant(String email, String password) async {
    _setLoading(true);
    
    try {
      // Simulação de delay de rede
      await Future.delayed(const Duration(seconds: 1));
      
      final restaurant = _restaurants.firstWhere(
        (r) => r.contact == email,
        orElse: () => throw Exception('Restaurante não encontrado'),
      );

      _currentRestaurant = restaurant;
      _userType = UserType.restaurant;
      _isAuthenticated = true;

      // Salvar no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userType', 'restaurant');
      await prefs.setString('userId', restaurant.id);

      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      return false;
    }
  }

  Future<bool> registerUser(String name, String email, String password) async {
    _setLoading(true);
    
    try {
      // Simulação de delay de rede
      await Future.delayed(const Duration(seconds: 1));
      
      // Verificar se email já existe
      if (_users.any((u) => u.email == email)) {
        throw Exception('Email já cadastrado');
      }

      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );

      _users.add(newUser);
      _currentUser = newUser;
      _userType = UserType.user;
      _isAuthenticated = true;

      // Salvar no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userType', 'user');
      await prefs.setString('userId', newUser.id);

      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      return false;
    }
  }

  Future<bool> registerRestaurant(String name, String address, String contact) async {
    _setLoading(true);
    
    try {
      // Simulação de delay de rede
      await Future.delayed(const Duration(seconds: 1));
      
      // Verificar se contato já existe
      if (_restaurants.any((r) => r.contact == contact)) {
        throw Exception('Contato já cadastrado');
      }

      final newRestaurant = Restaurant(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        address: address,
        contact: contact,
        createdAt: DateTime.now(),
      );

      _restaurants.add(newRestaurant);
      _currentRestaurant = newRestaurant;
      _userType = UserType.restaurant;
      _isAuthenticated = true;

      // Salvar no SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userType', 'restaurant');
      await prefs.setString('userId', newRestaurant.id);

      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    _currentRestaurant = null;
    _userType = null;
    _isAuthenticated = false;

    // Limpar SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userType');
    await prefs.remove('userId');

    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Métodos para obter dados mock
  List<User> get users => List.unmodifiable(_users);
  List<Restaurant> get restaurants => List.unmodifiable(_restaurants);
}
