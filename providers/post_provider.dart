import 'package:flutter/foundation.dart';
import '../models/models.dart';

class PostProvider with ChangeNotifier {
  final List<Post> _posts = [];
  bool _isLoading = false;

  List<Post> get posts => List.unmodifiable(_posts);
  bool get isLoading => _isLoading;

  PostProvider() {
    _initializeMockPosts();
  }

  void _initializeMockPosts() {
    // Posts mock para teste
    if (_posts.isEmpty) {
      _posts.addAll([
        Post(
          id: '1',
          authorId: '1',
          authorName: 'João Silva',
          authorType: 'user',
          restaurantId: '1',
          restaurantName: 'Restaurante Exemplo',
          rating: 4.5,
          comment: 'Excelente comida! Recomendo muito.',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        Post(
          id: '2',
          authorId: '1',
          authorName: 'Restaurante Exemplo',
          authorType: 'restaurant',
          restaurantId: '1',
          rating: 4.8,
          comment: 'Novo prato da casa: Risoto de Funghi!',
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ]);
    }
  }

  Future<bool> createPost({
    required String authorId,
    required String authorName,
    String? authorImage,
    String? authorType,
    String? restaurantId,
    String? productId,
    String? productName,
    String? restaurantName,
    required double rating,
    String? comment,
    String? image,
    bool isPublic = true,
  }) async {
    _setLoading(true);
    
    try {
      // Simulação de delay de rede
      await Future.delayed(const Duration(seconds: 1));
      
      final newPost = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        authorId: authorId,
        authorName: authorName,
        authorImage: authorImage,
        authorType: authorType,
        restaurantId: restaurantId,
        productId: productId,
        productName: productName,
        restaurantName: restaurantName,
        rating: rating,
        comment: comment,
        image: image,
        createdAt: DateTime.now(),
        isPublic: isPublic,
      );

      _posts.insert(0, newPost);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> likePost(String postId, String userId) async {
    try {
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex == -1) return false;

      final post = _posts[postIndex];
      final likes = List<String>.from(post.likes);
      
      if (likes.contains(userId)) {
        likes.remove(userId);
      } else {
        likes.add(userId);
      }

      _posts[postIndex] = post.copyWith(likes: likes);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addComment(String postId, Comment comment) async {
    try {
      final postIndex = _posts.indexWhere((post) => post.id == postId);
      if (postIndex == -1) return false;

      final post = _posts[postIndex];
      final comments = List<Comment>.from(post.comments);
      comments.add(comment);

      _posts[postIndex] = post.copyWith(comments: comments);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  List<Post> getPostsByRestaurant(String restaurantId) {
    return _posts.where((post) => post.restaurantId == restaurantId).toList();
  }

  List<Post> getPostsByUser(String userId) {
    return _posts.where((post) => post.authorId == userId).toList();
  }

  List<Post> getPublicPosts() {
    return _posts.where((post) => post.isPublic).toList();
  }

  // Método para adicionar post diretamente (usado pela tela de avaliação)
  void addPost(Post post) {
    _posts.insert(0, post);
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Método para limpar posts (útil para logout)
  void clearPosts() {
    _posts.clear();
    notifyListeners();
  }
}
