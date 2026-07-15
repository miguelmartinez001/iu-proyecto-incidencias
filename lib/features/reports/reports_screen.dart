import 'package:flutter/material.dart';

import '../../widgets/glass_header.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          Center(
            child: Text(
              "Mis Reportes\n(En construcción)",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: colorScheme.onSurface),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GlassHeader(title: "Mis reportes", showBackButton: false),
          ),
        ],
      ),
    );
  }
}
