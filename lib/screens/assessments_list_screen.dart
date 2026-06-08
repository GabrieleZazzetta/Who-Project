import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../models/assessment_models.dart';
import '../l10n/app_localizations.dart';
import '../providers/database_provider.dart';
import '../services/report_export_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SortOption { newest, scoreHighToLow, scoreLowToHigh }

class AssessmentsListScreen extends ConsumerStatefulWidget {
  const AssessmentsListScreen({super.key});

  @override
  ConsumerState<AssessmentsListScreen> createState() =>
      _AssessmentsListScreenState();
}

class _AssessmentsListScreenState extends ConsumerState<AssessmentsListScreen> {
  // STATE & DATA MANAGEMENT
  bool _isLoading = true;
  List<FacilityLayout> _allAssessments = [];
  List<FacilityLayout> _filteredAssessments = [];
  FacilityLayout?
      _selectedAssessment; // Tracks selected assessment for the Master-Detail tablet layout
  double?
      _userMasterWidth; // Stores custom dragged width for the master panel

  final TextEditingController _searchController = TextEditingController();
  String _currentFilter = 'All';
  DateTime? _filterDate;
  SortOption _currentSort = SortOption.newest;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_applyFilters);
    _loadAssessments();
  }

  // LIFECYCLE MANAGEMENT
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // DATA LOADING & FILTERING
  // Asynchronously retrieves database records and applies text/status filters.
  Future<void> _loadAssessments() async {
    setState(() => _isLoading = true);
    final data = await ref.read(databaseServiceProvider).getAllAssessments();

    if (!mounted) return;

    setState(() {
      _allAssessments = data;
      _isLoading = false;
      if (_allAssessments.isNotEmpty && _selectedAssessment == null) {
        _selectedAssessment = _allAssessments.first;
      }
    });
    _applyFilters();
  }

  // Evaluates assessment status based on zone completion and critical failures
  String _getAssessmentStatus(FacilityLayout facility) {
    int totalQuestions = 0;
    int answeredQuestions = 0;
    bool hasCritical = false;

    for (var zone in facility.zones) {
      totalQuestions += zone.checklist.length;
      for (var q in zone.checklist) {
        if (q.selectedCompliance != ComplianceLevel.pending) {
          answeredQuestions++;
        }
        if (q.isCriticalFailure) {
          hasCritical = true;
        }
      }
    }

    double completionPct =
        totalQuestions == 0 ? 0 : (answeredQuestions / totalQuestions) * 100;

    if (completionPct < 100) return 'In Progress'; // Note: Used in filters
    if (hasCritical) return 'Critical Fails';
    return 'Completed';
  }

  // Filter engine applying text query, status, date and sorting logic
  void _applyFilters() {
    List<FacilityLayout> temp = List.from(_allAssessments);

    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      temp = temp
          .where((f) => f.facilityName.toLowerCase().contains(query))
          .toList();
    }

    if (_currentFilter != 'All') {
      temp =
          temp.where((f) => _getAssessmentStatus(f) == _currentFilter).toList();
    }

    if (_filterDate != null) {
      temp = temp
          .where((f) =>
              f.dateCreated?.year == _filterDate!.year &&
              f.dateCreated?.month == _filterDate!.month &&
              f.dateCreated?.day == _filterDate!.day)
          .toList();
    }

    if (_currentSort == SortOption.newest) {
      temp.sort((a, b) =>
          b.dateCreated?.compareTo(a.dateCreated ?? DateTime.now()) ?? 0);
    } else if (_currentSort == SortOption.scoreHighToLow) {
      temp.sort(
          (a, b) => b.globalReadinessScore.compareTo(a.globalReadinessScore));
    } else if (_currentSort == SortOption.scoreLowToHigh) {
      temp.sort(
          (a, b) => a.globalReadinessScore.compareTo(b.globalReadinessScore));
    }

    setState(() {
      _filteredAssessments = temp;
      if (_selectedAssessment != null && !temp.contains(_selectedAssessment)) {
        _selectedAssessment = temp.isNotEmpty ? temp.first : null;
      }
    });
  }

  // DATA DELETION
  Future<void> _confirmDelete(FacilityLayout facility) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(AppLocalizations.of(context)!.deleteAssessment,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF003D73))),
        content: Text(AppLocalizations.of(context)!.deleteAssessmentConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade600,
                foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ref.read(databaseServiceProvider).deleteAssessment(facility.id);
      if (!mounted) return;
      _loadAssessments();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!.assessmentDeleted),
              backgroundColor: Colors.green),
        );
      }
    }
  }

  // MAIN UI BUILDER
  @override
  Widget build(BuildContext context) {
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final bool isSmallHeight = MediaQuery.of(context).size.height < 500;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: getValueForScreenType<Widget>(
        context: context,
        mobile: _buildMainContent(
            columns: isLandscape ? 2 : 1,
            isLandscape: isLandscape,
            isSmallHeight: isSmallHeight,
            isMasterView: false),
        tablet: _buildMasterDetailLayout(),
        desktop: _buildMasterDetailLayout(),
      ),
    );
  }

  // LIST & GRID COMPONENTS
  Widget _buildMainContent(
      {required int columns,
      required bool isLandscape,
      required bool isSmallHeight,
      bool isMasterView = false}) {
    return RefreshIndicator(
      onRefresh: _loadAssessments,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            title: Text(AppLocalizations.of(context)!.savedAssessments,
                style: const TextStyle(
                    color: Color(0xFF003D73),
                    fontWeight: FontWeight.w900,
                    fontSize: 20)),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: _buildPremiumAnalyticsButton(
                    isCompact: MediaQuery.of(context).size.width < 500),
              )
            ],
          ),

          SliverToBoxAdapter(
            child: _buildSearchAndFilters(isSmallHeight),
          ),

          if (_isLoading)
            const SliverFillRemaining(
                child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF005DA8))))
          else if (_filteredAssessments.isEmpty)
            SliverFillRemaining(child: _buildEmptyState())
          else
            SliverPadding(
              padding: EdgeInsets.all(isSmallHeight ? 12 : 16),
              sliver: SliverLayoutBuilder(
                builder: (context, constraints) {
                  // Grid aspect ratio constraints.
                  // Dynamically interpolates the ratio based on available crossAxisExtent,
                  // particularly for the draggable master column, to prevent pixel overflows.
                  int dynamicColumns = columns;
                  bool isMobileLandscape = isLandscape &&
                      !getValueForScreenType<bool>(
                          context: context, mobile: false, tablet: true);

                  double ratio;
                  if (isMasterView) {
                    ratio =
                        (constraints.crossAxisExtent / 170.0).clamp(1.5, 2.1);
                  } else {
                    ratio = dynamicColumns == 1
                        ? (isSmallHeight ? 1.75 : 2.1)
                        : (isMobileLandscape ? 1.95 : 2.2);
                  }

                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: dynamicColumns,
                      childAspectRatio: ratio,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildAssessmentCard(
                          _filteredAssessments[index],
                          isMasterView: isMasterView,
                          isSmallHeight: isSmallHeight),
                      childCount: _filteredAssessments.length,
                    ),
                  );
                },
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  // MASTER-DETAIL LAYOUT
  // Handles a split-view layout with a user-draggable divider.
  Widget _buildMasterDetailLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;

        // Fallback for tight layouts (e.g., portrait tablet with open side menu).
        // Abandons the split-view to render the master list full-screen.
        if (totalWidth < 600) {
          return Container(
            color: Colors.white,
            child: _buildMainContent(
                columns: 1,
                isLandscape: false,
                isSmallHeight: false,
                isMasterView: false),
          );
        }

        // Default structural allocation: limits master width to ~45% of available space,
        // bounded between 330px and 450px to guarantee readable detail panels.
        double defaultMasterWidth = (totalWidth * 0.45).clamp(330.0, 450.0);

        // Overrides with user's dragged width, clamping between safe thresholds.
        double currentMasterWidth = _userMasterWidth ?? defaultMasterWidth;
        currentMasterWidth = currentMasterWidth.clamp(300.0, totalWidth * 0.7);

        return Row(
          children: [
            // MASTER PANEL
            SizedBox(
              width: currentMasterWidth,
              child: Container(
                color: Colors.white,
                child: _buildMainContent(
                    columns: 1,
                    isLandscape: false,
                    isSmallHeight: false,
                    isMasterView: true),
              ),
            ),

            // DRAGGABLE DIVIDER
            MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onHorizontalDragUpdate: (details) {
                  setState(() {
                    _userMasterWidth = currentMasterWidth + details.delta.dx;
                  });
                },
                onDoubleTap: () {
                  // Reset custom width on double tap
                  setState(() {
                    _userMasterWidth = null;
                  });
                },
                child: Container(
                  width: 12,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border.symmetric(
                        vertical:
                            BorderSide(color: Colors.grey.shade200, width: 1),
                      )),
                  child: Center(
                    child: Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // DETAIL PANEL
            Expanded(
              child: Container(
                color: const Color(0xFFF8FAFC),
                child: _selectedAssessment == null
                    ? _buildEmptyDetailView()
                    : _buildDetailView(_selectedAssessment!),
              ),
            ),
          ],
        );
      },
    );
  }

  // SEARCH & FILTER COMPONENTS
  Widget _buildSearchAndFilters(bool isSmallHeight) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 8),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchAssessment,
                    prefixIcon: const Icon(Icons.search,
                        color: Color(0xFF005DA8), size: 20),
                    suffixIcon: IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_searchController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.clear,
                                  color: Colors.grey, size: 18),
                              onPressed: () {
                                _searchController.clear();
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: VerticalDivider(width: 1, thickness: 1),
                          ),
                          IconButton(
                            icon: const Icon(Icons.map_outlined,
                                color: Color(0xFF005DA8), size: 20),
                            tooltip: AppLocalizations.of(context)!.viewOnMap,
                            onPressed: () => context.push('/global-map'),
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF1F5F9),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Row(
                  children: [
                    _buildUnifiedOptionsButton(),
                    const SizedBox(width: 12),
                    const SizedBox(
                        height: 24, child: VerticalDivider(width: 1)),
                    const SizedBox(width: 12),
                    _buildFilterChip('All'),
                    const SizedBox(width: 8),
                    _buildFilterChip('In Progress'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Completed'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Critical Fails'),
                  ],
                ),
              ),

              if (_allAssessments.isNotEmpty &&
                  !isSmallHeight &&
                  !(MediaQuery.of(context).size.shortestSide < 600 &&
                      MediaQuery.of(context).orientation == Orientation.portrait)) ...[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: _buildGeoStats(),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  // Automatically condenses icon label when rendered in constrained spaces like the Master column.
  Widget _buildPremiumAnalyticsButton({bool isCompact = false}) {
    return InkWell(
      onTap: () => context.push('/analytics'),
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            EdgeInsets.symmetric(horizontal: isCompact ? 12 : 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F2FE),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF005DA8).withValues(alpha: 0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.analytics_rounded,
                color: const Color(0xFF005DA8), size: isCompact ? 22 : 20),
            if (!isCompact) ...[
              const SizedBox(width: 8),
              Text(AppLocalizations.of(context)!.analytics,
                style: const TextStyle(
                  color: Color(0xFF005DA8),
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildUnifiedOptionsButton() {
    return PopupMenuButton<dynamic>(
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF005DA8).withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child:
            const Icon(Icons.tune_rounded, color: Color(0xFF005DA8), size: 20),
      ),
      onSelected: (value) async {
        if (value == 'date') {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: _filterDate ?? DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            setState(() => _filterDate = picked);
            _applyFilters();
          }
        } else if (value is SortOption) {
          setState(() => _currentSort = value);
          _applyFilters();
        } else if (value == 'clear_date') {
          setState(() => _filterDate = null);
          _applyFilters();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          enabled: false,
          child: Text(AppLocalizations.of(context)!.sortBy,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
        ),
        CheckedPopupMenuItem(
          checked: _currentSort == SortOption.newest,
          value: SortOption.newest,
          child: Text(AppLocalizations.of(context)!.newestFirst),
        ),
        CheckedPopupMenuItem(
          checked: _currentSort == SortOption.scoreHighToLow,
          value: SortOption.scoreHighToLow,
          child: Text(AppLocalizations.of(context)!.highestScore),
        ),
        CheckedPopupMenuItem(
          checked: _currentSort == SortOption.scoreLowToHigh,
          value: SortOption.scoreLowToHigh,
          child: Text(AppLocalizations.of(context)!.lowestScore),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          enabled: false,
          child: Text(AppLocalizations.of(context)!.dateFilter,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
        ),
        PopupMenuItem(
          value: 'date',
          child: Row(
            children: [
              const Icon(Icons.date_range_rounded, size: 18),
              const SizedBox(width: 12),
              Text(_filterDate == null
                  ? AppLocalizations.of(context)!.selectDate
                  : DateFormat('dd MMM yyyy').format(_filterDate!)),
            ],
          ),
        ),
        if (_filterDate != null)
          PopupMenuItem(
            value: 'clear_date',
            child:
                Text(AppLocalizations.of(context)!.clearDateFilter, style: const TextStyle(color: Colors.red)),
          ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.noAssessmentsMatch,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildEmptyDetailView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_outlined,
              size: 80, color: Colors.grey.shade200),
          const SizedBox(height: 16),
          Text(AppLocalizations.of(context)!.selectAssessmentToView,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 16)),
        ],
      ),
    );
  }

  // ASSESSMENT DETAIL COMPONENT
  Widget _buildDetailView(FacilityLayout facility) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final detailWidth = constraints.maxWidth;
        final bool isNarrow = detailWidth < 500;
        final double horizontalPadding = isNarrow ? 20.0 : 32.0;

        return SingleChildScrollView(
          padding:
              EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isNarrow)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(facility.facilityName,
                        style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F172A))),
                    const SizedBox(height: 8),
                    Text(
                        "${facility.emergencyType.name.toUpperCase()} ASSESSMENT",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2)),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005DA8),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => _openAssessmentMap(facility),
                        icon: const Icon(Icons.map),
                        label: Text(AppLocalizations.of(context)!.openInteractiveMap,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(facility.facilityName,
                              style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0F172A))),
                          const SizedBox(height: 8),
                          Text(
                              "${facility.emergencyType.name.toUpperCase()} ASSESSMENT",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.2)),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005DA8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => _openAssessmentMap(facility),
                      icon: const Icon(Icons.map),
                      label: Text(AppLocalizations.of(context)!.openInteractiveMap,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              const SizedBox(height: 32),

              Row(
                children: [
                  _buildLargeStatCard(AppLocalizations.of(context)!.criticalFails,
                      _countCriticalFails(facility).toString(), Colors.red,
                      isNarrow: isNarrow),
                  const SizedBox(width: 16),
                  _buildLargeStatCard(AppLocalizations.of(context)!.zonesEvaluated,
                      _countEvaluatedZones(facility).toString(), Colors.green,
                      isNarrow: isNarrow),
                ],
              ),
              const SizedBox(height: 32),

              Text(AppLocalizations.of(context)!.zoneBreakdown,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A))),
              const SizedBox(height: 16),

              ...facility.zones.map((zone) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: isNarrow ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: isNarrow ? 4.0 : 0.0),
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                              color: zone.statusColor, shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: isNarrow
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(zone.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 4),
                                    Text(
                                        "${zone.checklist.where((q) => q.selectedCompliance != ComplianceLevel.pending).length} / ${zone.checklist.length} answered",
                                        style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 12)),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: Text(zone.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                        "${zone.checklist.where((q) => q.selectedCompliance != ComplianceLevel.pending).length} / ${zone.checklist.length} answered",
                                        style: TextStyle(
                                            color: Colors.grey.shade500,
                                            fontSize: 13)),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLargeStatCard(String label, String value, Color color,
      {bool isNarrow = false}) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(isNarrow ? 16 : 24),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: isNarrow ? 11 : 13)),
            const SizedBox(height: 8),
            Text(value,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: isNarrow ? 24 : 32)),
          ],
        ),
      ),
    );
  }

  // NAVIGATION & SUPPORT LOGIC
  int _countEvaluatedZones(FacilityLayout facility) {
    int count = 0;
    for (var zone in facility.zones) {
      final bool hasAnswers = zone.checklist
          .any((q) => q.selectedCompliance != ComplianceLevel.pending);
      if (hasAnswers) {
        count++;
      }
    }
    return count;
  }

  int _countCriticalFails(FacilityLayout facility) {
    int count = 0;
    for (var zone in facility.zones) {
      count += zone.checklist.where((q) => q.isCriticalFailure).length;
    }
    return count;
  }

  void _openAssessmentMap(FacilityLayout facility) async {
    FacilityType typeToOpen = FacilityType.existingFacilityWithWard;
    final savedTypeStr = facility.generalInfo?.assessedFacilityType;

    if (savedTypeStr == "Mpox stand-alone treatment centre") {
      typeToOpen = FacilityType.standAloneCenter;
    } else if (savedTypeStr ==
        "Screening for Internally Displaced People (IDP) and refugee camps") {
      typeToOpen = FacilityType.congregateSetting;
    } else if (savedTypeStr == "Screening and temporary isolation for mpox") {
      typeToOpen = FacilityType.screeningAndIsolation;
    }

    await context.push('/map', extra: {
      'emergencyType': facility.emergencyType,
      'facilityType': typeToOpen,
      'assessmentId': facility.id,
    });

    if (!mounted) return;
    _loadAssessments();
  }

  // SUPPORT & STATS COMPONENTS
  Widget _buildGeoStats() {
    Map<String, List<double>> regionScores = {};
    for (var f in _allAssessments) {
      String region = f.generalInfo?.region ?? '';
      if (region.trim().isEmpty) continue;

      if (!regionScores.containsKey(region)) regionScores[region] = [];
      regionScores[region]!.add(f.globalReadinessScore);
    }

    if (regionScores.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Geographical Overview (Average Readiness)",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          SizedBox(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: regionScores.keys.length,
              itemBuilder: (context, index) {
                String region = regionScores.keys.elementAt(index);
                List<double> scores = regionScores[region]!;
                double average = scores.reduce((a, b) => a + b) / scores.length;

                Color statColor = average >= 80
                    ? Colors.green
                    : (average >= 50 ? Colors.orange : Colors.red);

                return Container(
                  width: 160,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: statColor.withValues(alpha: 0.05),
                    border: Border.all(color: statColor.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        region,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.grey.shade800),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: LinearProgressIndicator(
                              value: average / 100,
                              backgroundColor: Colors.grey.shade200,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(statColor),
                              borderRadius: BorderRadius.circular(4),
                              minHeight: 6,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text("${average.toStringAsFixed(0)}%",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: statColor,
                                  fontSize: 13)),
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ASSESSMENT CARD COMPONENT
  Widget _buildAssessmentCard(FacilityLayout facility,
      {bool isMasterView = false, bool isSmallHeight = false}) {
    int totalQuestions = 0;
    int answeredQuestions = 0;
    int criticalFailsCount = 0;

    for (var zone in facility.zones) {
      totalQuestions += zone.checklist.length;
      for (var q in zone.checklist) {
        if (q.selectedCompliance != ComplianceLevel.pending) {
          answeredQuestions++;
        }
        if (q.isCriticalFailure) criticalFailsCount++;
      }
    }
    double completionPct =
        totalQuestions == 0 ? 0 : (answeredQuestions / totalQuestions) * 100;

    String stateLabel = _getAssessmentStatus(facility);
    Color stateColor;
    if (stateLabel == 'Critical Fails') {
      stateColor = Colors.red.shade600;
    } else if (stateLabel == 'Completed') {
      stateColor = Colors.green.shade600;
    } else {
      stateColor = Colors.orange.shade500;
    }

    final isSelected = _selectedAssessment?.id == facility.id;

    return Card(
      elevation: isSelected ? 0 : 2,
      color: isSelected
          ? const Color(0xFFF0F7FF)
          : Colors.white,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
            color: isSelected ? const Color(0xFF005DA8) : Colors.grey.shade200,
            width: isSelected ? 2 : 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (isMasterView) {
            if (_selectedAssessment?.id == facility.id) {
              // If already selected on Tablet, a secondary click opens the map routing.
              _openAssessmentMap(facility);
            } else {
              setState(() => _selectedAssessment = facility);
            }
          } else {
            setState(() => _selectedAssessment = facility);
            _openAssessmentMap(facility);
          }
        },
        onDoubleTap: () {
          setState(() => _selectedAssessment = facility);
          _openAssessmentMap(facility);
        },
        child: Padding(
          padding:
              EdgeInsets.all(isMasterView ? 14 : (isSmallHeight ? 12 : 20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                facility.facilityName.isEmpty
                                    ? "Unnamed Assessment"
                                    : facility.facilityName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: isSmallHeight
                                        ? 17
                                        : 16, // Leggermente più grande in landscape
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0F172A)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // SYNC INDICATOR
                            Tooltip(
                              message: facility.isDirty
                                  ? "Pending Sync"
                                  : "Synced with Remote API",
                              child: Icon(
                                facility.isDirty
                                    ? Icons.cloud_upload_outlined
                                    : Icons.cloud_done_outlined,
                                size: 18,
                                color: facility.isDirty
                                    ? Colors.orange.shade400
                                    : Colors.blue.shade400,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${facility.emergencyType.name.toUpperCase()} • ${DateFormat('dd MMM yyyy').format(facility.dateCreated ?? DateTime.now())}",
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: stateColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(stateLabel.toUpperCase(),
                        style: TextStyle(
                            color: stateColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 9,
                            letterSpacing: 0.5)),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  _buildMiniStat(
                      "Progress", "${completionPct.toInt()}%", stateColor,
                      isSmallHeight: isSmallHeight),
                  const SizedBox(width: 40),
                  _buildMiniStat("Fails", criticalFailsCount.toString(),
                      criticalFailsCount > 0 ? Colors.red : Colors.green,
                      isSmallHeight: isSmallHeight),
                  const Spacer(),

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.download_rounded,
                            color: Color(0xFF005DA8), size: 22),
                        onPressed: () =>
                            ReportExportService.exportAssessmentToEditableWord(
                                context, facility),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        icon: Icon(Icons.delete_outline,
                            color: Colors.red.shade300, size: 22),
                        onPressed: () => _confirmDelete(facility),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // MINI STAT WIDGET
  Widget _buildMiniStat(String label, String value, Color color,
      {bool isSmallHeight = false}) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: isSmallHeight ? 11 : 10,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: isSmallHeight ? 18 : 16,
                fontWeight: FontWeight.w900,
                color: color)),
      ],
    );
  }

  // FILTER CHIP COMPONENT
  Widget _buildFilterChip(String label) {
    String displayLabel = label;
    if (label == 'All') {
      displayLabel = AppLocalizations.of(context)!.filterAll;
    } else if (label == 'In Progress') {
      displayLabel = AppLocalizations.of(context)!.inProgress;
    } else if (label == 'Completed') {
      displayLabel = AppLocalizations.of(context)!.completed;
    } else if (label == 'Critical Fails') {
      displayLabel = AppLocalizations.of(context)!.criticalFails;
    }

    bool isSelected = _currentFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() => _currentFilter = label);
        _applyFilters();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF005DA8) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
              color:
                  isSelected ? const Color(0xFF005DA8) : Colors.grey.shade300),
        ),
        child: Text(
          displayLabel,

          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
