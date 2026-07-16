import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_modals.dart';
import '../../core/models/report_mock.dart';

class DetailReportScreen extends StatefulWidget {
  final ReportModel report;
  const DetailReportScreen({super.key, required this.report});

  @override
  State<DetailReportScreen> createState() => _DetailReportScreenState();
}

class _DetailReportScreenState extends State<DetailReportScreen> {
  bool _isResolved = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CustomModals.showCommunityTipModal(context, isMine: widget.report.isMine);
    });
  }

  // --- ACCIÓN: CERRAR REPORTE (Dueño) ---
  void _confirmResolve() {
    CustomModals.showConfirmationDialog(
      context,
      mainIcon: LucideIcons.sparkles,
      iconColor: Colors.green.shade600,
      title: "¿Problema resuelto?",
      description:
          "Confirmar que esto ya se arregló ayuda a mantener limpio el mapa para todos los vecinos.",
      primaryButtonText: "Sí, ya está solucionado",
      primaryButtonVariant: ButtonVariant.primary,
      secondaryButtonText: "Aún no lo arreglan",
      onConfirm: () {
        setState(() => _isResolved = true);
        _showSuccessSnackbar(
          "¡Excelente! El reporte ha sido marcado como resuelto.",
        );
      },
    );
  }

  // --- ACCIÓN: ELIMINAR REPORTE (Dueño) ---
  void _confirmDelete() {
    CustomModals.showConfirmationDialog(
      context,
      mainIcon: LucideIcons.trash2,
      iconColor: Theme.of(context).colorScheme.error,
      title: "¿Eliminar reporte?",
      description:
          "Esta acción es irreversible. El reporte desaparecerá de tu historial y del mapa vecinal.",
      primaryButtonText: "Sí, eliminar",
      primaryButtonVariant: ButtonVariant.danger,
      secondaryButtonText: "Cancelar",
      onConfirm: () {
        context.go('/'); // Te devuelve al inicio tras borrar
      },
    );
  }

  // --- ACCIONES CON CONFIRMACIÓN (Vecino) ---
  void _confirmNeighborAction(
    String title,
    String message,
    String successMessage,
  ) {
    CustomModals.showActionModal(
      context,
      isDanger: false,
      icon: LucideIcons.shieldCheck,
      title: title,
      message: message,
      content: Column(
        children: [
          CustomButton(
            text: "Confirmar",
            onPressed: () {
              Navigator.pop(context);
              _showSuccessSnackbar(successMessage);
            },
          ),
          const SizedBox(height: 12),
          CustomButton(
            text: "Cancelar",
            variant: ButtonVariant.outline,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green.shade800,
        content: Row(
          children: [
            const Icon(LucideIcons.checkCircle, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'alta':
        return Colors.orange.shade700;
      case 'media':
        return Colors.blue.shade600;
      case 'baja':
        return Colors.green.shade600;
      default:
        return Colors.grey.shade600;
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
        leading: IconButton(
          icon: Icon(
            LucideIcons.chevronLeft,
            color: colorScheme.onSurface,
            size: 28,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.report.isMine
              ? "Detalle de mi reporte"
              : "Detalle del reporte",
          style: TextStyle(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          if (widget.report.isMine)
            IconButton(
              icon: Icon(
                LucideIcons.trash2,
                color: colorScheme.onSurfaceVariant,
              ),
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGEN
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                "https://images.unsplash.com/photo-1515162305285-0293e4767cc2?q=80&w=600",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  height: 200,
                  color: colorScheme.surface,
                  child: Icon(
                    LucideIcons.imageOff,
                    color: colorScheme.onSurfaceVariant,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // TÍTULO Y ESTATUS
            Text(
              widget.report.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildStatusPill(
                  label: _isResolved ? "Resuelto" : widget.report.status,
                  color: _isResolved
                      ? colorScheme.primary
                      : Colors.green.shade600,
                  icon: _isResolved
                      ? LucideIcons.checkCircle
                      : LucideIcons.circleDot,
                ),
                const SizedBox(width: 10),
                _buildStatusPill(
                  label: widget.report.priority,
                  color: _getPriorityColor(widget.report.priority),
                  icon: LucideIcons.flag,
                  prefix: "PRIORIDAD",
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ESTADÍSTICAS
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    widget.report.neighborsConfirmCount.toString(),
                    "Vecinos confirman",
                    LucideIcons.users,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildStatCard(
                    context,
                    widget.report.believesRepairedCount.toString(),
                    "Creen reparado",
                    LucideIcons.wrench,
                    colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // FECHAS
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildDateRow(
                    context,
                    LucideIcons.calendar,
                    "Reportado:",
                    widget.report.dateReported,
                  ),
                  const SizedBox(height: 10),
                  _buildDateRow(
                    context,
                    LucideIcons.clock,
                    "Últ. actualización:",
                    widget.report.timeAgo,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // DESCRIPCIÓN
            Text(
              widget.report.description,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 25),

            // BOTÓN HISTORIAL
            InkWell(
              onTap: () => CustomModals.showHistoryModal(
                context,
                widget.report.history,
              ), // <-- ABRE EL MODAL
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.1,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.clock,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ver historial",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            "Actualizaciones y actividad",
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      LucideIcons.chevronRight,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),

      // BOTÓN INFERIOR
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: widget.report.isMine
              ? CustomButton(
                  text: _isResolved ? "Reporte resuelto" : "Gestionar reporte",
                  isDisabled: _isResolved,
                  variant: ButtonVariant.secondary,
                  onPressed: () => CustomModals.showManageReportModal(
                    context,
                    onResolve: _confirmResolve,
                    onDelete: _confirmDelete,
                    onUpdate: () => print(
                      "Navegar a editar reporte",
                    ), // Aquí meterás tu goNamed de edición luego
                    onEscalate: () => CustomModals.showEscalateModal(context),
                  ),
                )
              : CustomButton(
                  text: "Participar en este reporte",
                  onPressed: () => CustomModals.showParticipateModal(
                    context,
                    onConfirm: () => CustomModals.showConfirmationDialog(
                      context,
                      mainIcon: LucideIcons.users,
                      iconColor: Colors.green.shade600,
                      title: "¡Apoya a la Comunidad!",
                      description:
                          "Al confirmar que también viste esta incidencia, ayudas a que las autoridades le den máxima prioridad.",
                      primaryButtonText: "Respaldar reporte",
                      primaryButtonVariant: ButtonVariant.primary,
                      secondaryButtonText: "Cancelar",
                      onConfirm: () => _showSuccessSnackbar(
                        "¡Gracias! Tu confirmación ayuda a darle prioridad.",
                      ),
                    ),
                    onWorsen: () => CustomModals.showConfirmationDialog(
                      context,
                      mainIcon: LucideIcons.trendingDown,
                      iconColor: Colors.orange.shade700,
                      title: "¿El problema empeoró?",
                      description:
                          "Si la incidencia representa un riesgo mayor ahora, notifícalo para elevar su nivel de urgencia en la comunidad.",
                      primaryButtonText: "Sí, ha empeorado",
                      primaryButtonVariant: ButtonVariant.danger,
                      secondaryButtonText: "Cancelar",
                      onConfirm: () => _showSuccessSnackbar(
                        "Registrado. Se ha notificado que la situación empeoró.",
                      ),
                    ),
                    onSolve: () => CustomModals.showConfirmationDialog(
                      context,
                      mainIcon: LucideIcons.shieldQuestion,
                      iconColor: Colors.blue.shade600,
                      title: "¿Crees que ya se arregló?",
                      description:
                          "Avísanos si este problema ya fue solucionado. Si suficientes vecinos lo confirman, el reporte se cerrará automáticamente.",
                      primaryButtonText: "Sí, ya está solucionado",
                      primaryButtonVariant: ButtonVariant.secondary,
                      secondaryButtonText: "Cancelar",
                      onConfirm: () => _showSuccessSnackbar(
                        "Gracias por avisar. El dueño verificará tu sugerencia.",
                      ),
                    ),
                    onEscalate: () => CustomModals.showEscalateModal(context),
                  ),
                ),
        ),
      ),
    );
  }

  // (Mismos widgets auxiliares visuales de la versión anterior)
  Widget _buildStatusPill({
    required String label,
    required Color color,
    required IconData icon,
    String? prefix,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(
            prefix != null ? "$prefix • $label" : label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontSize: 13,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
