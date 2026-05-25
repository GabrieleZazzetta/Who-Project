import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/assessment_models.dart';
import '../l10n/app_localizations.dart';

// LOGICA DI PRESENTAZIONE E DATI
// Gestisce i metadati delle strutture sanitarie e i calcoli del layout
class FacilitySelectionScreen extends StatefulWidget {
  final EmergencyType emergency;
  const FacilitySelectionScreen({super.key, required this.emergency});

  @override
  State<FacilitySelectionScreen> createState() =>
      _FacilitySelectionScreenState();
}

class _FacilitySelectionScreenState extends State<FacilitySelectionScreen> {
  bool _isSidebarExpanded = true;

  String get _emergencyName {
    switch (widget.emergency) {
      case EmergencyType.mpox:
        return "Mpox";
      case EmergencyType.ebola:
        return "Ebola";
      case EmergencyType.sars:
        return "SARI";
    }
  }

  // DATI STRUTTURA: PALETTE PREMIUM
  // Definisce le tipologie di facility con colori professionali orientati all'ambito sanitario
  List<_FacilityData> get _facilities => [
        const _FacilityData(
          title: "Screening, Triage & Temporary Isolation",
          subtitle: "Early detection at facility entrances.",
          type: FacilityType.screeningAndIsolation,
          isImplemented: true,
          icon: Icons.local_hospital_outlined,
          color: Color(0xFF005DA8), // WHO Blue
        ),
        const _FacilityData(
          title: "Existing Facility with Dedicated Ward",
          subtitle: "Dedicated mpox ward within existing sites..",
          type: FacilityType.existingFacilityWithWard,
          isImplemented: true,
          icon: Icons.apartment_outlined,
          color: Color(0xFF0369A1), // Deep Sky Blue
        ),
        const _FacilityData(
          title: "Stand-Alone Treatment Centre",
          subtitle: "Specialized facility for a larger influx of patients.",
          type: FacilityType.standAloneCenter,
          isImplemented: true,
          icon: Icons.medical_services_outlined,
          color: Color(0xFF0E7490), // Professional Cyan
        ),
        const _FacilityData(
          title: "Congregate Settings",
          subtitle: "Screening and isolation in camps.",
          type: FacilityType.congregateSetting,
          isImplemented: true,
          icon: Icons.holiday_village_outlined,
          color: Color(0xFF475569), // Neutral Slate
        ),
      ];

  // COMPONENTI UI: LAYOUT PRINCIPALE
  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final isLandscape =
                  MediaQuery.of(context).orientation == Orientation.landscape;
              final useSplitLayout = isLandscape && screenWidth >= 900;

              if (useSplitLayout) {
                return _buildSplitLayout(context, constraints: constraints);
              }

