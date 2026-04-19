import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/providers/task_provider.dart';
import 'core/providers/user_provider.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/chat/chat_screen.dart';
import 'features/home/home_screen.dart';
import 'features/privacy/privacy_policy_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/task_entry/task_entry_screen.dart';
import 'features/review/review_screen.dart';
import 'features/task_detail/task_detail_screen.dart';

const _isLoggedInKey = 'is_logged_in';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (_) {}
  bool isLoggedIn = false;
  try {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
  } catch (_) {
    isLoggedIn = false;
  }
  runApp(PlanPartnerApp(isLoggedIn: isLoggedIn));
}

class PlanPartnerApp extends StatelessWidget {
  final bool isLoggedIn;
  const PlanPartnerApp({required this.isLoggedIn, super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: isLoggedIn ? '/home' : '/login',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) =>
              isLoggedIn ? const HomeScreen() : const LoginScreen(),
        ),
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/privacy',
          builder: (context, state) => const PrivacyPolicyScreen(),
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
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(path: '/chat', builder: (context, state) => const ChatScreen()),
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
          scaffoldBackgroundColor: const Color(0xFFF7FBFA),
          cardTheme: CardThemeData(
            elevation: 2,
            shadowColor: const Color(0xFF286B63).withValues(alpha: 0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            color: Colors.white,
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: const Color(0xFFBCE2DC)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: const Color(0xFFBCE2DC)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: const Color(0xFF2F9C90),
                width: 1.4,
              ),
            ),
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFF2E8F84),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: const Color(0xFF2E8F84),
            foregroundColor: Colors.white,
          ),
        ),
        routerConfig: router,
      ),
    );
  }
}
