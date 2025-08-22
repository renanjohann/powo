import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/providers.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header do post
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF6C63FF),
                  child: post.authorImage != null
                      ? ClipOval(
                          child: Image.network(
                            post.authorImage!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Text(
                                post.authorName[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        )
                      : Text(
                          post.authorName[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
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
                        post.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _formatDate(post.createdAt),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    _handleMenuAction(context, value);
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'share',
                      child: Row(
                        children: [
                          Icon(Icons.share),
                          SizedBox(width: 8),
                          Text('Compartilhar'),
                        ],
                      ),
                    ),
                    if (post.authorType == 'user')
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Informações do restaurante/produto
            if (post.restaurantName != null || post.productName != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      post.productName != null ? Icons.restaurant : Icons.store,
                      color: const Color(0xFF6C63FF),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (post.restaurantName != null)
                            Text(
                              post.restaurantName!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          if (post.productName != null)
                            Text(
                              post.productName!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Avaliação
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    index < post.rating.floor()
                        ? Icons.star
                        : index < post.rating
                            ? Icons.star_half
                            : Icons.star_border,
                    color: Colors.orange,
                    size: 20,
                  );
                }),
                const SizedBox(width: 8),
                Text(
                  post.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Comentário
            if (post.comment != null && post.comment!.isNotEmpty)
              Text(
                post.comment!,
                style: const TextStyle(fontSize: 16),
              ),
            
            const SizedBox(height: 16),
            
            // Imagem (se houver)
            if (post.image != null)
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(post.image!),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            
            const SizedBox(height: 16),
            
            // Ações do post
            Row(
              children: [
                _buildActionButton(
                  icon: post.likes.isNotEmpty ? Icons.favorite : Icons.favorite_border,
                  label: '${post.likes.length}',
                  color: post.likes.isNotEmpty ? Colors.red : null,
                  onTap: () => _handleLike(context),
                ),
                const SizedBox(width: 24),
                _buildActionButton(
                  icon: Icons.comment,
                  label: '${post.comments.length}',
                  onTap: () => _handleComment(context),
                ),
                const Spacer(),
                _buildActionButton(
                  icon: Icons.share,
                  label: 'Compartilhar',
                  onTap: () => _handleShare(context),
                ),
              ],
            ),
            
            // Comentários (se houver)
            if (post.comments.isNotEmpty) ...[
              const Divider(height: 32),
              const Text(
                'Comentários',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              ...post.comments.take(3).map((comment) => _buildCommentItem(comment)),
              if (post.comments.length > 3)
                TextButton(
                  onPressed: () => _handleComment(context),
                  child: Text('Ver todos os ${post.comments.length} comentários'),
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color? color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color ?? Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: color ?? Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentItem(Comment comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFF6C63FF),
            child: comment.authorImage != null
                ? ClipOval(
                    child: Image.network(
                      comment.authorImage!,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Text(
                          comment.authorName[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  )
                : Text(
                    comment.authorName[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.authorName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  comment.content,
                  style: const TextStyle(fontSize: 14),
                ),
                Text(
                  _formatDate(comment.createdAt),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m atrás';
    } else {
      return 'Agora';
    }
  }

  void _handleLike(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final currentUserId = authProvider.currentUser?.id ?? authProvider.currentRestaurant?.id;
    
    if (currentUserId != null) {
      context.read<PostProvider>().likePost(post.id, currentUserId);
    }
  }

  void _handleComment(BuildContext context) {
    // Mostrar modal de comentário
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _CommentModal(post: post),
    );
  }

  void _handleShare(BuildContext context) {
    // Implementar compartilhamento
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Funcionalidade de compartilhamento em desenvolvimento')),
    );
  }

  void _handleMenuAction(BuildContext context, String value) {
    switch (value) {
      case 'share':
        _handleShare(context);
        break;
      case 'edit':
        // Implementar edição
        break;
    }
  }
}

class _CommentModal extends StatefulWidget {
  final Post post;

  const _CommentModal({required this.post});

  @override
  State<_CommentModal> createState() => _CommentModalState();
}

class _CommentModalState extends State<_CommentModal> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Comentar em "${widget.post.restaurantName ?? widget.post.authorName}"',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                hintText: 'Digite seu comentário...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _submitComment,
                  child: const Text('Comentar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitComment() {
    if (_commentController.text.trim().isEmpty) return;

    final authProvider = context.read<AuthProvider>();
    final currentUserId = authProvider.currentUser?.id ?? authProvider.currentRestaurant?.id;
    final currentUserName = authProvider.currentUser?.name ?? authProvider.currentRestaurant?.name;
    
    if (currentUserId != null && currentUserName != null) {
      final comment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        authorId: currentUserId,
        authorName: currentUserName,
        content: _commentController.text.trim(),
        createdAt: DateTime.now(),
      );

      context.read<PostProvider>().addComment(widget.post.id, comment);
      Navigator.pop(context);
      _commentController.clear();
    }
  }
}
