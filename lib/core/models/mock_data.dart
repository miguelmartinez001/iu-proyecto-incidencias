import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

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

class AlertModel {
  final String id;
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color color;
  bool isUnread;

  AlertModel({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
    this.isUnread = true,
  });
}

final List<ReportModel> mockReports = [
  ReportModel(
    id: "1",
    title: "Bache profundo en Av. Juárez 3",
    category: "Baches",
    status: "En Revisión",
    timeAgo: "Hace 2 horas",
    distance: "A 200m",
    isMine: true,
    location: const LatLng(19.3562, -99.2995),
    description: "Bache de gran tamaño sobre el carril derecho.",
    priority: "Alta",
    neighborsConfirmCount: 15,
    believesRepairedCount: 3,
    dateReported: "12 de Oct, 2023",
    history: [
      ReportHistoryEvent(
        title: "Reporte creado",
        subtitle: "Ana Martínez",
        time: "12 Oct, 10:30 AM",
        isDone: true,
      ),
      ReportHistoryEvent(
        title: "Confirmado",
        subtitle: "15 vecinos",
        time: "12 Oct, 02:15 PM",
        isDone: true,
      ),
    ],
  ),
  ReportModel(
    id: "2",
    title: "Sin Luz en el parque",
    category: "Alumbrado",
    status: "Resuelto",
    timeAgo: "Hace 1 día",
    distance: "A 500m",
    isMine: false,
    location: const LatLng(19.3565, -99.3020),
    description: "Parque a oscuras.",
    priority: "Media",
    neighborsConfirmCount: 32,
    believesRepairedCount: 0,
    dateReported: "11 de Oct, 2023",
    history: [],
  ),
];

final List<AlertModel> mockAlertsToday = [
  AlertModel(
    id: "a1",
    title: "15 vecinos respaldan tu reporte",
    description: "Bache en Av. Reforma...",
    time: "Hace 2 horas",
    icon: LucideIcons.users,
    color: Colors.blue,
    isUnread: true,
  ),
  AlertModel(
    id: "a2",
    title: "Reporte marcado como resuelto",
    description: "Luminaria fundida en Calle 4...",
    time: "Hace 5 horas",
    icon: LucideIcons.checkCircle2,
    color: Colors.green,
    isUnread: true,
  ),
];

final List<AlertModel> mockAlertsPrevious = [
  AlertModel(
    id: "a3",
    title: "Nuevo reporte cerca de ti",
    description: "Árbol caído en Parque Central...",
    time: "Ayer",
    icon: LucideIcons.mapPin,
    color: Colors.grey,
    isUnread: false,
  ),
];
