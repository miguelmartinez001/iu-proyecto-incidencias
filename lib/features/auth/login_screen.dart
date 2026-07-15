import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import 'auth_layout.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;

  void _handleLogin() {
    setState(() {
      _emailError = _emailController.text.trim().isEmpty
          ? "Este campo es obligatorio"
          : null;
      _passwordError = _passwordController.text.trim().isEmpty
          ? "Este campo es obligatorio"
          : null;
    });

    if (_emailError == null && _passwordError == null) {
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AuthLayout(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
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
              const SizedBox(height: 24),
              Text(
                "Reportes Urbanos\nCuajimalpa",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Reporta incidencias en tu ciudad",
                style: TextStyle(color: colorScheme.onSurface, fontSize: 14),
              ),
              const SizedBox(height: 40),

              ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.white.withValues(alpha: 0.1),
                          Colors.white.withValues(alpha: 0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _emailController,
                          label: "Correo",
                          hint: "ana.martinez@correo.com",
                          keyboardType: TextInputType.emailAddress,
                          errorText: _emailError,
                        ),
                        CustomTextField(
                          controller: _passwordController,
                          label: "Contraseña",
                          hint: "••••••••",
                          isPassword: true,
                          errorText: _passwordError,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => context.push('/recover'),
                            child: Text(
                              "Olvidé mi contraseña",
                              style: TextStyle(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: "Iniciar sesión",
                          onPressed: _handleLogin,
                        ),
                        const SizedBox(height: 16),
                        CustomButton(
                          text: "Entrar como invitado",
                          variant: ButtonVariant.secondary,
                          onPressed: () => context.go('/'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "¿No tienes una cuenta?",
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              TextButton(
                onPressed: () => context.push('/register'),
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                ),
                child: const Text(
                  "Únete a esta comunidad",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