              return SafeArea(
                child: _buildStandardLayout(context, constraints: constraints),
              );
            },
          ),
          // PULSANTE MENU GLOBALE RIMOSSO (Ripristinato in sidebar)
        ],
      ),
    );
  }

  // LAYOUT STANDARD (Mobile o Portrait)
  Widget _buildStandardLayout(BuildContext context,
      {required BoxConstraints constraints}) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final int columns = _getColumnCount(context, constraints.maxWidth);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMobileHeader(context),
        Padding(
          padding: EdgeInsets.fromLTRB(24, isTablet ? 40 : 28, 24, 16),
          child: Text(AppLocalizations.of(context)!.selectFacilityType,
              style: TextStyle(
                  fontSize: isTablet ? 28 : 22,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF003D73))),
        ),
        Expanded(
          child: (isPortrait && !isTablet)
              ? ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: _buildGrid(context, columns: columns),
                )
              : Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: _buildGrid(context, columns: columns),
                  ),
                ),
        ),
      ],
    );
  }

  // Header per visualizzazione mobile
  Widget _buildMobileHeader(BuildContext context) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final bool isMobilePortrait = isPortrait && !isTablet;

    return Container(
      height: isTablet ? 80 : 60,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tasto Back a sinistra
          IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: const Color(0xFF003D73), size: isTablet ? 28 : 20),
            onPressed: () => context.pop(),
          ),

          // Titolo: centrato e più grande solo su tablet/mobile portrait
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.facilitiesLabel(_emergencyName),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF003D73),
                fontWeight: FontWeight.w900,
                fontSize: isTablet ? 30 : (isMobilePortrait ? 20 : 18),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Logo WHO a destra
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.asset(
              'assets/images/who_logo_info.png',
              height: isTablet ? 48 : 32,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.public,
                  color: const Color(0xFF005DA8), size: isTablet ? 48 : 32),
            ),
          ),
        ],
      ),
    );
  }

  // LAYOUT SPLIT (Tablet Landscape)
  Widget _buildSplitLayout(BuildContext context,
      {required BoxConstraints constraints}) {
    const int columns = 2;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar sinistra premium con branding
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: _isSidebarExpanded ? 350 : 90,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF003D73), Color(0xFF005DA8)],
            ),
          ),
          child: Stack(
            children: [
              // CONTENUTO SIDEBAR (Logo, Titolo, etc.)
              Column(
                children: [
                  const SizedBox(height: 80),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: _isSidebarExpanded ? 40.0 : 0),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          width: _isSidebarExpanded ? 270 : 90,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isSidebarExpanded) ...[
                                Container(
                                  width: MediaQuery.of(context)
                                              .size
                                              .shortestSide >=
                                          600
                                      ? 190
                                      : 130,
                                  height: MediaQuery.of(context)
                                              .size
                                              .shortestSide >=
                                          600
                                      ? 190
                                      : 130,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Padding(
                                      padding: EdgeInsets.all(_isSidebarExpanded
                                          ? (MediaQuery.of(context)
                                                      .size
                                                      .shortestSide >=
                                                  600
                                              ? 24
                                              : 12)
                                          : 12),
                                      child: Image.asset(
                                        'assets/images/who_logo.png',
                                        fit: BoxFit.contain,
                                        errorBuilder: (context, error,
                                                stackTrace) =>
                                            Icon(Icons.public,
                                                size: _isSidebarExpanded
                                                    ? 60
                                                    : 30,
                                                color: const Color(0xFF005DA8)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height < 500
                                            ? 16
                                            : 32),
                                Text(
                                  AppLocalizations.of(context)!.selectFacilityType,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height < 500
                                            ? 22
                                            : 28,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    height: 1.1,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  AppLocalizations.of(context)!.facilitySelectionDescription(_emergencyName),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height < 500
                                            ? 13
                                            : 15,
                                    color: Colors.white.withOpacity(0.8),
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // TASTO MENU (Dinamico) - POSIZIONATO IN ALTO A DESTRA DELLA SIDEBAR
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: 12,
                left: _isSidebarExpanded ? null : 0,
                right: _isSidebarExpanded ? 12 : 0,
                child: _isSidebarExpanded
                    ? IconButton(
                        icon: Icon(
                            _isSidebarExpanded
                                ? Icons.menu_open_rounded
                                : Icons.menu_rounded,
                            color: Colors.white),
                        onPressed: () => setState(
                            () => _isSidebarExpanded = !_isSidebarExpanded),
                        tooltip: _isSidebarExpanded
                            ? AppLocalizations.of(context)!.collapseMenu
                            : AppLocalizations.of(context)!.expandMenu,
                      )
                    : Center(
                        child: IconButton(
                          icon: Icon(
                              _isSidebarExpanded
                                  ? Icons.menu_open_rounded
                                  : Icons.menu_rounded,
                              color: Colors.white),
                          onPressed: () => setState(
                              () => _isSidebarExpanded = !_isSidebarExpanded),
                          tooltip: _isSidebarExpanded
                              ? AppLocalizations.of(context)!.collapseMenu
                              : AppLocalizations.of(context)!.expandMenu,
                        ),
                      ),
              ),
              // TASTO BACK (Dinamico)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                top: _isSidebarExpanded ? 12 : 55,
                left: _isSidebarExpanded ? 12 : 0,
                right: _isSidebarExpanded ? null : 0,
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white, size: 22),
                    onPressed: () => context.pop(),
                    tooltip: AppLocalizations.of(context)!.back,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Area contenuti destra
        Expanded(
          child: Container(
            color: const Color(0xFFF8FAFC),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: _buildGrid(context, columns: columns),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // COMPONENTI UI: GRIGLIA E CARD
  // Metodi per la generazione dinamica della griglia e delle singole tessere
  Widget _buildGrid(BuildContext context, {required int columns}) {
    final items = _facilities
        .map((f) => _buildFacilityCard(
              context: context,
              data: f,
            ))
        .toList();

    if (columns == 1) {
      final bool isPortrait =
          MediaQuery.of(context).orientation == Orientation.portrait;
      final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
      final bool isMobilePortrait = isPortrait && !isTablet;

      return ListView.separated(
        shrinkWrap: true, // Centratura verticale premium
        padding: EdgeInsets.fromLTRB(24, isMobilePortrait ? 4 : 32, 24,
            32), // Padding superiore ridotto in mobile portrait
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 20),
        itemBuilder: (context, index) => items[index],
      );
    }

    final bool isPortraitGrid =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final bool isTabletGrid = MediaQuery.of(context).size.shortestSide >= 600;
    final bool isIpadLandscape = isTabletGrid && !isPortraitGrid;

    // BINARIO ISOLATO PER IPAD LANDSCAPE E TELEFONO ORIZZONTALE
    final double gridAspectRatio = isIpadLandscape ? 1.9 : ((!isPortraitGrid && !isTabletGrid) ? 2.0 : 2.5);
    final double spacing = isIpadLandscape ? 32.0 : 16.0;

    return GridView.count(
      shrinkWrap: isIpadLandscape ? true : false,
      physics: isIpadLandscape ? const NeverScrollableScrollPhysics() : null,
      crossAxisCount: columns,
      childAspectRatio: gridAspectRatio,
      crossAxisSpacing: spacing,
      mainAxisSpacing: spacing,
      padding: EdgeInsets.symmetric(
          horizontal: isIpadLandscape ? 48.0 : 24.0, 
          vertical: isIpadLandscape ? 0 : 8.0),
      children: items,
    );
  }

  int _getColumnCount(BuildContext context, double width) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    // Layout Premium: in Portrait forziamo 1 colonna così i box sono ampi e leggibili, evitando l'effetto "schiacciato"
    if (isPortrait) return 1;
    if (width >= 900) return 3;
    if (width >= 600) return 2;
    return 1;
  }

  Widget _buildFacilityCard({
    required BuildContext context,
    required _FacilityData data,
  }) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    // Dimensioni dinamiche Premium per Tablet (Orizzontale e Verticale)
    final double cardPadding = isTablet ? 32 : 20;
    final double iconBoxPadding = isTablet ? 16 : 12;
    final double iconSize = isTablet ? 40 : 28;
    final double titleFontSize = isTablet ? 20 : 15;
    final double subtitleFontSize = isTablet ? 16 : 13;
    final double spacing = isTablet ? 24 : 16;

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF0F172A).withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ],
          border: Border.all(color: const Color(0xFFF1F5F9))),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            if (data.isImplemented) {
              if (widget.emergency == EmergencyType.mpox) {
                context.push('/pre-assessment', extra: {
                  'emergencyType': widget.emergency,
                  'facilityType': data.type,
                });
              } else {
                context.push('/map', extra: {
                  'emergencyType': widget.emergency,
                  'facilityType': data.type,
                });
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(AppLocalizations.of(context)!.moduleLockedDevelopment)));
            }
          },
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: (isPortrait && !isTablet)
                // DESIGN MOBILE VERTICALE: Minimalista, senza icone e con riferimento alle figure
                ? Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              data.title,
                              style: const TextStyle(
                                color: Color(0xFF0F172A),
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              data.subtitle,
                              style: TextStyle(
                                color: Colors.blueGrey.shade400,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        data.isImplemented
                            ? Icons.arrow_forward_ios_rounded
                            : Icons.lock_outline_rounded,
                        color: data.isImplemented
                            ? const Color(0xFF005DA8)
                            : Colors.blueGrey.shade200,
                        size: 20,
                      ),
                    ],
                  )
                // DESIGN IPAD / LANDSCAPE: Design originale con icone
                : Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(iconBoxPadding),
                        decoration: BoxDecoration(
                          color: data.color.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child:
                            Icon(data.icon, color: data.color, size: iconSize),
                      ),
                      SizedBox(width: spacing),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(data.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: const Color(0xFF0F172A),
                                    fontWeight: (isTablet && isPortrait)
                                        ? FontWeight.w900
                                        : FontWeight.w800,
                                    fontSize: titleFontSize)),
                            const SizedBox(height: 6),
                            Text(data.subtitle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: Colors.blueGrey.shade400,
                                    fontSize: subtitleFontSize)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                          data.isImplemented
                              ? Icons.arrow_forward_ios_rounded
                              : Icons.lock_outline_rounded,
                          color: data.isImplemented
                              ? const Color(0xFF005DA8)
                              : Colors.blueGrey.shade200,
                          size: 18),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

// MODELLO DATI FACILITY
// Struttura interna per separare i dati dalla presentazione
class _FacilityData {
  final String title;
  final String subtitle;
  final FacilityType type;
  final bool isImplemented;
  final IconData icon;
  final Color color;

  const _FacilityData({
    required this.title,
    required this.subtitle,
    required this.type,
    required this.isImplemented,
    required this.icon,
    required this.color,
  });
}
