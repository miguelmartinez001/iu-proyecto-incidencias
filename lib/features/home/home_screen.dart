import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(19.3562, -99.2995),
                initialZoom: 14.0,
                interactionOptions: InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.tuusuario.cuajireport',
                ),
              ],
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.1,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(
                      context,
                    ).scaffoldBackgroundColor.withValues(alpha: 0.0),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                ),
              ),
            ),
          ),

          Positioned.fill(
            top: statusBarHeight + 70,
            child: Column(
              children: [
                const Spacer(),

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

                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.transparent,
                    child: _filteredReports.isEmpty
                        ? Center(
                            child: Text(
                              "No se encontraron reportes",
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 10,
                              bottom: 80,
                            ),
                            itemCount: _filteredReports.length,
                            itemBuilder: (context, index) {
                              return _buildReportCard(
                                context,
                                _filteredReports[index],
                                colorScheme,
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
                child: Container(
                  width: double.infinity,
                  height: statusBarHeight + 70,
                  padding: EdgeInsets.only(
                    top: statusBarHeight,
                    left: 20,
                    right: 20,
                    bottom: 15,
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
                    "Reportes Urbanos Cuajimalpa",
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

    return Container(
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
                Text(
                  report.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
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
    );
  }
}
