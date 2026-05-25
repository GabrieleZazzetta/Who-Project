import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';
import 'package:responsive_builder/responsive_builder.dart';
import '../models/assessment_models.dart';
import 'assessments_list_screen.dart';
import 'settings_screen.dart';
import '../l10n/app_localizations.dart';

// LOGICA DI NAVIGAZIONE PRINCIPALE
// Gestisce il passaggio tra le sezioni principali tramite la Bottom Bar o Navigation Rail
class MainDashboardScreen extends StatefulWidget {
  final int initialIndex;
  const MainDashboardScreen({super.key, this.initialIndex = 0});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  late int _currentIndex;
  // LOGICA DI STATO: Controllo dell'espansione della barra laterale
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

  // LOGICA DI NAVIGAZIONE ADATTIVA
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    // Calcoliamo l'orientamento reale escludendo lo spazio occupato dalla tastiera virtuale (viewInsets.bottom)
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

  // LAYOUT MOBILE: Adattamento dinamico tra Portrait e Landscape
  Widget _buildMobileLayout({required bool isLandscape}) {
    if (isLandscape) {
      // In modalità orizzontale usiamo il design Premium dell'iPad (Sidebar laterale)
      return Scaffold(
        backgroundColor:
            const Color(0xFF003D73), // Colore di fondo scuro unificato
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

    // In modalità verticale manteniamo la BottomNavigationBar per ergonomia mobile
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  // LAYOUT TABLET E DESKTOP
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

  // COMPONENTI DI NAVIGAZIONE
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

  // Sidebar integrata con gradiente e logo per tablet
  Widget _buildNavigationRail() {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final double expandedWidth = isTablet ? 350 : 280;

    final topPadding = MediaQuery.of(context).padding.top;

    // Calcolo posizione dinamica del tasto menu per Tablet
    double menuTop = 12;
    double menuRight = 12;

    if (isTablet) {
      menuTop = topPadding > 0
          ? topPadding + 8
          : 12; // Estremo superiore sotto la status bar
      // Quando espanso sta a destra, quando collassato si centra (90px larghezza - 48px icon button = 42 -> 21px dal bordo)
      menuRight = _isSidebarExpanded ? 12 : 21;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: _isSidebarExpanded ? expandedWidth : 90,
      decoration: const BoxDecoration(
        color:
            Color(0xFF003D73), // Colore solido profondo per massima continuità
      ),
      child: Stack(
        // Utilizzo Stack per posizionamento assoluto dell'icona menu
        children: [
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                      height: isTablet
                          ? 60
                          : 24), // Spazio per isolare il logo dal menu in alto
                  // Logo centrale: mostrato solo quando la sidebar è espansa
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
                            color: Colors.black.withOpacity(0.2),
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
                    const SizedBox(height: 16), // Ridotto da 24
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      child: SizedBox(
                        width: 248, // 280 - 32 padding
                        child: Text(
                          AppLocalizations.of(context)!.appTitleMultiline,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet
                                ? 24
                                : 16, // Ancora più grande per tablet portrait
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
                          _isSidebarExpanded ? 32 : 32), // Ridotto da 60 a 32
                  // Elementi di navigazione custom per sidebar premium
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
                  // Versione e Info a fondo pagina RIMOSSE per pulizia del design
                ],
              ), // chiude Column
            ), // chiude SingleChildScrollView
          ), // chiude SafeArea

          // PULSANTE MENU GLOBALE RIMOSSO (Ripristinato in sidebar)

          // TASTO MENU PREMIUM (Dinamico)
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
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
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
      ), // chiude Stack
    ); // chiude AnimatedContainer
  }

