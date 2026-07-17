import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/glass_header.dart';
import 'auth_layout.dart';

class SuccessRecoverScreen extends StatelessWidget {
  const SuccessRecoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          const AuthLayout(child: SizedBox.expand()),

          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 80,
              left: 24,
              right: 24,
              bottom: 40,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        LucideIcons.mail,
                        color: colorScheme.primary,
                        size: 60,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Te hemos enviado un\nenlace a tu correo",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "Revisa tu bandeja de entrada para\ncontinuar.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  text: "Regresar",
                  variant: ButtonVariant.secondary,
                  onPressed: () => context.go('/login'),
                ),
              ],
            ),
          ),

          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GlassHeader(
              title: "Recuperar contraseña",
              showBackButton: true,
            ),
          ),
        ],
      ),
    );
  }
}
