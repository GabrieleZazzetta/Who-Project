import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/assessment_models.dart';
import '../providers/database_provider.dart';
import '../data/facility_data_factory.dart';
import '../data/general_facility_data.dart';
import '../l10n/app_localizations.dart';

class InteractiveMapScreen extends ConsumerStatefulWidget {
  final EmergencyType emergencyType;
  final FacilityType facilityType;
  final int? assessmentId;
  final FacilityLayout? preFilledData;

  const InteractiveMapScreen({
    super.key,
    required this.emergencyType,
    required this.facilityType,
    this.assessmentId,
    this.preFilledData,
  });

  @override
  ConsumerState<InteractiveMapScreen> createState() =>
      _InteractiveMapScreenState();
}

class _InteractiveMapScreenState extends ConsumerState<InteractiveMapScreen>
    with SingleTickerProviderStateMixin {
  // STATE MANAGEMENT
  late FacilityLayout layoutData;
  bool _isLoading = true;
  static const bool _debugMode =
      false; // Toggles visual rendering of touch areas for debugging purposes.
  late AnimationController _pulseController;
  final TransformationController _mapController = TransformationController();
  bool _isSaving = false;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  // DATA & PERSISTENCE MANAGEMENT
  Future<void> _initializeData() async {
    try {
      if (widget.assessmentId != null) {
        final existing = await ref
            .read(databaseServiceProvider)
            .getAssessmentById(widget.assessmentId!);
        if (existing != null) {
          layoutData = existing;
          _ensureGeneralAssessmentZone();
        } else {
          await _createNewAssessment();
        }
      } else if (widget.preFilledData != null) {
        layoutData = widget.preFilledData!;
        _ensureGeneralAssessmentZone();
      } else {
        await _createNewAssessment();
      }
    } catch (e) {
      debugPrint("Errore inizializzazione dati: $e");
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _ensureGeneralAssessmentZone() {
    final hasGeneralZone =
        layoutData.zones.any((z) => z.id == 'general_facility_assessment');
    if (!hasGeneralZone) {
      layoutData.zones = List<SpatialZone>.from(layoutData.zones);
      layoutData.zones.add(getGeneralFacilityZone());
    }
  }

  Future<void> _createNewAssessment() async {
    layoutData = FacilityDataFactory.getLayout(
        widget.emergencyType, widget.facilityType);
    layoutData.dateCreated = DateTime.now().toUtc();
    layoutData.zones = List<SpatialZone>.from(layoutData.zones);
    layoutData.zones.add(getGeneralFacilityZone());
  }

  bool _hasRealAnswers() {
    for (var zone in layoutData.zones) {
      for (var question in zone.checklist) {
        if (question.selectedCompliance != ComplianceLevel.pending &&
            question.selectedCompliance != ComplianceLevel.notApplicable) {
          return true;
        }
      }
    }
    return false;
  }

  Future<void> _saveState() async {
    if (_isSaving) return;
    if (_hasRealAnswers()) {
      _isSaving = true;
      try {
        final savedId =
            await ref.read(databaseServiceProvider).saveAssessment(layoutData);
        layoutData.id = savedId;
      } catch (e) {
        debugPrint("Errore durante il salvataggio dello stato: $e");
      } finally {
        _isSaving = false;
      }
    }
  }

  void _refresh() => setState(() {});

  // MAIN UI COMPONENTS
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body:
            Center(child: CircularProgressIndicator(color: Color(0xFF005DA8))),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildInstructionBanner(),
          Expanded(child: _buildInteractiveMap()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final bool isMobilePortrait = isPortrait && !isTablet;
    final bool isTabletPortrait = isPortrait && isTablet;

    return AppBar(
      toolbarHeight: isTabletPortrait ? 80 : (isMobilePortrait ? 60 : 70),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 1,
      shadowColor: Colors.black.withValues(alpha: 0.2),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new,
            color: const Color(0xFF003D73),
            size: isTabletPortrait ? 28 : (isMobilePortrait ? 20 : 24)),
        onPressed: () {
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/');
          }
        },
      ),
      title: Text(
        AppLocalizations.of(context)!.spatialAssessment,
        style: TextStyle(
          color: const Color(0xFF003D73),
          fontWeight: FontWeight.bold,
          fontSize: isTabletPortrait ? 30 : (isMobilePortrait ? 19 : 22),
        ),
      ),
      actions: [
        _buildAssessmentsListButton(isMobilePortrait),
        _buildGeneralAssessmentButton(isMobilePortrait),
      ],
    );
  }

  Widget _buildAssessmentsListButton(bool isMobilePortrait) {
    return Container(
      margin: EdgeInsets.only(right: isMobilePortrait ? 6 : 8),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
            color: const Color(0xFF005DA8).withValues(alpha: 0.15), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF005DA8).withValues(alpha: 0.05),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(Icons.assignment_outlined,
              color: const Color(0xFF005DA8), size: isMobilePortrait ? 20 : 28),
          tooltip: AppLocalizations.of(context)!.viewSavedAssessments,
          onPressed: () => context.go('/', extra: 1),
          padding: isMobilePortrait
              ? const EdgeInsets.all(6)
              : const EdgeInsets.all(12),
          constraints: isMobilePortrait ? const BoxConstraints() : null,
        ),
      ),
    );
  }

  Widget _buildGeneralAssessmentButton(bool isMobilePortrait) {
    return Container(
      margin: EdgeInsets.only(right: isMobilePortrait ? 10 : 12),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
            color: const Color(0xFF005DA8).withValues(alpha: 0.15), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF005DA8).withValues(alpha: 0.05),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          key: const Key('btn_general_assessment'),
          icon: Icon(Icons.domain_verification,
              color: const Color(0xFF005DA8), size: isMobilePortrait ? 20 : 28),
          tooltip: AppLocalizations.of(context)!.generalAssessment,
          padding: isMobilePortrait
              ? const EdgeInsets.all(6)
              : const EdgeInsets.all(12),
          constraints: isMobilePortrait ? const BoxConstraints() : null,
          onPressed: () async {
            if (_isNavigating) return;
            _isNavigating = true;
            try {
              final zone = layoutData.zones
                  .firstWhere((z) => z.id == 'general_facility_assessment');

              // ROUTES TO ZONE ASSESSMENT
              await context.push('/assessment', extra: zone);
            } finally {
              _isNavigating = false;
            }

            if (!mounted) return;
            await _saveState();
            _refresh();
          },
        ),
      ),
    );
  }

  Widget _buildInstructionBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.pinch_outlined,
              color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.pinchToExplore,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // INTERACTIVE MAP WITH ADAPTIVE MAPPING LOGIC
  // Dynamic reference dimensions
  double get _refWidth {
    switch (widget.facilityType) {
      case FacilityType.existingFacilityWithWard:
        return 800.0;
      case FacilityType.standAloneCenter:
        return 601.0;
      case FacilityType.congregateSetting:
        return 657.0;
      case FacilityType.screeningAndIsolation:
        return 794.0;
    }
  }

  double get _refHeight {
    switch (widget.facilityType) {
      case FacilityType.existingFacilityWithWard:
        return 1131.0;
      case FacilityType.standAloneCenter:
        return 804.0;
      case FacilityType.congregateSetting:
        return 935.0;
      case FacilityType.screeningAndIsolation:
        return 1035.0;
    }
  }

  Widget _buildInteractiveMap() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Computes scale factor based on viewport width to proportionally scale touch coordinates and SVG elements across different device forms.
        final double availableWidth = constraints.maxWidth;
        final double scale = availableWidth / _refWidth;
        final double scaledHeight = _refHeight * scale;

        return ClipRRect(
          child: InteractiveViewer(
            transformationController: _mapController,
            minScale:
                0.5, // Minimum scale ensures the full floor plan is visible on larger tablets without artificial boundaries.
            maxScale: 4.0,
            constrained: false,
            boundaryMargin: const EdgeInsets.all(double.infinity),
            child: SizedBox(
              width: availableWidth,
              height: scaledHeight,
              child: Stack(
                children: [
                  _buildMapBaseImage(),
                  ...layoutData.zones
                      .where((z) => z.id != 'general_facility_assessment')
                      .map((zone) => _buildZoneLayer(zone, scale)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMapBaseImage() {
    return Image.asset(
      layoutData.mapImagePath,
      fit: BoxFit.contain,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => Container(
        color: Colors.grey.shade200,
        child: const Center(child: Text("Caricamento mappa...")),
      ),
    );
  }

  Widget _buildZoneLayer(SpatialZone zone, double scale) {
    final bool isCritical = zone.statusColor == Colors.red.shade600;

    return Positioned.fill(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildTappableArea(zone, scale),
          _buildStatusIndicator(zone, isCritical, scale),
        ],
      ),
    );
  }

  Widget _buildTappableArea(SpatialZone zone, double scale) {
    // Applies computed scale to raw touch area coordinates mapped from the SVG.
    return Positioned(
      top: zone.touchArea.top * scale,
      left: zone.touchArea.left * scale,
      width: zone.touchArea.width * scale,
      height: zone.touchArea.height * scale,
      child: GestureDetector(
        key: Key('zone_${zone.id}'),
        behavior: HitTestBehavior.opaque,
        onTap: () async {
          if (_isNavigating) return;
          _isNavigating = true;
          try {
            await context.push('/assessment', extra: zone);
          } finally {
            _isNavigating = false;
          }
          if (!mounted) return;
          await _saveState();
          _refresh();
        },
        child: Container(
          decoration: BoxDecoration(
            color:
                _debugMode ? Colors.blue.withValues(alpha: 0.3) : Colors.transparent,
            shape: BoxShape.circle,
            border:
                _debugMode ? Border.all(color: Colors.blue, width: 1) : null,
          ),
          child: _debugMode
              ? Center(
                  child: Text(zone.id.substring(0, 2),
                      style: const TextStyle(fontSize: 8, color: Colors.white)))
              : null,
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(
      SpatialZone zone, bool isCritical, double scale) {
    // Calculates an adaptive clamping multiplier for bubble and icon sizes.
    // Prevents status indicators from dominating the view on ultra-wides or becoming invisible on compact screens.
    double multiplier = scale < 1.0 ? 1.0 : scale * 0.8;
    multiplier = multiplier.clamp(0.8, 1.5);

    final double bubbleSize = 20.0 * multiplier;
    final double iconSize = 16.0 * multiplier;

    // Applies computed scale to the position vector of the status indicator.
    return Positioned(
      top: zone.coordinates.top * scale,
      left: zone.coordinates.left * scale,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, _) {
            final double pulseScale =
                isCritical ? 1.0 + (_pulseController.value * 0.3) : 1.0;
            return Transform.scale(
              scale: pulseScale,
              child: Container(
                width: bubbleSize,
                height: bubbleSize,
                decoration: BoxDecoration(
                  color: zone.statusColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color:
                          zone.statusColor.withValues(alpha: isCritical ? 0.8 : 0.4),
                      blurRadius: isCritical ? 15 : 8,
                      spreadRadius: isCritical ? 4 : 1,
                    )
                  ],
                ),
                child: Icon(
                  isCritical ? Icons.priority_high : Icons.check,
                  size: iconSize,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
