import 'package:latlong2/latlong.dart';

class ReportHistoryEvent {
  final String title;
  final String subtitle;
  final String time;
  final bool isDone;

  ReportHistoryEvent({
    required this.title,
    required this.subtitle,
    required this.time,
    this.isDone = false,
  });
}

class ReportModel {
  final String id;
  final String title;
  final String category;
  final String status;
  final String timeAgo;
  final String distance;
  final bool isMine;
  final LatLng location;
  final String description;
  final String priority;
  final int neighborsConfirmCount;
  final int believesRepairedCount;
  final String dateReported;
  final List<ReportHistoryEvent> history;

  ReportModel({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.timeAgo,
    required this.distance,
    this.isMine = false,
    required this.location,
    required this.description,
    required this.priority,
    required this.neighborsConfirmCount,
    required this.believesRepairedCount,
    required this.dateReported,
    required this.history,
  });
}

// Mocks ultra-completos para alimentar el Home y el Detalle
final List<ReportModel> mockReports = [
  ReportModel(
    id: "1",
    title: "Bache profundo en Av. Juárez 3",
    category: "Baches",
    status: "Activo",
    timeAgo: "Hace 2 horas",
    distance: "A 200m",
    isMine: true, // Tu reporte propio
    location: const LatLng(19.3562, -99.2995),
    description:
        "Bache de gran tamaño sobre el carril derecho, representa un riesgo severo para los vehículos que bajan rápido.",
    priority: "Alta",
    neighborsConfirmCount: 15,
    believesRepairedCount: 3,
    dateReported: "12 de Oct, 2023",
    history: [
      ReportHistoryEvent(
        title: "Reporte creado",
        subtitle: "Ana Martínez creó esta incidencia.",
        time: "12 Oct, 10:30 AM",
        isDone: true,
      ),
      ReportHistoryEvent(
        title: "Confirmado por la comunidad",
        subtitle: "15 vecinos han respaldado esta incidencia.",
        time: "12 Oct, 02:15 PM",
        isDone: true,
      ),
      ReportHistoryEvent(
        title: "Aumentó prioridad",
        subtitle: "Se reportó un empeoramiento del daño.",
        time: "13 Oct, 09:00 AM",
        isDone: true,
      ),
      ReportHistoryEvent(
        title: "En proceso de revisión",
        subtitle: "Pendiente de resolución por la autoridad.",
        time: "Esperando...",
        isDone: false,
      ),
    ],
  ),
  ReportModel(
    id: "2",
    title: "Luminaria fundida en el parque",
    category: "Alumbrado",
    status: "En revisión",
    timeAgo: "Hace 1 día",
    distance: "A 500m",
    isMine: false, // Reporte de un vecino
    location: const LatLng(19.3565, -99.3020),
    description:
        "Toda la sección oriente del parque está a oscuras debido a que tres postes tienen las luminarias fundidas.",
    priority: "Media",
    neighborsConfirmCount: 32,
    believesRepairedCount: 0,
    dateReported: "11 de Oct, 2023",
    history: [
      ReportHistoryEvent(
        title: "Reporte creado",
        subtitle: "Vecino anónimo reportó la falla.",
        time: "11 Oct, 08:20 PM",
        isDone: true,
      ),
      ReportHistoryEvent(
        title: "En revisión",
        subtitle: "El estatus cambió a revisión técnica.",
        time: "12 Oct, 11:00 AM",
        isDone: true,
      ),
    ],
  ),
];
