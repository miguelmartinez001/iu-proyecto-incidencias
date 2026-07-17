import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  // 💡 CAMBIA ESTO A TRUE PARA VER LA PANTALLA VACÍA
  final bool _isEmpty = false;

  final List<Map<String, dynamic>> _alertsToday = [
    {
      "title": "15 vecinos respaldan tu reporte",
      "description": "Bache en Av. Reforma...",
      "time": "Hace 2 horas",
      "icon": LucideIcons.users,
      "color": Colors.blue,
      "isUnread": true,
    },
    {
      "title": "Reporte marcado como resuelto",
      "description": "Luminaria fundida en Calle 4...",
      "time": "Hace 5 horas",
      "icon": LucideIcons.checkCircle2,
      "color": Colors.green,
      "isUnread": true,
    },
  ];

  final List<Map<String, dynamic>> _alertsPrevious = [
    {
      "title": "Nuevo reporte cerca de ti",
      "description": "Árbol caído en Parque Central...",
      "time": "Ayer",
      "icon": LucideIcons.mapPin,
      "color": Colors.grey,
      "isUnread": false,
    },
  ];

  void _deleteAlert(List<Map<String, dynamic>> list, int index) {
    setState(() => list.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Auto-detecta si no hay alertas reales (sobreescribe _isEmpty si las listas están vacías)
    final bool showEmptyState =
        _isEmpty || (_alertsToday.isEmpty && _alertsPrevious.isEmpty);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Alertas",
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
      ),
      body: showEmptyState
          ? _buildEmptyState(colorScheme)
          : _buildAlertsList(colorScheme),
    );
  }

  // --- UI: ESTADO VACÍO ---
  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.bellOff,
              size: 50,
              color: colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Todo está tranquilo",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Aún no tienes alertas. Cuando haya actualizaciones de tus reportes o avisos de tu comunidad, aparecerán aquí.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 80), // Ajuste visual
        ],
      ),
    );
  }

  // --- UI: LISTADO CON DATOS ---
  Widget _buildAlertsList(ColorScheme colorScheme) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        if (_alertsToday.isNotEmpty) ...[
          Text(
            "Hoy",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ..._alertsPrevious.asMap().entries.map(
            (entry) => _buildAlertCard(
              context,
              entry.value,
              () => _deleteAlert(_alertsPrevious, entry.key),
            ),
          ),
          const SizedBox(height: 80),
        ],
      ],
    );
  }

  Widget _buildAlertCard(
    BuildContext context,
    Map<String, dynamic> alert,
    VoidCallback onDelete,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isUnread = alert["isUnread"] ?? false;
    final Color iconColor = alert["color"] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: colorScheme.onSurfaceVariant.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          // INDICADOR DE NO LEÍDO (El puntito verde)
          if (isUnread) ...[
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
          ] else ...[
            const SizedBox(
              width: 20,
            ), // Margen para alinear si no tiene el punto
          ],

          // ICONO DE LA ALERTA
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(alert["icon"], color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),

          // TEXTOS
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
                    fontSize: 12,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alert["time"]!,
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),

          // BOTÓN BORRAR
          IconButton(
            icon: Icon(
              LucideIcons.trash2,
              color: colorScheme.onSurfaceVariant.withOpacity(0.4),
              size: 20,
            ),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
