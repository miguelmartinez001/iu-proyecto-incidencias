import 'package:flutter/material.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'custom_button.dart';
import '../core/models/report_mock.dart'; // Necesario para leer el ReportHistoryEvent

class CustomModals {
  // 1. MODAL GENÉRICO ACCIONES
  static void showActionModal(
    BuildContext context, {
    required bool isDanger,
    required IconData icon,
    required String title,
    required String message,
    required Widget content,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (isDanger ? colorScheme.error : colorScheme.primary)
                      .withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isDanger ? colorScheme.error : colorScheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              content,
            ],
          ),
        );
      },
    );
  }

  // 2. MODAL AÑADIR EVIDENCIA
  static void showAddEvidenceModal(
    BuildContext context, {
    required VoidCallback onPhotoAdded,
  }) {
    // ... (Se queda igual que la versión anterior)
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(LucideIcons.x),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.camera,
                  color: colorScheme.primary,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Añadir evidencia",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Sube una foto clara de la incidencia urbana.",
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(LucideIcons.camera),
                      label: const Text("Tomar foto"),
                      onPressed: () {
                        onPhotoAdded();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(LucideIcons.image),
                      label: const Text("Abrir galería"),
                      onPressed: () {
                        onPhotoAdded();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              CustomButton(
                text: "Cancelar",
                variant: ButtonVariant.outline,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  // 3. MODAL SALIR DEL REPORTE (Se queda igual)
  static void showExitReportModal(BuildContext context) {
    // ... (Mismo código de antes)
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.alertTriangle,
                  color: Colors.amber,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "¿Salir del reporte?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Tu progreso está guardado. ¿Qué deseas hacer con este borrador?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: "Guardar borrador y salir",
                variant: ButtonVariant.secondary,
                icon: LucideIcons.save,
                iconPosition: IconPosition.left,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: "Salir sin guardar",
                variant: ButtonVariant.danger,
                icon: LucideIcons.trash2,
                iconPosition: IconPosition.left,
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 12),
              CustomButton(
                text: "Seguir editando",
                variant: ButtonVariant.outline,
                icon: LucideIcons.edit2,
                iconPosition: IconPosition.left,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  // 4. TIP DE COMUNIDAD
  static void showCommunityTipModal(
    BuildContext context, {
    required bool isMine,
  }) {
    // ... (Se queda igual)
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    LucideIcons.lightbulb,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "TIP DE LA COMUNIDAD",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Apoya a tu comunidad",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  isMine
                      ? "Este reporte es tuyo. Puedes editarlo o marcarlo como resuelto cuando el problema desaparezca."
                      : "Al entrar al reporte de un vecino, puedes confirmar si el problema sigue activo, avisar si empeoró o sugerir una solución.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: "¡Entendido!",
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 5. GESTIONAR REPORTE (Dueño) -> Cambiado 'Compartir' por 'Escalar'
  static void showManageReportModal(
    BuildContext context, {
    required VoidCallback onResolve,
    required VoidCallback onUpdate,
    required VoidCallback onEscalate,
    required VoidCallback onDelete,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Gestionar reporte",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Actualiza el estado de tu incidencia.",
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              _buildModalTile(
                context,
                "Marcar como solucionado",
                "Cierra este caso públicamente.",
                LucideIcons.checkCircle,
                colorScheme.primary,
                () {
                  Navigator.pop(context);
                  onResolve();
                },
              ),
              _buildModalTile(
                context,
                "Agregar actualización",
                "Añade fotos o información nueva.",
                LucideIcons.camera,
                colorScheme.onSurface,
                () {
                  Navigator.pop(context);
                  onUpdate();
                },
              ),
              _buildModalTile(
                context,
                "Escalar reporte",
                "Dale visibilidad o contacta a la autoridad.",
                LucideIcons.shieldAlert,
                Colors.purple.shade600,
                () {
                  Navigator.pop(context);
                  onEscalate();
                },
              ),
              _buildModalTile(
                context,
                "Eliminar reporte",
                "Borrar esta incidencia para siempre.",
                LucideIcons.trash2,
                colorScheme.error,
                () {
                  Navigator.pop(context);
                  onDelete();
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // 6. PARTICIPAR (Vecino) -> Agregados los callbacks
  static void showParticipateModal(
    BuildContext context, {
    required VoidCallback onConfirm,
    required VoidCallback onWorsen,
    required VoidCallback onSolve,
    required VoidCallback onEscalate,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Participar en el reporte",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Ayuda a la comunidad aportando más información.",
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              _buildModalTile(
                context,
                "Confirmar incidencia",
                "Valida que el problema sigue ahí.",
                LucideIcons.shieldCheck,
                colorScheme.primary,
                () {
                  Navigator.pop(context);
                  onConfirm();
                },
              ),
              _buildModalTile(
                context,
                "Reportar que empeoró",
                "Avisa si la situación es más grave.",
                LucideIcons.trendingDown,
                Colors.orange.shade700,
                () {
                  Navigator.pop(context);
                  onWorsen();
                },
              ),
              _buildModalTile(
                context,
                "Parece solucionado",
                "Avisa si crees que ya lo solucionaron.",
                LucideIcons.lightbulb,
                Colors.blue.shade600,
                () {
                  Navigator.pop(context);
                  onSolve();
                },
              ),
              _buildModalTile(
                context,
                "Escalar reporte",
                "Dale visibilidad o contacta a la autoridad.",
                LucideIcons.shieldAlert,
                Colors.purple.shade600,
                () {
                  Navigator.pop(context);
                  onEscalate();
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  // 7. ESCALAR (Reutilizable en ambos)
  static void showEscalateModal(BuildContext context) {
    // ... (Se queda exactamente igual)
    final colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 40),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        LucideIcons.share2,
                        color: colorScheme.primary,
                        size: 28,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  "Escalar reporte",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Ayuda a que este reporte tenga más visibilidad o contacta a la autoridad responsable.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildShareIcon(
                      context,
                      LucideIcons.messageCircle,
                      "WhatsApp",
                      Colors.green,
                    ),
                    _buildShareIcon(context, LucideIcons.x, "X", Colors.black),
                    _buildShareIcon(
                      context,
                      LucideIcons.link,
                      "Link",
                      colorScheme.onSurface,
                    ),
                    _buildShareIcon(
                      context,
                      LucideIcons.mail,
                      "Correo",
                      Colors.red,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: "Ver autoridad responsable",
                  variant: ButtonVariant.secondary,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 8. MODAL DEL HISTORIAL (NUEVO - Trasladado de la pantalla)
  static void showHistoryModal(
    BuildContext context,
    List<ReportHistoryEvent> history,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Historial del reporte",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ...history.asMap().entries.map((entry) {
                int idx = entry.key;
                var event = entry.value;
                bool isLast = idx == history.length - 1;
                return _buildTimelineItem(event, isLast, colorScheme);
              }),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // Helpers para pintar en los modales
  static Widget _buildModalTile(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(16),
          color: color.withValues(alpha: 0.05),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                      fontSize: 14,
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
          ],
        ),
      ),
    );
  }

  static Widget _buildShareIcon(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // 9. MODAL DE CONFIRMACIÓN PREMIUM (Estilo Figma)
  static void showConfirmationDialog(
    BuildContext context, {
    required IconData mainIcon,
    required Color iconColor,
    required String title,
    required String description,
    required String primaryButtonText,
    required ButtonVariant primaryButtonVariant,
    required String secondaryButtonText,
    required VoidCallback onConfirm,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          backgroundColor: colorScheme.surface,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Se ajusta al contenido
              children: [
                // ÍCONO CENTRAL CON EFECTO GLOW
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.05),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: iconColor.withValues(alpha: 0.15),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(mainIcon, color: iconColor, size: 40),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // TEXTOS
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),

                // BOTONES
                CustomButton(
                  text: primaryButtonText,
                  variant: primaryButtonVariant,
                  onPressed: () {
                    Navigator.pop(context); // Cierra el modal
                    onConfirm(); // Ejecuta la acción
                  },
                ),
                const SizedBox(height: 12),
                CustomButton(
                  text: secondaryButtonText,
                  variant: ButtonVariant
                      .neutral, // Para que se vea como un texto o outline suave
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildTimelineItem(
    ReportHistoryEvent event,
    bool isLast,
    ColorScheme colorScheme,
  ) {
    IconData getIcon(String title) {
      final lower = title.toLowerCase();
      if (lower.contains('creado')) return LucideIcons.plus;
      if (lower.contains('comunidad') || lower.contains('vecino'))
        return LucideIcons.users;
      if (lower.contains('proceso') || lower.contains('revisión'))
        return LucideIcons.wrench;
      if (lower.contains('resuelto') || lower.contains('solucionado'))
        return LucideIcons.check;
      if (lower.contains('prioridad')) return LucideIcons.alertTriangle;
      return LucideIcons.circleDot;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: event.isDone
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                getIcon(event.title),
                color: event.isDone
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
                size: 16,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 35,
                color: event.isDone
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
              ),
          ],
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                event.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: event.isDone
                      ? colorScheme.onSurface
                      : colorScheme.onSurfaceVariant,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              if (event.time.isNotEmpty)
                Text(
                  event.time,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ],
    );
  }
}
