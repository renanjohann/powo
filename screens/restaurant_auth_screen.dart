import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';

class RestaurantAuthScreen extends StatefulWidget {
  const RestaurantAuthScreen({super.key});

  @override
  State<RestaurantAuthScreen> createState() => _RestaurantAuthScreenState();
}

class _RestaurantAuthScreenState extends State<RestaurantAuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();
  
  // Controllers para login
  final _loginContactController = TextEditingController();
  final _loginPasswordController = TextEditingController();
  
  // Controllers para cadastro
  final _registerNameController = TextEditingController();
  final _registerAddressController = TextEditingController();
  final _registerContactController = TextEditingController();
  
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginContactController.dispose();
    _loginPasswordController.dispose();
    _registerNameController.dispose();
    _registerAddressController.dispose();
    _registerContactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POWO - Restaurante'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Column(
        children: [
          // Header com logo
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(
                  Icons.store,
                  size: 60,
                  color: Color(0xFF6C63FF),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Área do Restaurante',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3F3D56),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Entre ou crie sua conta para gerenciar',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          // Tabs
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: const Color(0xFF6C63FF),
                borderRadius: BorderRadius.circular(12),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
              tabs: const [
                Tab(text: 'Entrar'),
                Tab(text: 'Cadastrar'),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Conteúdo das tabs
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildLoginTab(),
                _buildRegisterTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _loginFormKey,
        child: Column(
          children: [
            _buildTextField(
              controller: _loginContactController,
              label: 'Contato (Telefone/E-mail)',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira seu contato';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _loginPasswordController,
              label: 'Senha',
              icon: Icons.lock,
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira sua senha';
                }
                if (value.length < 6) {
                  return 'A senha deve ter pelo menos 6 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            _buildActionButton(
              text: 'Entrar',
              onPressed: _handleLogin,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Para o MVP, vamos usar dados mock
                _loginContactController.text = '(11) 99999-9999';
                _loginPasswordController.text = '123456';
              },
              child: const Text('Usar dados de teste'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterTab() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _registerFormKey,
        child: Column(
          children: [
            _buildTextField(
              controller: _registerNameController,
              label: 'Nome do Restaurante',
              icon: Icons.store,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o nome do restaurante';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _registerAddressController,
              label: 'Endereço',
              icon: Icons.location_on,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o endereço';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTextField(
              controller: _registerContactController,
              label: 'Contato (Telefone/E-mail)',
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o contato';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            _buildActionButton(
              text: 'Cadastrar',
              onPressed: _handleRegister,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6C63FF), width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: authProvider.isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6C63FF),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: authProvider.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Future<void> _handleLogin() async {
    if (!_loginFormKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.loginRestaurant(
      _loginContactController.text,
      _loginPasswordController.text,
    );

    if (success && mounted) {
      context.go('/home');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao fazer login. Verifique suas credenciais.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _handleRegister() async {
    if (!_registerFormKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.registerRestaurant(
      _registerNameController.text,
      _registerAddressController.text,
      _registerContactController.text,
    );

    if (success && mounted) {
      context.go('/home');
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao fazer cadastro. Tente novamente.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
