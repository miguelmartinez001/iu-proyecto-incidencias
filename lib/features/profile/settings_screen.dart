import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../../core/providers/theme_provider.dart';
import '../../core/theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notificaciones = true;
  bool consejos = true;
  bool compacta = false;
  bool ubicacion = true;

  String idiomaSeleccionado = "Español (México)";

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currentTheme = context.watch<ThemeProvider>().currentTheme;
    final String temaActualStr = currentTheme == AppTheme.dark ? "Oscuro" : "Claro";

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.chevronLeft, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Ajustes",
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            "GENERAL",
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                _buildToggleRow(
                  LucideIcons.bell,
                  "Notificaciones",
                  "Alertas y correos",
                  notificaciones,
                  (v) => setState(() => notificaciones = v),
                ),
                _buildDivider(),
                _buildToggleRow(
                  LucideIcons.eye,
                  "Mostrar consejos contextuales",
                  "Globos de ayuda",
                  consejos,
                  (v) => setState(() => consejos = v),
                ),
                _buildDivider(),
                _buildToggleRow(
                  LucideIcons.layoutTemplate,
                  "Vista compacta de reportes",
                  "Ocultar imágenes en listas",
                  compacta,
                  (v) => setState(() => compacta = v),
                ),
                _buildDivider(),
                _buildDropdownRow(
                  LucideIcons.globe,
                  "Idioma",
                  idiomaSeleccionado,
                  ["Español (México)", "English (US)", "Português"],
                  (val) => setState(() => idiomaSeleccionado = val),
                ),
                _buildDivider(),
                _buildDropdownRow(
                  LucideIcons.moon,
                  "Tema",
                  temaActualStr,
                  ["Claro", "Oscuro", "Automático (Sistema)"],
                  (val) {
                    if (val == "Claro") {
                      context.read<ThemeProvider>().updateTheme(AppTheme.light);
                    } else if (val == "Oscuro") {
                      context.read<ThemeProvider>().updateTheme(AppTheme.dark);
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Text(
            "PRIVACIDAD",
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                ),
              ],
            ),
            child: _buildToggleRow(
              LucideIcons.mapPin,
              "Ubicación",
              "Mientras se usa la app",
              ubicacion,
              (v) => setState(() => ubicacion = v),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleRow(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colorScheme.onSurfaceVariant, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: colorScheme.primary,
          ),
        ],
      ),
    );
  }

  // Acordeón personalizado para Ajustes
  Widget _buildDropdownRow(
    IconData icon,
    String title,
    String selectedValue,
    List<String> options,
    ValueChanged<String> onSelect,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: colorScheme.onSurfaceVariant, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          selectedValue,
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 12),
        ),
        iconColor: colorScheme.onSurfaceVariant,
        collapsedIconColor: colorScheme.onSurfaceVariant,
        children: options.map((option) {
          bool isSelected = option == selectedValue;
          return InkWell(
            onTap: () => onSelect(option),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected
                    ? colorScheme.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                option,
                style: TextStyle(
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDivider() => Divider(
    height: 1,
    color: Theme.of(
      context,
    ).colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
  );
}
