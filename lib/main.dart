import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/providers/icon_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/typography_provider.dart';
import 'core/routes/app_router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => TypographyProvider()),
        ChangeNotifierProvider(create: (_) => IconProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: context.watch<ThemeProvider>().themeData,
      routerConfig: AppRouter.router,
    );
  }
}
