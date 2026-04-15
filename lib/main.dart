import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // <-- Aggiunto per gestire lo stato
import 'models/assessment_models.dart';
import 'services/database_service.dart'; // <-- Aggiunto per il Database Isar
import 'screens/interactive_map_screen.dart';
import 'screens/assessments_list_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/login_screen.dart';
import 'screens/pre_assessment_screen.dart';

// Cambiamo il main in async per poter attendere l'avvio del database
void main() async {
  // Assicurati che Flutter sia pronto prima di fare operazioni native
  WidgetsFlutterBinding.ensureInitialized();

  // ACCENDIAMO IL DATABASE ISAR!
  await DatabaseService.instance.init();

  runApp(
    // Avvolgiamo l'app in un ProviderScope per Riverpod
    const ProviderScope(
      child: WHOAssessmentApp(),
    ),
  );
}

class WHOAssessmentApp extends StatelessWidget {
  const WHOAssessmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WHO Health Facilities Assessment',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Public Sans',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005DA8),
          primary: const Color(0xFF005DA8),
          surface: const Color(0xFFF5F7F8),
        ),
      ),
      home: const LoginScreen(), // <-- Partiamo dal Login
    );
  }
}

// ----------------------------------------------------------------------
// GESTORE DI NAVIGAZIONE PRINCIPALE (Bottom Bar)
// ----------------------------------------------------------------------
class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  // Indice della pagina attuale (0 = Home, 1 = Assessments, 2 = Settings)
  int _currentIndex = 0;

  // Lista delle 3 schermate
  final List<Widget> _pages = [
    const HomeContent(), // Il design della Home pulita
    const AssessmentsListScreen(), // La lista assessment salvati
    const SettingsScreen(), // Le impostazioni
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // Il corpo cambia dinamicamente in base a _currentIndex (ricaricando sempre i dati freschi!)
      body: _pages[_currentIndex],

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(icon: Icons.home_filled, label: "Home", index: 0),
                _buildNavItem(
                    icon: Icons.assignment, label: "Assessments", index: 1),
                _buildNavItem(
                    icon: Icons.settings, label: "Settings", index: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Costruttore Bottoni Navigazione
  Widget _buildNavItem(
      {required IconData icon, required String label, required int index}) {
    final isActive = _currentIndex == index;
    final color = isActive ? const Color(0xFF005DA8) : const Color(0xFF94A3B8);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          _currentIndex = index; // Cambia pagina!
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

// ----------------------------------------------------------------------
// IL CONTENUTO DELLA HOME
// ----------------------------------------------------------------------
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  // FUNZIONE PER IL POP-UP "INFO"
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
                  // Logo sistemato per il pop-up Info
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
                  const Text("WHO Assessment Tool",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003D73))),
                  const SizedBox(height: 8),
                  Text("Version 1.0.0-beta",
                      style:
                          TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                  const SizedBox(height: 20),
                  Text(
                    "This application provides structural rapid assessment tools for health facilities during infectious disease outbreaks, based on official WHO guidelines.",
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
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      // Effetto sfocato di sfondo quando si apre
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return BackdropFilter(
          filter: ImageFilter.blur(
              sigmaX: 5 * animation.value, sigmaY: 5 * animation.value),
          child: Opacity(opacity: animation.value, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // HEADER PULITO CON SOLO LOGO GIGANTE
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(
                  top: 80, bottom: 64, left: 24, right: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF003D73), Color(0xFF005DA8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Container(
                  width: 220, // <-- LOGO GIGANTE
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(32.0), // Spazio bianco interno
                    child: Image.asset(
                      'assets/images/who_logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.public,
                          size: 80,
                          color: Color(0xFF005DA8)),
                    ),
                  ),
                ),
              ),
            ),

            // LISTA DELLE CARD
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, -32),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                        maxWidth: 600), // LARGHEZZA MAX PER IL WEB
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        _buildHTMLCard(
                          context: context,
                          title: "Mpox Outbreak",
                          subtitle: "Clade I / Clade II guidelines",
                          type: EmergencyType.mpox,
                          icon: Icons.coronavirus_outlined,
                          iconColor: const Color(0xFF9333EA),
                          iconBgColor: const Color(0xFFFAF5FF),
                          borderColor: const Color(0xFFA855F7),
                          badgeText: "Active",
                          badgeColor: const Color(0xFF7E22CE),
                          badgeBgColor: const Color(0xFFF3E8FF),
                          isActive: true,
                        ),
                        const SizedBox(height: 16),
                        _buildHTMLCard(
                          context: context,
                          title: "Ebola Virus Disease",
                          subtitle: "Filovirus structural guidelines",
                          type: EmergencyType.ebola,
                          icon: Icons.biotech,
                          iconColor: const Color(0xFFDC2626),
                          iconBgColor: const Color(0xFFFEF2F2),
                          borderColor: const Color(0xFFF87171),
                          badgeText: "Soon",
                          badgeColor: const Color(0xFF475569),
                          badgeBgColor: const Color(0xFFE2E8F0),
                          isActive: false,
                        ),
                        const SizedBox(height: 16),
                        _buildHTMLCard(
                          context: context,
                          title: "SARI / COVID-19",
                          subtitle: "Respiratory isolation centers",
                          type: EmergencyType.sars,
                          icon: Icons.masks,
                          iconColor: const Color(0xFF0D9488),
                          iconBgColor: const Color(0xFFF0FDFA),
                          borderColor: const Color(0xFF2DD4BF),
                          badgeText: "Soon",
                          badgeColor: const Color(0xFF475569),
                          badgeBgColor: const Color(0xFFE2E8F0),
                          isActive: false,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        // TASTO INFO CON FUNZIONALITÀ CLICK
        Positioned(
          top: 48,
          right: 16,
          child: GestureDetector(
            onTap: () => _showInfoDialog(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle),
                  child: const Icon(Icons.info_outline,
                      color: Colors.white, size: 24),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Costruttore Card
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
    return Opacity(
      opacity: isActive ? 1.0 : 0.65,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 1))
          ],
          border: Border(left: BorderSide(color: borderColor, width: 4)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: isActive
                ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            FacilitySelectionScreen(emergency: type)))
                : () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Module currently locked."))),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(12)),
                    child: Icon(icon, color: iconColor, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                                child: Text(title,
                                    style: const TextStyle(
                                        color: Color(0xFF0F172A),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17))),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                  color: badgeBgColor,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Text(badgeText.toUpperCase(),
                                  style: TextStyle(
                                      color: badgeColor,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(subtitle,
                            style: const TextStyle(
                                color: Color(0xFF64748B), fontSize: 14)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(isActive ? Icons.chevron_right : Icons.lock_outline,
                      color: const Color(0xFFCBD5E1), size: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// SCHERMATA SELEZIONE STRUTTURA
// ----------------------------------------------------------------------
class FacilitySelectionScreen extends StatelessWidget {
  final EmergencyType emergency;
  const FacilitySelectionScreen({super.key, required this.emergency});

  String get _emergencyName {
    switch (emergency) {
      case EmergencyType.mpox:
        return "Mpox";
      case EmergencyType.ebola:
        return "Ebola";
      case EmergencyType.sars:
        return "SARI";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.2),
        iconTheme: const IconThemeData(color: Color(0xFF003D73)),
        title: Text("$_emergencyName Facilities",
            style: const TextStyle(
                color: Color(0xFF003D73),
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: Image.asset(
              'assets/images/who_logo_info.png',
              height: 50,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.public, color: Color(0xFF005DA8)),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Text("Select Facility Type",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.primary)),
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildFacilityItem(
                        context: context,
                        title: "Screening, Triage & Temporary Isolation",
                        subtitle:
                            "Fig. 2 - Tents/Temporary structures for early detection.",
                        type: FacilityType.screeningAndIsolation,
                        isImplemented: false),
                    _buildFacilityItem(
                        context: context,
                        title: "Existing Facility with Dedicated Ward",
                        subtitle: "Fig. 4 - Repurposed wing within a hospital.",
                        type: FacilityType.existingFacilityWithWard,
                        isImplemented: true),
                    _buildFacilityItem(
                        context: context,
                        title: "Stand-Alone Treatment Centre",
                        subtitle:
                            "Fig. 5 - Large scale temporary treatment center.",
                        type: FacilityType.standAloneCenter,
                        isImplemented: true),
                    _buildFacilityItem(
                        context: context,
                        title: "Congregate Settings (Camps)",
                        subtitle:
                            "Fig. 6 - For refugee camps and crowded settings.",
                        type: FacilityType.congregateSetting,
                        isImplemented: true),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFacilityItem(
      {required BuildContext context,
      required String title,
      required String subtitle,
      required FacilityType type,
      required bool isImplemented}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ]),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13))),
        trailing: Icon(
            isImplemented ? Icons.arrow_forward_ios : Icons.lock_outline,
            color: isImplemented
                ? Theme.of(context).colorScheme.primary
                : Colors.grey.shade400,
            size: 18),
        onTap: () {
          if (isImplemented) {
            if (emergency == EmergencyType.mpox) {
              // SE È MPOX: Passa prima dal form dei metadati!
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PreAssessmentScreen(
                            emergencyType: emergency,
                            facilityType: type,
                          )));
            } else {
              // PER LE ALTRE MALATTIE: Va dritto alla mappa (per ora)
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InteractiveMapScreen(
                          emergencyType: emergency, facilityType: type)));
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Module locked or in development.")));
          }
        },
      ),
    );
  }
}
