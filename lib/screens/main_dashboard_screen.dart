import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:responsive_builder/responsive_builder.dart';
import '../models/assessment_models.dart';
import 'assessments_list_screen.dart';
import 'settings_screen.dart';
import '../l10n/app_localizations.dart';

// MAIN NAVIGATION LOGIC
// Manages transitions between core application sections via BottomNavigationBar or NavigationRail.
class MainDashboardScreen extends StatefulWidget {
  final int initialIndex;
  const MainDashboardScreen({super.key, this.initialIndex = 0});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  late int _currentIndex;
  // STATE MANAGEMENT: Sidebar expansion control.
  bool _isSidebarExpanded = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    const HomeContent(),
    const AssessmentsListScreen(),
    const SettingsScreen(),
  ];

  // ADAPTIVE NAVIGATION LOGIC
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    // Computes effective orientation by excluding virtual keyboard overlay space.
    final bool isLandscape =
        size.width > (size.height + mediaQuery.viewInsets.bottom);

    return ScreenTypeLayout.builder(
      mobile: (context) => _buildMobileLayout(isLandscape: isLandscape),
      tablet: (context) => _buildTabletLayout(
          isLandscape:
              MediaQuery.of(context).orientation == Orientation.landscape),
      desktop: (context) => _buildTabletLayout(isLandscape: true),
    );
  }

  // DYNAMIC MOBILE LAYOUT
  Widget _buildMobileLayout({required bool isLandscape}) {
    if (isLandscape) {
      // Applies side navigation rail for mobile landscape view.
      return Scaffold(
        backgroundColor:
            const Color(0xFF003D73),
        body: Row(
          children: [
            _buildNavigationRail(),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: _pages[_currentIndex],
              ),
            ),
          ],
        ),
      );
    }

    // Applies bottom navigation bar for mobile portrait ergonomics.
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // TABLET & DESKTOP LAYOUT
  Widget _buildTabletLayout({required bool isLandscape}) {
    return Scaffold(
      backgroundColor: const Color(0xFF003D73),
      body: Row(
        children: [
          _buildNavigationRail(),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: _pages[_currentIndex],
            ),
          ),
        ],
      ),
    );
  }

  // NAVIGATION COMPONENTS
  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem(icon: Icons.home_filled, label: AppLocalizations.of(context)!.home, index: 0),
                  _buildNavItem(icon: Icons.settings, label: AppLocalizations.of(context)!.settings, index: 2),
                ],
              ),
              _buildNavItem(icon: Icons.assignment, label: AppLocalizations.of(context)!.assessments, index: 1),
            ],
          ),
        ),
      ),
    );
  }

  // ADAPTIVE NAVIGATION RAIL
  Widget _buildNavigationRail() {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final double expandedWidth = isTablet ? 350 : 280;

    final topPadding = MediaQuery.of(context).padding.top;

    // Computes dynamic menu button positioning based on screen insets.
    double menuTop = 12;
    double menuRight = 12;

    if (isTablet) {
      menuTop = topPadding > 0
          ? topPadding + 8
          : 12;
      // Adjusts horizontal padding to center the toggle icon when the sidebar is collapsed.
      menuRight = _isSidebarExpanded ? 12 : 21;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: _isSidebarExpanded ? expandedWidth : 90,
      decoration: const BoxDecoration(
        color:
            Color(0xFF003D73),
      ),
      child: Stack(
        // Uses Stack for absolute positioning of the menu toggle button over the scrolling rail.
        children: [
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                      height: isTablet
                          ? 60
                          : 24),
                  // Renders WHO branding elements exclusively when the navigation rail is expanded.
                  if (_isSidebarExpanded)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: isTablet ? 190 : 130,
                      height: isTablet ? 190 : 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Padding(
                          padding: EdgeInsets.all(
                              _isSidebarExpanded ? (isTablet ? 24 : 12) : 12),
                          child: Image.asset(
                            'assets/images/who_logo.png',
                            height: isTablet ? 190 : 130,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.public,
                                size: _isSidebarExpanded ? 80 : 40,
                                color: const Color(0xFF005DA8)),
                          ),
                        ),
                      ),
                    ),
                  if (_isSidebarExpanded) ...[
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      child: SizedBox(
                        width: 248,
                        child: Text(
                          AppLocalizations.of(context)!.appTitleMultiline,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet
                                ? 24
                                : 16,
                            fontWeight: FontWeight.w900,
                            height: 1.1,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                  SizedBox(
                      height:
                          _isSidebarExpanded ? 32 : 32),
                  // RAIL NAVIGATION ITEMS
                  ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                        horizontal: _isSidebarExpanded ? 16 : 8),
                    children: [
                      _buildSidebarItem(
                          icon: Icons.grid_view_rounded,
                          label: AppLocalizations.of(context)!.dashboard,
                          index: 0),
                      const SizedBox(height: 12),
                      _buildSidebarItem(
                          icon: Icons.assignment_rounded,
                          label: AppLocalizations.of(context)!.assessments,
                          index: 1),
                      const SizedBox(height: 12),
                      _buildSidebarItem(
                          icon: Icons.settings_rounded,
                          label: AppLocalizations.of(context)!.settings,
                          index: 2),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // DYNAMIC MENU TOGGLE
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            top: menuTop,
            right: isTablet
                ? menuRight
                : (_isSidebarExpanded ? 12 : (90 - 44) / 2),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () =>
                    setState(() => _isSidebarExpanded = !_isSidebarExpanded),
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                  ),
                  child: Icon(
                    _isSidebarExpanded
                        ? Icons.menu_open_rounded
                        : Icons.menu_rounded,
                    color: Colors.white,
                    size: isTablet ? 24 : 22,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SIDEBAR ITEM COMPONENT
  Widget _buildSidebarItem(
      {required IconData icon, required String label, required int index}) {
    final bool isActive = _currentIndex == index;
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Calculates typography and icon scales dynamically based on form factor to preserve visual hierarchy.
    final double iconSize = isTablet ? 28 : 24;
    final double fontSize = isTablet ? 18 : 15;
    final double verticalPadding = isTablet ? 16 : 12;

    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(
            horizontal: _isSidebarExpanded ? 16 : 0, vertical: verticalPadding),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withValues(alpha: 0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          child: SizedBox(
            width:
                _isSidebarExpanded ? (isTablet && isLandscape ? 288 : 248) : 74,
            child: Row(
              mainAxisAlignment: _isSidebarExpanded
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                Icon(icon,
                    color: isActive ? Colors.white : Colors.white60,
                    size: iconSize),
                if (_isSidebarExpanded) ...[
                  const SizedBox(width: 16),
                  Text(
                    label,
                    style: TextStyle(
                      color: isActive ? Colors.white : Colors.white60,
                      fontSize: fontSize,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      {required IconData icon, required String label, required int index}) {
    final isActive = _currentIndex == index;
    final color = isActive ? const Color(0xFF005DA8) : const Color(0xFF94A3B8);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.all(isActive ? 6 : 0),
            decoration: BoxDecoration(
              color: isActive ? color.withValues(alpha: 0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: isActive ? 28 : 24),
          ),
          const SizedBox(height: 4),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// HOME DASHBOARD CONTENT
// Renders available health emergency assessment modules.
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  void _showInfoDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Info",
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width > 400
                  ? 400
                  : MediaQuery.of(context).size.width * 0.85,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 30,
                      spreadRadius: 5)
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Image.asset(
                        'assets/images/who_logo_info.png',
                        width: 180,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.public,
                                size: 60, color: Color(0xFF005DA8)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.infoDialogTitle,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.infoDialogBody,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey.shade800, fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005DA8),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(AppLocalizations.of(context)!.close,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 5 * animation.value, sigmaY: 5 * animation.value),
          child: Opacity(opacity: animation.value, child: child),
        );
      },
    );
  }

  // ADAPTIVE CONTENT RENDERING
  // Switches between list and grid views depending on available viewport width and orientation.
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (context) => OrientationLayoutBuilder(
        portrait: (context) => _buildContent(context, columns: 1),
        landscape: (context) => _buildContent(context, columns: 2),
      ),
      tablet: (context) => OrientationLayoutBuilder(
        portrait: (context) => _buildContent(context, columns: 1),
        landscape: (context) => _buildContent(context, columns: 2),
      ),
      desktop: (context) => _buildContent(context, columns: 3),
    );
  }

  // LAYOUT DISPATCHER
  Widget _buildContent(BuildContext context, {required int columns}) {
    return _buildStandardLayout(context, columns: columns);
  }

  // STANDARD LAYOUT
  Widget _buildStandardLayout(BuildContext context, {required int columns}) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // HEADER LOGIC: Displays the institutional header exclusively in mobile portrait mode to maximize vertical space in landscape.
    final bool useFullHeader = !isTablet && !isLandscape;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (useFullHeader)
          _buildMobileHeader(context)
        else
          const SizedBox(
              height: 54),

        // ASSESSMENT MODULES GRID
        // Applies vertical translation to create a floating depth effect over the header, disabled in landscape to save space.
        Expanded(
          child: Transform.translate(
            offset: Offset(0, (useFullHeader && !isLandscape) ? -45 : 0),
            child: (!isTablet)
                // COMPACT SCROLLING COLUMN FOR SMARTPHONES
                ? SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: _buildCards(context)
                            .map((card) => Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: card,
                                ))
                            .toList(),
                      ),
                    ),
                  )
                // GRID LAYOUT FOR TABLETS
                : Center(
                    child: LayoutBuilder(builder: (context, constraints) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 900,
                          minHeight: isTablet
                              ? constraints.maxHeight
                              : 0,
                        ),
                        child: Column(
                          mainAxisAlignment: isTablet
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                          children: [
                            isTablet
                                ? Column(
                                    children: _buildCards(context)
                                        .map((card) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 24),
                                              child: card,
                                            ))
                                        .toList(),
                                  )
                                : GridView.count(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    crossAxisCount: columns,
                                    childAspectRatio: (isLandscape ? 2.8 : 2.2),
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 20,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 20),
                                    children: _buildCards(context),
                                  ),
                          ],
                        ),
                      );
                    }),
                  ),
          ),
        ),
      ],
    );
  }

  // INSTITUTIONAL MOBILE HEADER
  Widget _buildMobileHeader(BuildContext context) {
    final bool isCompact = MediaQuery.of(context).size.width >= 600;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final double logoSize = isCompact
        ? 180.0
        : 230.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
          top: isLandscape ? 12 : 64,
          bottom: isLandscape ? 12 : 80),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF003D73), Color(0xFF005DA8)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(isLandscape ? 16 : 32),
          bottomRight: Radius.circular(isLandscape ? 16 : 32),
        ),
      ),
      child: Stack(
        children: [
          // ADAPTIVE INFO BUTTON
          Positioned(
            top: isLandscape ? 0 : 0,
            right: 0,
            child: IconButton(
              padding: const EdgeInsets.all(8),
              constraints: const BoxConstraints(),
              icon: Icon(Icons.info_outline,
                  color: Colors.white, size: isLandscape ? 24 : 28),
              onPressed: () => _showInfoDialog(context),
            ),
          ),
          // BRANDING SCALING LOGIC
          Transform.translate(
            offset: Offset(0, isLandscape ? 0 : 10),
            child: Center(
              child: Container(
                width: isLandscape ? 80 : logoSize,
                height: isLandscape ? 80 : logoSize,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: isLandscape ? 15 : 30,
                        offset: Offset(0, isLandscape ? 4 : 10)),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                      isLandscape ? 8.0 : 24.0),
                  child: Image.asset(
                    'assets/images/who_logo.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.public,
                        size: isLandscape ? 40 : 80,
                        color: const Color(0xFF005DA8)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCards(BuildContext context) {
    return [
      _buildHTMLCard(
        context: context,
        title: "Mpox Outbreak",
        subtitle: "Clade I / Clade II facilities",
        type: EmergencyType.mpox,
        icon: Icons.coronavirus_outlined,
        iconColor: const Color(0xFF9333EA),
        iconBgColor: const Color(0xFFFAF5FF),
        borderColor: const Color(0xFFA855F7),
        badgeText: AppLocalizations.of(context)!.statusActive,
        badgeColor: const Color(0xFF7E22CE),
        badgeBgColor: const Color(0xFFF3E8FF),
        isActive: true,
      ),
      _buildHTMLCard(
        context: context,
        title: "Ebola Virus Disease",
        subtitle: "Filovirus treatment centres",
        type: EmergencyType.ebola,
        icon: Icons.biotech,
        iconColor: const Color(0xFFDC2626),
        iconBgColor: const Color(0xFFFEF2F2),
        borderColor: const Color(0xFFF87171),
        badgeText: AppLocalizations.of(context)!.statusSoon,
        badgeColor: const Color(0xFF475569),
        badgeBgColor: const Color(0xFFE2E8F0),
        isActive: false,
      ),
      _buildHTMLCard(
        context: context,
        title: "SARI / COVID-19",
        subtitle: "SARI treatment centres",
        type: EmergencyType.sars,
        icon: Icons.masks,
        iconColor: const Color(0xFF0D9488),
        iconBgColor: const Color(0xFFF0FDFA),
        borderColor: const Color(0xFF2DD4BF),
        badgeText: AppLocalizations.of(context)!.statusSoon,
        badgeColor: const Color(0xFF475569),
        badgeBgColor: const Color(0xFFE2E8F0),
        isActive: false,
      ),
    ];
  }

  // MODULE CARD COMPONENT
  Widget _buildHTMLCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required EmergencyType type,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required Color borderColor,
    required String badgeText,
    required Color badgeColor,
    required Color badgeBgColor,
    required bool isActive,
  }) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Responsive dimension parameters based on device type.
    final double cardPadding = isTablet ? 32 : (isLandscape ? 12 : 18);
    final double iconBoxPadding = isTablet ? 18 : 14;
    final double iconSize = isTablet ? 48 : 32;
    final double spacing = isTablet ? 24 : 16;
    final double titleSize = isTablet ? 22 : 16;
    final double subtitleSize = isTablet ? 16 : 13;
    final double badgeSize = isTablet ? 12 : 10;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: const Color(0xFFE2E8F0).withValues(alpha: 0.5), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 4,
              child: Container(color: borderColor),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: isActive
                      ? () => context.push('/facility-selection', extra: type)
                      : () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(AppLocalizations.of(context)!
                                  .moduleLocked))),
                  child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: cardPadding,
                          vertical: isLandscape ? 12 : 28),
                      child: Row(
                        children: [
                          // THEMED MODULE ICON
                          Container(
                            padding: EdgeInsets.all(iconBoxPadding),
                            decoration: BoxDecoration(
                              color: iconBgColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(icon, color: iconColor, size: iconSize),
                          ),
                          SizedBox(width: spacing),
                          // MODULE METADATA
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: Text(
                                        title,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: const Color(0xFF0F172A),
                                          fontWeight: FontWeight.w900,
                                          fontSize: titleSize,
                                          letterSpacing: -0.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    // STATUS BADGE
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: badgeBgColor,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          badgeText.toUpperCase(),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: badgeColor,
                                            fontSize: badgeSize,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  subtitle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: subtitleSize,
                                    color: const Color(0xFF64748B),
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // ACTION INDICATOR
                          Icon(
                            isActive
                                ? Icons.chevron_right_rounded
                                : Icons.lock_outline_rounded,
                            color: const Color(0xFFCBD5E1),
                            size: 26,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
