import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/app_theme.dart';
import 'config/go_router_config.dart';

// flutter run -d chrome --web-browser-flag "--disable-web-security"

void main() {
  runApp(
      const ProviderScope( // Wrap app in ProviderScope
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp.router(
        debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme, // Apply Global Theme
        routerConfig: GoRouterConfig.goRouter,
        title: 'Flutter Web App',
    );
  }
}



