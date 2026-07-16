import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import '../../widgets/glass_header.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final List<Map<String, String>> _alertsToday = [
    {
      "title": "15 vecinos respaldan tu reporte",
      "description": "Bache en Av. Reforma…",
      "time": "Hace 2 horas",
    },
    {
      "title": "Reporte marcado como resuelto",
      "description": "Luminaria fundida en Calle 4…",
      "time": "Hace 5 horas",
    },
  ];

  final List<Map<String, String>> _alertsPrevious = [
    {
      "title": "Nuevo reporte cerca de ti",
      "description": "Árbol caído en Parque Central…",
      "time": "Ayer",
    },
  ];

  void _deleteAlert(List<Map<String, String>> list, int index) {
    setState(() {
      list.removeAt(index);
    });
  }

  Widget _buildAlertCard(
    BuildContext context,
    Map<String, String> alert,
    VoidCallback onDelete,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icono de alerta
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.bell,
              color: colorScheme.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

          // Texto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert["title"]!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert["description"]!,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert["time"]!,
                  style: TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Botón de eliminar
          IconButton(
            icon: Icon(
              LucideIcons.trash2,
              color: colorScheme.error,
              size: 20,
            ),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool noAlerts =
        _alertsToday.isEmpty && _alertsPrevious.isEmpty; // 👈 chequeo

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
            child: noAlerts
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.bell,
                          size: 48,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Sin notificaciones",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    children: [
                      if (_alertsToday.isNotEmpty) ...[
                        Text(
                          "Hoy",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ..._alertsToday.asMap().entries.map(
                          (entry) => _buildAlertCard(
                            context,
                            entry.value,
                            () => _deleteAlert(_alertsToday, entry.key),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      if (_alertsPrevious.isNotEmpty) ...[
                        Text(
                          "Anteriores",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ..._alertsPrevious.asMap().entries.map(
                          (entry) => _buildAlertCard(
                            context,
                            entry.value,
                            () => _deleteAlert(_alertsPrevious, entry.key),
                          ),
                        ),
                      ],
                    ],
                  ),
          ),

          // Encabezado translúcido
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: GlassHeader(title: "Alertas", showBackButton: false),
          ),
        ],
      ),
    );
  }
}
