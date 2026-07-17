import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import '../../core/models/mock_data.dart';
import '../../widgets/custom_modals.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final List<AlertModel> _alertsToday = List.from(mockAlertsToday);
  final List<AlertModel> _alertsPrevious = List.from(mockAlertsPrevious);

  void _deleteAlert(List<AlertModel> list, int index) {
    setState(() => list.removeAt(index));
  }

  void _openAlertDetail(AlertModel alert) {
    CustomModals.showAlertDetailModal(
      context,
      alert,
      onMarkRead: () {
        setState(() => alert.isUnread = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool showEmptyState = _alertsToday.isEmpty && _alertsPrevious.isEmpty;

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
          ? const Center(child: Text("Sin alertas"))
          : _buildAlertsList(colorScheme),
    );
  }

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
            (e) => _buildAlertCard(
              e.value,
              () => _deleteAlert(_alertsToday, e.key),
            ),
          ),
        ],
        if (_alertsPrevious.isNotEmpty) ...[
          const SizedBox(height: 20),
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
            (e) => _buildAlertCard(
              e.value,
              () => _deleteAlert(_alertsPrevious, e.key),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAlertCard(AlertModel alert, VoidCallback onDelete) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => _openAlertDetail(alert),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: colorScheme.onSurfaceVariant.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            if (alert.isUnread) ...[
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
            ] else
              const SizedBox(width: 20),

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: alert.color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(alert.icon, color: alert.color, size: 20),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alert.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alert.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
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
      ),
    );
  }
}
