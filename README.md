# POWO - Aplicativo de Avaliação de Restaurantes e Produtos

## 📱 Sobre o Projeto

POWO é um aplicativo móvel desenvolvido em Flutter que permite aos usuários avaliar restaurantes e produtos, além de fornecer uma plataforma para restaurantes gerenciarem suas avaliações e produtos.

## ✨ Funcionalidades Principais

### Para Usuários
- **Cadastro e Login**: Sistema de autenticação completo
- **Feed Principal**: Visualização de avaliações de outros usuários e restaurantes
- **Avaliações**: Sistema de rating de 1 a 5 estrelas com comentários
- **Rankings**: Lista de restaurantes ordenados por avaliação
- **Perfil Pessoal**: Histórico de avaliações e estatísticas
- **Pesquisa**: Busca por restaurantes e produtos

### Para Restaurantes
- **Cadastro e Login**: Área específica para estabelecimentos
- **Gestão de Produtos**: Adição e edição de produtos
- **Feed do Restaurante**: Visualização de avaliações recebidas
- **Estatísticas**: Métricas de performance e avaliações
- **Perfil do Estabelecimento**: Informações e produtos em destaque

## 🏗️ Arquitetura do Projeto

```
lib/
├── models/           # Modelos de dados
│   ├── user.dart
│   ├── restaurant.dart
│   ├── post.dart
│   └── models.dart
├── providers/        # Gerenciamento de estado
│   ├── auth_provider.dart
│   ├── post_provider.dart
│   └── providers.dart
├── screens/          # Telas da aplicação
│   ├── onboarding_screen.dart
│   ├── user_auth_screen.dart
│   ├── restaurant_auth_screen.dart
│   ├── home_screen.dart
│   └── screens.dart
├── widgets/          # Widgets reutilizáveis
│   ├── post_card.dart
│   ├── restaurant_card.dart
│   └── widgets.dart
├── app_router.dart   # Sistema de roteamento
└── main.dart         # Ponto de entrada da aplicação
```

## 🚀 Tecnologias Utilizadas

- **Flutter**: Framework de desenvolvimento móvel
- **Dart**: Linguagem de programação
- **Provider**: Gerenciamento de estado
- **GoRouter**: Navegação e roteamento
- **SharedPreferences**: Armazenamento local
- **Material Design 3**: Design system

## 📋 Pré-requisitos

- Flutter SDK 3.9.0 ou superior
- Dart SDK 3.9.0 ou superior
- Android Studio / VS Code
- Emulador Android ou dispositivo físico

## 🛠️ Instalação e Configuração

1. **Clone o repositório**
   ```bash
   git clone <url-do-repositorio>
   cd powo_app
   ```

2. **Instale as dependências**
   ```bash
   flutter pub get
   ```

3. **Execute o aplicativo**
   ```bash
   flutter run
   ```

## 📱 Fluxo de Navegação

```
Onboarding → Escolha do Tipo → Autenticação → Home
    ↓              ↓              ↓           ↓
[Entrar ou    [Usuário ou    [Login/      [Feed, Rankings,
 Cadastrar]    Restaurante]   Cadastro]    Pesquisa, Perfil]
```

## 🎨 Design System

### Cores Principais
- **Primária**: `#6C63FF` (Roxo)
- **Secundária**: `#3F3D56` (Azul escuro)
- **Acentos**: Laranja para estrelas, Verde para restaurantes

### Componentes
- Cards com bordas arredondadas (16px)
- Botões com cantos arredondados (12px)
- Campos de texto com preenchimento e bordas focadas
- Ícones consistentes do Material Design

## 🔧 Funcionalidades Implementadas

### ✅ MVP Completo
- [x] Sistema de autenticação (usuário e restaurante)
- [x] Onboarding com escolha de tipo
- [x] Feed principal com posts
- [x] Sistema de avaliações (1-5 estrelas)
- [x] Comentários em posts
- [x] Sistema de curtidas
- [x] Rankings de restaurantes
- [x] Perfis de usuário e restaurante
- [x] Navegação inferior com 4 abas
- [x] Design responsivo e moderno
- [x] Gerenciamento de estado com Provider
- [x] Roteamento com GoRouter
- [x] Armazenamento local com SharedPreferences

### 🚧 Funcionalidades Futuras
- [ ] Upload de imagens
- [ ] Notificações push
- [ ] Chat entre usuários
- [ ] Sistema de seguidores
- [ ] Filtros avançados de busca
- [ ] Integração com APIs externas
- [ ] Modo offline
- [ ] Temas claro/escuro

## 📊 Estrutura de Dados

### Usuário
- ID, nome, email, foto de perfil
- Lista de restaurantes seguidos
- Lista de seguidores

### Restaurante
- ID, nome, endereço, contato, foto
- Lista de produtos
- Avaliação média e total de avaliações

### Post
- Autor (usuário ou restaurante)
- Avaliação (1-5 estrelas)
- Comentário opcional
- Imagem opcional
- Lista de curtidas e comentários
- Referência ao restaurante/produto

## 🔐 Segurança

- Validação de formulários
- Armazenamento seguro de credenciais
- Controle de acesso baseado em tipo de usuário
- Redirecionamento automático para usuários não autenticados

## 📱 Compatibilidade

- **Android**: API 21+ (Android 5.0+)
- **iOS**: iOS 11.0+
- **Web**: Chrome, Firefox, Safari, Edge

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 👥 Autores

- **Desenvolvedor**: [Seu Nome]
- **Design**: [Designer]
- **Testes**: [QA]

## 📞 Suporte

Para suporte e dúvidas:
- Email: [seu-email@exemplo.com]
- Issues: [GitHub Issues]
- Documentação: [Link para documentação]

## 🎯 Roadmap

### Versão 1.1 (Próxima)
- [ ] Sistema de notificações
- [ ] Melhorias na UI/UX
- [ ] Testes automatizados

### Versão 1.2
- [ ] Integração com redes sociais
- [ ] Sistema de recompensas
- [ ] Analytics avançados

### Versão 2.0
- [ ] PWA (Progressive Web App)
- [ ] API REST completa
- [ ] Sistema de pagamentos

---

**POWO** - Transformando a experiência gastronômica através da tecnologia! 🍽️✨
