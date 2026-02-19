import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'core/providers/task_provider.dart';
import 'core/providers/user_provider.dart';
import 'features/dashboard/today_screen.dart';
import 'features/task_entry/task_entry_screen.dart';
import 'features/review/review_screen.dart';
import 'features/task_detail/task_detail_screen.dart';

void main() {
  runApp(const PlanPartnerApp());
}

class PlanPartnerApp extends StatelessWidget {
  const PlanPartnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const TodayScreen()),
        GoRoute(
          path: '/entry',
          builder: (context, state) => const TaskEntryScreen(),
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
