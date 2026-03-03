import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/task_provider.dart';
import 'core/providers/user_provider.dart';
import 'features/home/home_screen.dart';
import 'features/welcome/welcome_screen.dart';
import 'features/task_entry/task_entry_screen.dart';
import 'features/review/review_screen.dart';
import 'features/task_detail/task_detail_screen.dart';

const _seenWelcomeKey = 'seen_welcome_screen';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (_) {}
  bool hasSeenWelcome = false;
  try {
    final prefs = await SharedPreferences.getInstance();
    hasSeenWelcome = prefs.getBool(_seenWelcomeKey) ?? false;
  } catch (_) {
    hasSeenWelcome = false;
  }
  runApp(PlanPartnerApp(hasSeenWelcome: hasSeenWelcome));
}

class PlanPartnerApp extends StatelessWidget {
  final bool hasSeenWelcome;
  const PlanPartnerApp({required this.hasSeenWelcome, super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: hasSeenWelcome ? '/home' : '/welcome',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              hasSeenWelcome ? const HomeScreen() : const WelcomeScreen(),
        ),
        GoRoute(
          path: '/welcome',
          builder: (context, state) => const WelcomeScreen(),
        ),
        GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
        GoRoute(
          path: '/entry',
          builder: (context, state) => const TaskEntryScreen(),
        ),
        GoRoute(
          path: '/entry/:id',
          builder: (context, state) =>
              TaskEntryScreen(taskId: state.pathParameters['id']),
        ),
        GoRoute(
          path: '/review',
          builder: (context, state) => const ReviewScreen(),
        ),
        GoRoute(
          path: '/detail/:id',
          builder: (context, state) =>
              TaskDetailScreen(id: state.pathParameters['id']!),
        ),
      ],
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp.router(
        title: 'Plan Partner',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF4DB8A8),
            brightness: Brightness.light,
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFF4DB8A8),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: const Color(0xFF4DB8A8),
            foregroundColor: Colors.white,
          ),
        ),
        routerConfig: router,
      ),
    );
  }
}
