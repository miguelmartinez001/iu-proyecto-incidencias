import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/glass_header.dart';
import 'auth_layout.dart';

class RecoverPasswordScreen extends StatelessWidget {
  const RecoverPasswordScreen({super.key});

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
                const SizedBox(height: 20),
                Text(
                  "Ingresa tu correo y te enviaremos un enlace para restablecer tu contraseña.",
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 40),

                const CustomTextField(
                  label: "Correo",
                  hint: "ana.martinez@correo.com",
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 24),
                CustomButton(
                  text: "Enviar enlace",
                  onPressed: () => context.push('/success-recover'),
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
