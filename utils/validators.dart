class Validators {
  // Validação de email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    
    return null;
  }
  
  // Validação de senha
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    
    if (value.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }
    
    if (value.length > 50) {
      return 'Senha deve ter no máximo 50 caracteres';
    }
    
    return null;
  }
  
  // Validação de confirmação de senha
  static String? validatePasswordConfirmation(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }
    
    if (value != password) {
      return 'Senhas não coincidem';
    }
    
    return null;
  }
  
  // Validação de nome
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }
    
    if (value.length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }
    
    if (value.length > 100) {
      return 'Nome deve ter no máximo 100 caracteres';
    }
    
    // Verifica se contém apenas letras, espaços e acentos
    final nameRegex = RegExp(r'^[a-zA-ZÀ-ÿ\s]+$');
    if (!nameRegex.hasMatch(value)) {
      return 'Nome deve conter apenas letras';
    }
    
    return null;
  }
  
  // Validação de telefone
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefone é obrigatório';
    }
    
    // Remove caracteres não numéricos para validação
    final numbers = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (numbers.length < 10 || numbers.length > 11) {
      return 'Telefone deve ter 10 ou 11 dígitos';
    }
    
    return null;
  }
  
  // Validação de endereço
  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) {
      return 'Endereço é obrigatório';
    }
    
    if (value.length < 10) {
      return 'Endereço deve ter pelo menos 10 caracteres';
    }
    
    if (value.length > 200) {
      return 'Endereço deve ter no máximo 200 caracteres';
    }
    
    return null;
  }
  
  // Validação de CPF
  static String? validateCPF(String? value) {
    if (value == null || value.isEmpty) {
      return 'CPF é obrigatório';
    }
    
    // Remove caracteres não numéricos
    final numbers = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (numbers.length != 11) {
      return 'CPF deve ter 11 dígitos';
    }
    
    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1{10}$').hasMatch(numbers)) {
      return 'CPF inválido';
    }
    
    // Validação dos dígitos verificadores
    int sum = 0;
    for (int i = 0; i < 9; i++) {
      sum += int.parse(numbers[i]) * (10 - i);
    }
    int remainder = sum % 11;
    int digit1 = remainder < 2 ? 0 : 11 - remainder;
    
    if (int.parse(numbers[9]) != digit1) {
      return 'CPF inválido';
    }
    
    sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += int.parse(numbers[i]) * (11 - i);
    }
    remainder = sum % 11;
    int digit2 = remainder < 2 ? 0 : 11 - remainder;
    
    if (int.parse(numbers[10]) != digit2) {
      return 'CPF inválido';
    }
    
    return null;
  }
  
  // Validação de CNPJ
  static String? validateCNPJ(String? value) {
    if (value == null || value.isEmpty) {
      return 'CNPJ é obrigatório';
    }
    
    // Remove caracteres não numéricos
    final numbers = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (numbers.length != 14) {
      return 'CNPJ deve ter 14 dígitos';
    }
    
    // Verifica se todos os dígitos são iguais
    if (RegExp(r'^(\d)\1{13}$').hasMatch(numbers)) {
      return 'CNPJ inválido';
    }
    
    // Validação dos dígitos verificadores
    int sum = 0;
    int weight = 2;
    
    for (int i = 11; i >= 0; i--) {
      sum += int.parse(numbers[i]) * weight;
      weight = weight == 9 ? 2 : weight + 1;
    }
    
    int remainder = sum % 11;
    int digit1 = remainder < 2 ? 0 : 11 - remainder;
    
    if (int.parse(numbers[12]) != digit1) {
      return 'CNPJ inválido';
    }
    
    sum = 0;
    weight = 2;
    
    for (int i = 12; i >= 0; i--) {
      sum += int.parse(numbers[i]) * weight;
      weight = weight == 9 ? 2 : weight + 1;
    }
    
    remainder = sum % 11;
    int digit2 = remainder < 2 ? 0 : 11 - remainder;
    
    if (int.parse(numbers[13]) != digit2) {
      return 'CNPJ inválido';
    }
    
    return null;
  }
  
  // Validação de rating
  static String? validateRating(double? value) {
    if (value == null) {
      return 'Avaliação é obrigatória';
    }
    
    if (value < 1 || value > 5) {
      return 'Avaliação deve estar entre 1 e 5';
    }
    
    return null;
  }
  
  // Validação de comentário
  static String? validateComment(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Comentário é opcional
    }
    
    if (value.length > 500) {
      return 'Comentário deve ter no máximo 500 caracteres';
    }
    
    return null;
  }
  
  // Validação de nome do produto
  static String? validateProductName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome do produto é obrigatório';
    }
    
    if (value.length < 2) {
      return 'Nome do produto deve ter pelo menos 2 caracteres';
    }
    
    if (value.length > 100) {
      return 'Nome do produto deve ter no máximo 100 caracteres';
    }
    
    return null;
  }
  
  // Validação de preço
  static String? validatePrice(double? value) {
    if (value == null) {
      return 'Preço é obrigatório';
    }
    
    if (value < 0) {
      return 'Preço não pode ser negativo';
    }
    
    if (value > 10000) {
      return 'Preço não pode ser maior que R\$ 10.000,00';
    }
    
    return null;
  }
  
  // Validação de URL
  static String? validateURL(String? value) {
    if (value == null || value.isEmpty) {
      return null; // URL é opcional
    }
    
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$'
    );
    
    if (!urlRegex.hasMatch(value)) {
      return 'URL inválida';
    }
    
    return null;
  }
  
  // Validação de código postal (CEP)
  static String? validateCEP(String? value) {
    if (value == null || value.isEmpty) {
      return 'CEP é obrigatório';
    }
    
    // Remove caracteres não numéricos
    final numbers = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (numbers.length != 8) {
      return 'CEP deve ter 8 dígitos';
    }
    
    return null;
  }
  
  // Validação de número de celular
  static String? validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Número de celular é obrigatório';
    }
    
    // Remove caracteres não numéricos
    final numbers = value.replaceAll(RegExp(r'[^\d]'), '');
    
    if (numbers.length != 11) {
      return 'Número de celular deve ter 11 dígitos';
    }
    
    // Verifica se começa com 9 (celular)
    if (numbers[2] != '9') {
      return 'Número de celular deve começar com 9';
    }
    
    return null;
  }
}
