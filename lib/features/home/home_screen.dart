import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/models/report_mock.dart';
import '../../core/theme/category_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = "";
  String _selectedFilter = "Todos";
  final _searchController = TextEditingController();
  final List<String> _filters = ["Todos", "Baches", "Alumbrado", "Fugas"];

  List<ReportModel> get _filteredReports {
    return mockReports.where((report) {
      final matchesSearch =
          report.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          report.category.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFilter =
          _selectedFilter == "Todos" || report.category == _selectedFilter;
      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Stack(
        children: [
          // 1. TODO EL CONTENIDO ESCROLEABLE
          SingleChildScrollView(
            child: Column(
              children: [
                // El mapa ahora tiene una altura fija y escrolea con la página
                // 1. EL MAPA
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: Stack(
                    children: [
                      FlutterMap(
                        options: const MapOptions(
                          initialCenter: LatLng(19.3562, -99.2995),
                          initialZoom:
                              14.5, // Un poco más cerca para que luzca mejor
                          interactionOptions: InteractionOptions(
                            flags: InteractiveFlag
                                .all, // <-- ¡AHORA SÍ ES INTERACTIVO! (Zoom, arrastrar, etc.)
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.tuusuario.cuajireport',
                          ),

                          // CAPA DE MARCADORES (Aquí dibujamos tu posición)
                          // CAPA DE MARCADORES (Dinámica)
                          // CAPA DE MARCADORES (Dinámica y protegida contra nulos)
                          MarkerLayer(
                            markers: [
                              // 1. FILTRAMOS Y MAPEAMOS LOS REPORTES DEL MOCK
                              ..._filteredReports
                                  .where(
                                    (report) => report.location != null,
                                  ) // <-- PROTECCIÓN ANTI-CRASH
                                  .map((report) {
                                    // Parseamos la categoría para los colores
                                    ReportCategory parsedCategory;
                                    final catStr = report.category
                                        .toLowerCase();
                                    if (catStr.contains('bache')) {
                                      parsedCategory = ReportCategory.bache;
                                    } else if (catStr.contains('alumbrado') ||
                                        catStr.contains('luz')) {
                                      parsedCategory = ReportCategory.alumbrado;
                                    } else if (catStr.contains('fuga') ||
                                        catStr.contains('agua')) {
                                      parsedCategory = ReportCategory.fuga;
                                    } else {
                                      parsedCategory = ReportCategory.otro;
                                    }

                                    // Seleccionamos el icono correcto según la categoría
                                    IconData markerIcon =
                                        LucideIcons.alertCircle;
                                    if (parsedCategory == ReportCategory.bache)
                                      markerIcon = LucideIcons.alertTriangle;
                                    if (parsedCategory ==
                                        ReportCategory.alumbrado)
                                      markerIcon = LucideIcons.lightbulb;
                                    if (parsedCategory == ReportCategory.fuga)
                                      markerIcon = LucideIcons.droplet;

                                    return Marker(
                                      point: report
                                          .location, // Aquí ya es seguro que no es nulo
                                      width: 36,
                                      height: 36,
                                      child: _buildMapMarker(
                                        context,
                                        markerIcon,
                                        parsedCategory,
                                      ),
                                    );
                                  }),

                              // 2. INDICADOR DEL USUARIO (El punto azul fijo al final)
                              Marker(
                                point: const LatLng(19.3562, -99.2995),
                                width: 40,
                                height: 40,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      width: 28,
                                      height: 28,
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withValues(
                                          alpha: 0.25,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Container(
                                      width: 14,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.15,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Degradado para que el mapa se funda con el fondo
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 80,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Theme.of(context).scaffoldBackgroundColor
                                    .withValues(alpha: 0.0),
                                Theme.of(context).scaffoldBackgroundColor,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Buscador
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) =>
                          setState(() => _searchQuery = value),
                      style: TextStyle(color: colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: "Buscar reportes cercanos",
                        hintStyle: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          LucideIcons.search,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),

                // Filtros
                SizedBox(
                  height: 35,
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
                                  : colorScheme.onSurfaceVariant.withValues(
                                      alpha: 0.2,
                                    ),
                            ),
                          ),
                          child: Text(
                            filter,
                            style: TextStyle(
                              color: isSelected
                                  ? colorScheme.onPrimary
                                  : colorScheme.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),

                // Lista de Tarjetas (shrinkWrap es vital aquí para que no marque error de layout)
                _filteredReports.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Text(
                          "No se encontraron reportes",
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          top: 10,
                          bottom: 100,
                        ),
                        physics:
                            const NeverScrollableScrollPhysics(), // Desactiva scroll interno
                        shrinkWrap: true, // Se adapta a la altura de sus hijos
                        itemCount: _filteredReports.length,
                        itemBuilder: (context, index) {
                          return _buildReportCard(
                            context,
                            _filteredReports[index],
                            colorScheme,
                          );
                        },
                      ),
              ],
            ),
          ),

          // 2. HEADER DE CRISTAL (Fijo arriba)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                child: Container(
                  width: double.infinity,
                  height: statusBarHeight + 60,
                  padding: EdgeInsets.only(
                    top: statusBarHeight,
                    left: 20,
                    right: 20,
                    bottom: 10,
                  ),
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                    color: colorScheme.surface.withValues(alpha: 0.7),
                    border: Border(
                      bottom: BorderSide(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.1,
                        ),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    "Reportes Urbanos",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    ReportModel report,
    ColorScheme colorScheme,
  ) {
    ReportCategory parsedCategory;
    final catStr = report.category.toLowerCase();
    if (catStr.contains('bache')) {
      parsedCategory = ReportCategory.bache;
    } else if (catStr.contains('alumbrado') || catStr.contains('luz')) {
      parsedCategory = ReportCategory.alumbrado;
    } else if (catStr.contains('fuga') || catStr.contains('agua')) {
      parsedCategory = ReportCategory.fuga;
    } else {
      parsedCategory = ReportCategory.otro;
    }

    final Color categoryColor = CategoryColors.getColorForCategory(
      context,
      parsedCategory,
    );

    IconData iconData;
    if (report.status == "Resuelto") {
      iconData = LucideIcons.checkCircle;
    } else if (report.status == "En revisión") {
      iconData = LucideIcons.construction;
    } else {
      iconData = LucideIcons.fileText;
    }

    return GestureDetector(
      onTap: () {
        context.push('/report-detail', extra: report);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: categoryColor, width: 5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: categoryColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(iconData, color: categoryColor, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Fila con el título y el Badge de "Tú"
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          report.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      if (report.isMine == true) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            "Mío",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        LucideIcons.mapPin,
                        size: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${report.timeAgo} • ${report.distance}",
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapMarker(
    BuildContext context,
    IconData icon,
    ReportCategory category,
  ) {
    final color = CategoryColors.getColorForCategory(context, category);

    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }
}
