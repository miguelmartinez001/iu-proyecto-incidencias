import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import '../../widgets/custom_button.dart'; // Asegúrate de tener tu botón importado

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  // 💡 CAMBIA ESTO A TRUE PARA VER LA PANTALLA VACÍA
  final bool _isEmpty = false;
  final bool _hasDraft = true; // Para mostrar/ocultar el borrador

  String _selectedFilter = "Todos";

  final List<String> _filters = [
    "Todos",
    "En Revisión",
    "Resuelto",
    "Recibido",
  ];

  final List<Map<String, String>> _reports = [
    {
      "title": "Bache en Av. Cuajimalpa",
      "status": "En Revisión",
      "category": "bache",
    },
    {
      "title": "Árbol caído en parque",
      "status": "Recibido",
      "category": "arbol",
    },
    {"title": "Sin Luz", "status": "Resuelto", "category": "luz"},
  ];

  List<Map<String, String>> get _filteredReports {
    if (_selectedFilter == "Todos") return _reports;
    return _reports.where((r) => r["status"] == _selectedFilter).toList();
  }

  Color _statusColor(String status) {
    switch (status) {
      case "Resuelto":
        return Colors.green.shade600;
      case "En Revisión":
        return Colors.orange.shade400;
      case "Recibido":
        return Colors.grey.shade600;
      default:
        return Colors.grey;
    }
  }

  IconData _categoryIcon(String category) {
    switch (category) {
      case "bache":
        return LucideIcons.alertTriangle;
      case "arbol":
        return LucideIcons.treePine;
      case "luz":
        return LucideIcons.lightbulb;
      default:
        return LucideIcons.fileText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Mis reportes",
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
      ),
      body: _isEmpty
          ? _buildEmptyState(colorScheme)
          : _buildReportsList(colorScheme),
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
              color: colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              LucideIcons.clipboardList,
              size: 50,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Aún no tienes reportes",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Ayuda a mejorar Cuajimalpa. Si ves un bache, luminaria fundida o árbol caído, ¡conviértete en el primero en reportarlo!",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: "+ Crear mi primer reporte",
            // Variante neutral/café según tu Figma, ajusta si es necesario
            variant: ButtonVariant.primary,
            onPressed: () {
              // Navegar al wizard de reportes
            },
          ),
          const SizedBox(height: 40), // Espacio para el bottom nav bar
        ],
      ),
    );
  }

  // --- UI: LISTADO CON DATOS ---
  Widget _buildReportsList(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Filtros (Pills)
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _filters.length,
            itemBuilder: (context, index) {
              final filter = _filters[index];
              final isSelected = _selectedFilter == filter;
              return GestureDetector(
                onTap: () => setState(() => _selectedFilter = filter),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant.withOpacity(0.2),
                    ),
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurfaceVariant,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              // SECCIÓN: PENDIENTE (Borrador)
              if (_hasDraft && _selectedFilter == "Todos") ...[
                Text(
                  "PENDIENTE",
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                _buildDraftCard(colorScheme),
                const SizedBox(height: 25),
              ],

              // SECCIÓN: HISTORIAL
              Text(
                "HISTORIAL",
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 10),
              ..._filteredReports.map(
                (report) => _buildReportCard(report, colorScheme),
              ),
              const SizedBox(height: 80), // Margen inferior
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDraftCard(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(LucideIcons.edit2, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Borrador guardado",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Bache en Av. Reforma...",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          const Icon(LucideIcons.chevronRight, color: Colors.blue),
        ],
      ),
    );
  }

  Widget _buildReportCard(Map<String, String> report, ColorScheme colorScheme) {
    final status = report["status"]!;
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
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.onSurfaceVariant.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _categoryIcon(report["category"]!),
              color: colorScheme.onSurfaceVariant,
              size: 22,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report["title"]!,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: _statusColor(status),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
