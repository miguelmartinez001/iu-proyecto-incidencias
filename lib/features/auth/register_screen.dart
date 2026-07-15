import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/glass_header.dart';
import 'auth_layout.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _handleRegister() {
    final colorScheme = Theme.of(context).colorScheme;

    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Todos los campos son obligatorios"),
          backgroundColor: colorScheme.error,
        ),
      );
      return;
    }
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          const AuthLayout(child: SizedBox.expand()),

          SingleChildScrollView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 80,
              left: 24,
              right: 24,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surface.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      Icons.construction,
                      color: colorScheme.primary,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    "Crea tu cuenta",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    "Únete a la red vecinal de\nCuajimalpa.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                CustomTextField(
                  controller: _nameController,
                  label: "Nombre completo",
                  hint: "Ana Martínez",
                ),
                CustomTextField(
                  controller: _emailController,
                  label: "Correo",
                  hint: "ana.martinez@correo.com",
                  keyboardType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  controller: _passwordController,
                  label: "Contraseña",
                  hint: "••••••••",
                  isPassword: true,
                ),

                const SizedBox(height: 24),
                CustomButton(text: "Registrarme", onPressed: _handleRegister),
              ],
            ),
          ),

          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GlassHeader(title: "", showBackButton: true),
          ),
        ],
      ),
    );
  }
}
