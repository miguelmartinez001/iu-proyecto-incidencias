import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/login_screen.dart';
import '../../features/auth/recover_password_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/auth/reset_password_screen.dart';
import '../../features/auth/success_recover_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/reports/reports_screen.dart';
import '../../main_wrapper.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
      // RUTAS SIN MENÚ (Auth y Nuevo Reporte)
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/recover',
        builder: (context, state) => const RecoverPasswordScreen(),
      ),
      GoRoute(
        path: '/success-recover',
        builder: (context, state) => const SuccessRecoverScreen(),
      ),
      GoRoute(
        path: '/reset',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        path: '/new-report',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text("Pantalla Nuevo Reporte"))),
      ),

      // RUTAS CON MENÚ DE ABAJO
      ShellRoute(
        builder: (context, state, child) {
          return MainWrapper(child: child);
        },
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportsScreen(),
          ),
          GoRoute(
            path: '/alerts',
            builder: (context, state) => const Center(child: Text("Alertas")),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
