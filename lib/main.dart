import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nexora/core/constants.dart';
import 'package:nexora/core/theme.dart';
import 'package:nexora/providers/theme_provider.dart';
import 'package:nexora/core/router.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool(AppConstants.themeKey) ?? false;

  runApp(
    ProviderScope(
      overrides: [
        themeProvider.overrideWith(
          (ref) => ThemeNotifier(isDarkMode),
        ),
      ],
      child: const NexoraApp(),
    ),
  );
}

class NexoraApp extends ConsumerWidget {
  const NexoraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
