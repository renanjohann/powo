import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../models/models.dart';

class EvaluationScreen extends StatefulWidget {
  const EvaluationScreen({super.key});

  @override
  State<EvaluationScreen> createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _restaurantController = TextEditingController();
  final _productController = TextEditingController();
  final _commentController = TextEditingController();
  
  double _rating = 0.0;
  bool _isLoading = false;
  List<Restaurant> _searchResults = [];
  Restaurant? _selectedRestaurant;
  bool _isSearching = false;

  @override
  void dispose() {
    _restaurantController.dispose();
    _productController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Avaliação'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seletor de Restaurante
              _buildRestaurantSelector(),
              const SizedBox(height: 24),
              
              // Campo de Produto
              _buildProductField(),
              const SizedBox(height: 24),
              
              // Sistema de Rating
              _buildRatingSection(),
              const SizedBox(height: 24),
              
              // Campo de Comentário
              _buildCommentField(),
              const SizedBox(height: 32),
              
              // Botão de Envio
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRestaurantSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Restaurante',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _restaurantController,
          decoration: InputDecoration(
            hintText: 'Digite o nome do restaurante',
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
                : null,
          ),
          onChanged: _onRestaurantSearch,
          validator: (value) {
            if (_selectedRestaurant == null) {
              return 'Selecione um restaurante';
            }
            return null;
          },
        ),
        if (_searchResults.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final restaurant = _searchResults[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF6C63FF),
                    child: Text(
                      restaurant.name[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(restaurant.name),
                  subtitle: Text(restaurant.address),
                  onTap: () => _selectRestaurant(restaurant),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildProductField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Produto/Prato',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _productController,
          decoration: const InputDecoration(
            hintText: 'Nome do produto ou prato avaliado',
            prefixIcon: Icon(Icons.restaurant),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Digite o nome do produto';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Avaliação',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _rating = index + 1.0;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    size: 40,
                    color: index < _rating
                        ? const Color(0xFFFFD700)
                        : Colors.grey[400],
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: Text(
            _rating > 0 ? '${_rating.toInt()}/5 estrelas' : 'Toque para avaliar',
            style: TextStyle(
              fontSize: 16,
              color: _rating > 0 ? const Color(0xFF6C63FF) : Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Comentário (opcional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _commentController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Compartilhe sua experiência...',
            prefixIcon: Icon(Icons.comment),
            alignLabelWithHint: true,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _submitEvaluation,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Text(
                'Enviar Avaliação',
                style: TextStyle(fontSize: 16),
              ),
      ),
    );
  }

  void _onRestaurantSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _selectedRestaurant = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Simular busca
    await Future.delayed(const Duration(milliseconds: 500));
    
    final authProvider = context.read<AuthProvider>();
    final restaurants = authProvider.restaurants;
    
    final results = restaurants.where((restaurant) {
      return restaurant.name.toLowerCase().contains(query.toLowerCase()) ||
             restaurant.address.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      _searchResults = results;
      _isSearching = false;
    });
  }

  void _selectRestaurant(Restaurant restaurant) {
    setState(() {
      _selectedRestaurant = restaurant;
      _restaurantController.text = restaurant.name;
      _searchResults = [];
    });
  }

  Future<void> _submitEvaluation() async {
    if (!_formKey.currentState!.validate() || _rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos obrigatórios'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simular envio
      await Future.delayed(const Duration(seconds: 2));
      
      // Criar post
      final post = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        authorId: context.read<AuthProvider>().currentUser?.id ?? '',
        authorName: context.read<AuthProvider>().currentUser?.name ?? 'Usuário',
        restaurantId: _selectedRestaurant!.id,
        productName: _productController.text.trim(),
        rating: _rating,
        comment: _commentController.text.trim(),
        createdAt: DateTime.now(),
      );

      // Adicionar ao provider
      context.read<PostProvider>().addPost(post);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Avaliação enviada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar avaliação: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
