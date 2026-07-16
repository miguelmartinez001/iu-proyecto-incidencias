import 'package:cuaji_report/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:provider/provider.dart';

import '../../core/providers/theme_provider.dart';
import '../../core/theme/app_theme.dart';
import '../../widgets/custom_modals.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final paddingTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: paddingTop + 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Mi cuenta",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 30),

            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: colorScheme.primary.withValues(alpha: 0.15),
                child: Icon(
                  LucideIcons.user,
                  size: 60,
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Center(
              child: Text(
                "Ana Martínez",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "💡 Ciudadano Activo",
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _StatCard(
                    value: "12",
                    label: "REPORTES\nCREADOS",
                    icon: LucideIcons.fileText,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(width: 15),
                  _StatCard(
                    value: "5",
                    label: "SOLUCIONES\nVALIDADAS",
                    icon: LucideIcons.checkCircle2,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            _SettingsSection(
              colorScheme: colorScheme,
              notifications: notifications,
              onNotificationsChanged: (value) =>
                  setState(() => notifications = value),
            ),
            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomButton(
                text: "Cerrar sesión",
                onPressed: () => _showLogoutModal(context),
                variant: ButtonVariant.danger,
                icon: LucideIcons.logOut,
                iconPosition: IconPosition.left,
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  void _showLogoutModal(BuildContext context) {
    CustomModals.showActionModal(
      context,
      isDanger: true,
      icon: LucideIcons.logOut,
      title: "¿Cerrar sesión?",
      message: "Podrás volver a entrar con tu correo cuando quieras.",
      content: Column(
        children: [
          CustomButton(
            text: "Cerrar sesión",
            variant: ButtonVariant.danger,
            onPressed: () {
              context.go('/login');
            },
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: "Cancelar",
            variant: ButtonVariant.outline,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final ColorScheme colorScheme;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.colorScheme,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: colorScheme.secondary.withValues(alpha: 0.8)),
            const SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: colorScheme.onSurfaceVariant,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final ColorScheme colorScheme;
  final bool notifications;
  final ValueChanged<bool> onNotificationsChanged;

  const _SettingsSection({
    required this.colorScheme,
    required this.notifications,
    required this.onNotificationsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.watch<ThemeProvider>().currentTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest ?? colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ajustes rápidos",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            "Configura cómo quieres recibir alertas y cómo se ve la app.",
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
          ),
          const SizedBox(height: 20),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(LucideIcons.moon, color: colorScheme.primary),
            title: Text(
              "Modo oscuro",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            trailing: Switch(
              value: currentTheme == AppTheme.dark,
              onChanged: (isDark) {
                context.read<ThemeProvider>().updateTheme(
                  isDark ? AppTheme.dark : AppTheme.light,
                );
              },
              activeThumbColor: colorScheme.primary,
            ),
          ),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(LucideIcons.bell, color: colorScheme.primary),
            title: Text(
              "Notificaciones",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            trailing: Switch(
              value: notifications,
              onChanged: onNotificationsChanged,
              activeThumbColor: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
