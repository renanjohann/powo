import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_router.dart';
import 'providers/providers.dart';
import 'utils/app_config.dart';

void main() {
  runApp(const PowoApp());
}

class PowoApp extends StatelessWidget {
  const PowoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
      ],
      child: MaterialApp.router(
        title: 'POWO',
        debugShowCheckedModeBanner: false,
        theme: AppConfig.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
