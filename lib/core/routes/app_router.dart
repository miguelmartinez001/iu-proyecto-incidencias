import 'package:cuaji_report/features/alerts/alerts_screen.dart';
import 'package:cuaji_report/features/profile/edit_profile_screen.dart';
import 'package:cuaji_report/features/profile/help_screen.dart';
import 'package:cuaji_report/features/profile/settings_screen.dart';
import 'package:cuaji_report/features/reports/success_report_screen.dart';
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
import '../../features/reports/create_report_screen.dart';
import '../../features/reports/detail_report_screen.dart'; // <-- ASEGÚRATE DE IMPORTAR ESTO
import '../../main_wrapper.dart';
import '../models/report_mock.dart'; // <-- IMPORTA TU MODELO DE MOCKS

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
        builder: (context, state) => const CreateReportScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(path: '/help', builder: (context, state) => const HelpScreen()),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/edit-profile-success',
        builder: (context, state) => const EditProfileSuccessScreen(),
      ),

      GoRoute(
        name: 'success-report', // <-- AGREGAMOS NOMBRE EN LA RAÍZ
        path: '/success-report',
        builder: (context, state) => const SuccessReportScreen(),
      ),

      GoRoute(
        name: 'report-detail', // <-- AGREGAMOS RUTA DE DETALLE
        path: '/report-detail',
        builder: (context, state) {
          final report =
              state.extra as ReportModel; // Recupera el mock rich enviado
          return DetailReportScreen(report: report);
        },
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
            builder: (context, state) => const AlertsScreen(),
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
