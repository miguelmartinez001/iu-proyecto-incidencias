import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
          "Ayuda",
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            "¿En qué podemos ayudarte hoy?",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Despliega un tema para leer nuestra guía paso a paso.",
            style: TextStyle(fontSize: 15, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 30),

          _HelpAccordion(
            title: "¿Cómo crear un reporte?",
            subtitle: "Conoce los pasos para enviar una incidencia.",
            icon: LucideIcons.plus,
            color: colorScheme.primary,
            steps: const [
              "Ve a la pestaña central de 'Nuevo Reporte' en la barra inferior.",
              "Toma una foto clara del problema (bache, fuga, etc).",
              "Selecciona la categoría correcta para que se asigne al área adecuada.",
              "Confirma la ubicación en el mapa y envía el reporte.",
            ],
          ),
          const SizedBox(height: 16),
          _HelpAccordion(
            title: "¿Cómo confirmar una incidencia?",
            subtitle: "¿Cómo confirmar una incidencia?", // Del Figma
            icon: LucideIcons.checkCircle2,
            color: Colors.blue.shade600,
            steps: const [
              "Abre cualquier reporte creado por otro vecino en tu zona.",
              "Desliza hacia abajo hasta la sección de 'Acciones'.",
              "Abre cualquier reporte creado por otro vecino en tu zona.", // Repetido en el Figma
              "Selecciona 'Confirmar incidencia' para aumentar la prioridad del caso.",
            ],
          ),
        ],
      ),
    );
  }
}

class _HelpAccordion extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final List<String> steps;

  const _HelpAccordion({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.steps,
  });

  @override
  State<_HelpAccordion> createState() => _HelpAccordionState();
}

class _HelpAccordionState extends State<_HelpAccordion> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(20),
          onExpansionChanged: (val) => setState(() => _isExpanded = val),
          leading: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(widget.icon, color: widget.color, size: 24),
          ),
          title: Text(
            widget.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: colorScheme.onSurface,
            ),
          ),
          subtitle: Text(
            widget.subtitle,
            style: TextStyle(
              color: colorScheme.onSurfaceVariant,
              fontSize: 13,
              height: 1.3,
            ),
          ),
          trailing: Icon(
            _isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
            color: colorScheme.onSurfaceVariant,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
              child: Column(
                children: widget.steps.asMap().entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: colorScheme.onSurfaceVariant.withValues(
                              alpha: 0.15,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "${entry.key + 1}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onSurface,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
