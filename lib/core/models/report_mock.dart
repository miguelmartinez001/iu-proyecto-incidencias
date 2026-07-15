class ReportModel {
  final String id;
  final String title;
  final String category;
  final String status;
  final double lat;
  final double lng;
  final String timeAgo;
  final String distance;

  ReportModel({
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.lat,
    required this.lng,
    required this.timeAgo,
    required this.distance,
  });
}

final List<ReportModel> mockReports = [
  ReportModel(
    id: "1",
    title: "Bache profundo en Av. Reforma",
    category: "Baches",
    status: "En revisión",
    lat: 19.3562,
    lng: -99.2995,
    timeAgo: "Hace 2 horas",
    distance: "A 300 m",
  ),
  ReportModel(
    id: "2",
    title: "Luminaria fundida",
    category: "Alumbrado",
    status: "Recibido",
    lat: 19.3570,
    lng: -99.2980,
    timeAgo: "Hace 5 horas",
    distance: "A 1.2 km",
  ),
  ReportModel(
    id: "3",
    title: "Fuga de agua potable",
    category: "Fugas",
    status: "Resuelto",
    lat: 19.3550,
    lng: -99.3001,
    timeAgo: "Ayer",
    distance: "A 800 m",
  ),
];