  // Helper per voci della sidebar premium
  Widget _buildSidebarItem(
      {required IconData icon, required String label, required int index}) {
    final bool isActive = _currentIndex == index;
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Aumento delle scritte e icone specificamente per tablet verticali (isTablet && !isLandscape)
    // per uniformità e resa premium del menu senza toccare altri design (smartphone o tablet landscape che avevano già 18/28)
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
          color: isActive ? Colors.white.withOpacity(0.15) : Colors.transparent,
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
              color: isActive ? color.withOpacity(0.1) : Colors.transparent,
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

// CONTENUTO DELLA HOME
// Visualizza le opzioni di valutazione disponibili (Mpox, Ebola, etc.)
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
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
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
                            color: Colors.black.withOpacity(0.1),
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

  // RENDERING CONTENUTO ADATTIVO
  // Gestisce la visualizzazione in griglia o lista in base allo spazio disponibile
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

  // DISPATCHER LAYOUT
  Widget _buildContent(BuildContext context, {required int columns}) {
    return _buildStandardLayout(context, columns: columns);
  }

  // LAYOUT STANDARD (Mobile Portrait, Tablet Portrait)
  Widget _buildStandardLayout(BuildContext context, {required int columns}) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // LOGICA HEADER: Mostra l'header istituzionale solo su mobile in Portrait.
    // In Landscape (sia mobile che tablet) usiamo il design pulito con Sidebar.
    final bool useFullHeader = !isTablet && !isLandscape;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (useFullHeader)
          _buildMobileHeader(context)
        else
          const SizedBox(
              height: 54), // Spaziatura premium per layout con sidebar

        // GRID DEI MODULI DI VALUTAZIONE
        // L'utilizzo di Transform.translate permette l'effetto "floating" delle card sull'header
        // Disattivato in landscape mobile per massimizzare lo spazio verticale utile
        Expanded(
          child: Transform.translate(
            offset: Offset(0, (useFullHeader && !isLandscape) ? -45 : 0),
            child: (!isTablet && !isLandscape)
                // BINARIO 1: SOLO PER TELEFONO VERTICALE
                // Usa una Column scorrevole che rispetta l'altezza intrinseca naturale (compatta) delle card
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
                // BINARIO 2: TABLET E LANDSCAPE (INTATTI)
                : Center(
                    child: LayoutBuilder(builder: (context, constraints) {
                      final bool isTabletPortrait = isTablet && !isLandscape;
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 1200,
                          minHeight: isTabletPortrait
                              ? constraints.maxHeight
                              : 0, // Forza la centratura verticale su tablet portrait
                        ),
                        child: Column(
                          mainAxisAlignment: isTabletPortrait
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.start,
                          children: [
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: isTabletPortrait ? 1 : columns,
                              childAspectRatio: isTabletPortrait
                                  ? 3.2 // Leggermente ridotto per box più imponenti
                                  : ((isTablet && isLandscape)
                                      ? 2.4
                                      : (isLandscape ? 2.8 : 2.2)),
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: isTabletPortrait ? 0 : 20),
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

  // Header istituzionale per visualizzazione mobile o portrait
  Widget _buildMobileHeader(BuildContext context) {
    final bool isCompact = MediaQuery.of(context).size.width >= 600;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final double logoSize = isCompact
        ? 180.0
        : 230.0; // Calibrazione finale: via di mezzo ideale per autorevolezza ed equilibrio

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
          top: isLandscape ? 12 : 64, // Ridotto drasticamente in landscape
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
          // TASTO INFO: Allineamento adattivo per landscape
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
          // LOGO WHO: Centratura e ridimensionamento Premium per landscape
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
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: isLandscape ? 15 : 30,
                        offset: Offset(0, isLandscape ? 4 : 10)),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(
                      isLandscape ? 8.0 : 24.0), // Padding ridotto in landscape
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

  // COMPONENTI UI: CARDS E LAYOUT
  // Costruisce le card dei moduli con stati attivo/bloccato ispirandosi fedelmente al design Premium originale
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
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Parametrizzazione delle dimensioni per look Premium su Tablet
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
        // Bordi ultra-sottili e premium per una definizione superiore
        border: Border.all(
            color: const Color(0xFFE2E8F0).withOpacity(0.5), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // BARRA LATERALE COLORATA: Spessore ridotto a 4px per un design più sottile
              Container(
                width: 4,
                color: borderColor,
              ),
              Expanded(
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
                          // ICONA MODULO: Box arrotondato con colore tematico
                          Container(
                            padding: EdgeInsets.all(iconBoxPadding),
                            decoration: BoxDecoration(
                              color: iconBgColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(icon, color: iconColor, size: iconSize),
                          ),
                          SizedBox(width: spacing),
                          // INFO E STATO: Titolo, Badge e Sottotitolo
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
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
                                    // BADGE STATO: Design a pillola fedele all'originale
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: badgeBgColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        badgeText.toUpperCase(),
                                        style: TextStyle(
                                          color: badgeColor,
                                          fontSize: badgeSize,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.5,
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
                          // INDICATORE AZIONE: Chevron o Lucchetto
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
      ),
    );
  }
}
