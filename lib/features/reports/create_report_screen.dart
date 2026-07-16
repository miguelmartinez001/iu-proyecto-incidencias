import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../widgets/custom_button.dart';
import '../../widgets/custom_modals.dart';
import '../../core/theme/category_colors.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool _isGridView = true;

  // Estado del Wizard
  final List<String> _photos = [];
  Map<String, dynamic>?
  _selectedCategoryItem; // Almacena el mapa único para evitar bugs de selección
  final TextEditingController _descriptionController = TextEditingController();
  final String _mockAddress = "Av. Juárez 151, Cuajimalpa de Morelos, CDMX";

  // Lista de categorías
  final List<Map<String, dynamic>> _categoriesList = [
    {
      'type': ReportCategory.bache,
      'label': 'Bache',
      'icon': LucideIcons.alertTriangle,
    },
    {
      'type': ReportCategory.alumbrado,
      'label': 'Árbol caído',
      'icon': LucideIcons.treePine,
    },
    {
      'type': ReportCategory.otro,
      'label': 'Basura',
      'icon': LucideIcons.trash2,
    },
    {
      'type': ReportCategory.alumbrado,
      'label': 'Luminaria',
      'icon': LucideIcons.lightbulb,
    },
    {
      'type': ReportCategory.fuga,
      'label': 'Fuga de agua',
      'icon': LucideIcons.droplet,
    },
    {
      'type': ReportCategory.otro,
      'label': 'Señalética',
      'icon': LucideIcons.milestone,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _simulateAddPhoto() {
    if (_photos.length >= 5) return;
    setState(() {
      _photos.add(
        "https://images.unsplash.com/photo-1515162305285-0293e4767cc2?q=80&w=600",
      );
    });
  }

  // Lógica centralizada para validar si el paso actual permite continuar
  bool _isStepValid() {
    if (_currentStep == 0) return _photos.isNotEmpty;
    if (_currentStep == 1) return _selectedCategoryItem != null;
    return true; // Los pasos de mapa y resumen siempre son válidos
  }

  void _onNextStep() {
    if (!_isStepValid()) return;
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.goNamed('success-report');
    }
  }

  void _onPreviousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.animateToPage(
        _currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _showExitModal();
    }
  }

  void _showExitModal() {
    CustomModals.showExitReportModal(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _onPreviousStep();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          // Corrección estática: Uso de puramente Chevron puro sin línea horizontal extendida
          leading: IconButton(
            icon: Icon(
              LucideIcons.chevronLeft,
              color: colorScheme.onSurface,
              size: 28,
            ),
            onPressed: _onPreviousStep,
          ),
          title: Text(
            _currentStep == 3 ? "Resumen del reporte" : "Nuevo reporte",
            style: TextStyle(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          actions: [
            TextButton(
              onPressed: _showExitModal,
              child: const Text(
                "Cancelar",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            if (_currentStep < 3) _buildStepperHeader(colorScheme),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1Photos(colorScheme),
                  _buildStep2Category(colorScheme),
                  _buildStep3Location(colorScheme),
                  _buildStep4Summary(colorScheme),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomButton(
                    text: _currentStep == 3
                        ? "Confirmar y publicar"
                        : "Continuar",
                    onPressed: _isStepValid()
                        ? _onNextStep
                        : () {}, // Mantenemos la función segura
                    isDisabled: !_isStepValid(),
                    icon: _currentStep == 3 ? LucideIcons.send : null,
                  ),
                  if (_currentStep == 3) ...[
                    const SizedBox(height: 12),
                    CustomButton(
                      text: "Regresar a editar",
                      variant: ButtonVariant.outline,
                      onPressed: () {
                        setState(() => _currentStep = 2);
                        _pageController.animateToPage(
                          2,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      icon: LucideIcons.chevronLeft,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperHeader(ColorScheme colorScheme) {
    List<String> stepNames = ["Foto", "Categoría", "Ubicación"];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Paso ${_currentStep + 1} de 3",
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
              Text(
                stepNames[_currentStep],
                style: TextStyle(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(3, (index) {
              bool isActive = index <= _currentStep;
              return Expanded(
                child: Container(
                  height: 6,
                  margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                  decoration: BoxDecoration(
                    color: isActive
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                LucideIcons.checkCircle2,
                size: 14,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 4),
              Text(
                "Guardado automáticamente",
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep1Photos(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Agrega fotos de la incidencia",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          Text(
            "Puedes subir hasta 5 fotos",
            style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 25),
          Wrap(
            spacing: 15,
            runSpacing: 15,
            children: [
              ..._photos.asMap().entries.map((entry) {
                int idx = entry.key;
                String url = entry.value;
                return Stack(
                  children: [
                    Container(
                      width: 95,
                      height: 95,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        // Forzamos el Image.network interno para asegurar que el render del emulador no falle con el caché
                        image: DecorationImage(
                          image: NetworkImage(url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    if (idx == 0)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Principal",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => setState(() => _photos.removeAt(idx)),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            LucideIcons.x,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              if (_photos.length < 5)
                GestureDetector(
                  onTap: () {
                    CustomModals.showAddEvidenceModal(
                      context,
                      onPhotoAdded: _simulateAddPhoto,
                    );
                  },
                  child: Container(
                    width: 95,
                    height: 95,
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.onSurfaceVariant.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          LucideIcons.plus,
                          color: colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Agregar",
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStep2Category(ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Selecciona una categoría",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              // SWITCH DE VISTAS (Combo vs Slider Horizontal)
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        LucideIcons.list,
                        color: _isGridView
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _isGridView = true),
                    ),
                    IconButton(
                      icon: Icon(
                        LucideIcons.grid,
                        color: !_isGridView
                            ? colorScheme.primary
                            : colorScheme.onSurfaceVariant,
                        size: 20,
                      ),
                      onPressed: () => setState(() => _isGridView = false),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          _isGridView
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.15,
                      ),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Map<String, dynamic>>(
                      value: _selectedCategoryItem,
                      hint: Text(
                        "Selecciona tu categoría",
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 14,
                        ),
                      ),
                      isExpanded: true,
                      dropdownColor: colorScheme.surface,
                      icon: Icon(
                        LucideIcons.chevronDown,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      items: _categoriesList.map((cat) {
                        final itemColor = CategoryColors.getColorForCategory(
                          context,
                          cat['type'],
                        );
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: cat,
                          child: Row(
                            children: [
                              Icon(cat['icon'], color: itemColor, size: 20),
                              const SizedBox(width: 12),
                              Text(
                                cat['label'],
                                style: TextStyle(
                                  color: colorScheme.onSurface,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _selectedCategoryItem = value),
                    ),
                  ),
                )
              : SizedBox(
                  height: 120, // Altura para las tarjetas horizontales
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categoriesList.length,
                    itemBuilder: (context, idx) {
                      final cat = _categoriesList[idx];
                      bool isSelected = _selectedCategoryItem == cat;
                      final itemColor = CategoryColors.getColorForCategory(
                        context,
                        cat['type'],
                      );
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategoryItem = cat),
                        child: Container(
                          width: 110,
                          margin: const EdgeInsets.only(
                            right: 12,
                            bottom: 8,
                            top: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? itemColor.withValues(alpha: 0.15)
                                : colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? itemColor
                                  : colorScheme.onSurfaceVariant.withValues(
                                      alpha: 0.1,
                                    ),
                              width: 1.5,
                            ),
                            boxShadow: [
                              if (!isSelected)
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                cat['icon'],
                                color: isSelected
                                    ? itemColor
                                    : colorScheme.onSurfaceVariant,
                                size: 26,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                cat['label'],
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

          const SizedBox(height: 25),
          Text(
            "Descripción",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.15),
              ),
            ),
            child: TextField(
              controller: _descriptionController,
              maxLines: 4,
              style: TextStyle(color: colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: "Describe brevemente la incidencia...",
                hintStyle: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3Location(ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Confirma la ubicación",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: FlutterMap(
                options: const MapOptions(
                  initialCenter: LatLng(19.3562, -99.2995),
                  initialZoom: 15.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.tuusuario.cuajireport',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: const LatLng(19.3562, -99.2995),
                        width: 40,
                        height: 40,
                        child: Icon(
                          LucideIcons.mapPin,
                          color: colorScheme.primary,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 15),
          Container(
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
                Icon(LucideIcons.mapPin, color: colorScheme.primary, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _mockAddress,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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

  Widget _buildStep4Summary(ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Verifica que todo esté correcto",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(
                            _photos.isNotEmpty
                                ? _photos[0]
                                : "https://images.unsplash.com/photo-1515162305285-0293e4767cc2?q=80&w=600",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                _selectedCategoryItem != null
                                    ? _selectedCategoryItem!['icon']
                                    : LucideIcons.alertTriangle,
                                color: colorScheme.primary,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                _selectedCategoryItem != null
                                    ? _selectedCategoryItem!['label']
                                          .toUpperCase()
                                    : "BACHE",
                                style: TextStyle(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _descriptionController.text.isNotEmpty
                                ? _descriptionController.text
                                : "Incidencia sin descripción específica.",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: colorScheme.onSurface,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(),
                ),
                Row(
                  children: [
                    Icon(
                      LucideIcons.mapPin,
                      color: colorScheme.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _mockAddress,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 13,
                        ),
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
