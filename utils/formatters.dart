import 'package:intl/intl.dart';

class Formatters {
  // Formatação de data
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 7) {
      return DateFormat('dd/MM/yyyy').format(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m atrás';
    } else {
      return 'Agora';
    }
  }
  
  // Formatação de data completa
  static String formatFullDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }
  
  // Formatação de data relativa
  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'ano' : 'anos'} atrás';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'mês' : 'meses'} atrás';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m atrás';
    } else {
      return 'Agora';
    }
  }
  
  // Formatação de moeda
  static String formatCurrency(double value) {
    return NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    ).format(value);
  }
  
  // Formatação de número
  static String formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
  
  // Formatação de rating
  static String formatRating(double rating) {
    return rating.toStringAsFixed(1);
  }
  
  // Formatação de telefone
  static String formatPhone(String phone) {
    // Remove caracteres não numéricos
    final numbers = phone.replaceAll(RegExp(r'[^\d]'), '');
    
    if (numbers.length == 11) {
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 7)}-${numbers.substring(7)}';
    } else if (numbers.length == 10) {
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 6)}-${numbers.substring(6)}';
    }
    
    return phone;
  }
  
  // Formatação de CPF/CNPJ
  static String formatDocument(String document) {
    final numbers = document.replaceAll(RegExp(r'[^\d]'), '');
    
    if (numbers.length == 11) {
      // CPF
      return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6, 9)}-${numbers.substring(9)}';
    } else if (numbers.length == 14) {
      // CNPJ
      return '${numbers.substring(0, 2)}.${numbers.substring(2, 5)}.${numbers.substring(5, 8)}/${numbers.substring(8, 12)}-${numbers.substring(12)}';
    }
    
    return document;
  }
  
  // Formatação de endereço
  static String formatAddress(String address) {
    // Capitaliza primeira letra de cada palavra
    return address.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
  
  // Formatação de nome
  static String formatName(String name) {
    return name.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
  
  // Formatação de email
  static String formatEmail(String email) {
    return email.toLowerCase().trim();
  }
  
  // Formatação de tempo de cozimento
  static String formatCookingTime(int minutes) {
    if (minutes < 60) {
      return '${minutes}min';
    } else {
      final hours = minutes ~/ 60;
      final remainingMinutes = minutes % 60;
      if (remainingMinutes == 0) {
        return '${hours}h';
      } else {
        return '${hours}h ${remainingMinutes}min';
      }
    }
  }
  
  // Formatação de distância
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toInt()}m';
    } else {
      return '${(meters / 1000).toStringAsFixed(1)}km';
    }
  }
  
  // Formatação de horário
  static String formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
  
  // Formatação de duração
  static String formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}min';
    } else {
      return '${duration.inMinutes}min';
    }
  }
}
