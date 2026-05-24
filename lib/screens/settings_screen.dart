import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../providers/locale_provider.dart';
import '../services/sync_service.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/user_model.dart';
import '../models/assessment_models.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  void _showLanguageSelector(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    final currentLocale = ref.read(localeProvider);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.chooseLanguage,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildLanguageOption(context, ref, 'English', const Locale('en'), currentLocale),
                _buildLanguageOption(context, ref, 'Italiano', const Locale('it'), currentLocale),
                _buildLanguageOption(context, ref, 'Español', const Locale('es'), currentLocale),
                _buildLanguageOption(context, ref, 'Français', const Locale('fr'), currentLocale),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, WidgetRef ref, String name, Locale locale, Locale currentLocale) {
    final isSelected = locale.languageCode == currentLocale.languageCode;
    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: isSelected ? const Color(0xFF005DA8).withOpacity(0.05) : Colors.transparent,
      title: Text(name, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? const Color(0xFF005DA8) : Colors.black87)),
      trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: Color(0xFF005DA8)) : null,
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(locale);
        Navigator.pop(context);
      },
    );
  }

  // LOGICA DI STATO E SINCRONIZZAZIONE
  // FUNZIONALITÀ PROFILO UTENTE PREMIUM
  void _showUserProfile(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        ),
        child: Column(
          children: [
            // Handle per il drag
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 24),
            Text("User Profile",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.blueGrey.shade900)),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                children: [
                  // Avatar Premium
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFF005DA8).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person,
                          size: 50, color: Color(0xFF005DA8)),
                    ),
                  ),
                  const SizedBox(height: 40),
                  FutureBuilder<UserSession?>(
                    future: DatabaseService.instance.getCurrentSession(),
                    builder: (context, snapshot) {
                      final session = snapshot.data;
                      // Se la sessione è ancora in caricamento, mostriamo un indicatore minimo
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()));
                      }

                      return Column(
                        children: [
                          _buildProfileField("Full Name", session?.displayName ?? "Authorized User"),
                          const SizedBox(height: 20),
                          _buildProfileField("Email Address", session?.email ?? "Email not found"),
                          const SizedBox(height: 20),
                          _buildProfileField("Role / Position", session?.isWhoStaff == true ? "WHO Staff" : "External Partner"),
                          const SizedBox(height: 20),
                          _buildProfileField(
                              "Organization", session?.isWhoStaff == true ? "WHO - World Health Organization" : "Partner Organization"),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 48),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005DA8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Profile updated successfully"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: const Text("Save Changes",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel",
                        style: TextStyle(
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(),
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.grey.shade500,
                letterSpacing: 1.0)),
        const SizedBox(height: 10),
        TextFormField(
          initialValue: value,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF005DA8), width: 2)),
          ),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final syncState = ref.watch(syncProvider);
    final bool isTablet = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: CustomScrollView(
            slivers: [
              // HEADER PREMIUM ADATTIVO
              if (!isTablet)
                Builder(builder: (context) {
                  final bool isPortrait =
                      MediaQuery.of(context).orientation == Orientation.portrait;
                  final bool isMobilePortrait = isPortrait && !isTablet;

                  return SliverAppBar(
                    expandedHeight: isMobilePortrait ? 85 : 120,
                    pinned: true,
                    stretch: true,
                    backgroundColor: Colors.white,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: false,
                      titlePadding: EdgeInsets.only(
                          left: 20, bottom: isMobilePortrait ? 12 : 16),
                      title: Text(l10n.settings,
                          style: TextStyle(
                              color: const Color(0xFF0F172A),
                              fontWeight: FontWeight.w900,
                              fontSize: isMobilePortrait ? 20 : 24)),
                      background: Container(color: Colors.white),
                    ),
                  );
                }),

              // SEZIONE: ACCOUNT & SYNC
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: isTablet
                          ? 40
                          : 16), // Aumentato il padding su tablet per sopperire alla mancanza dell'header
                  child: _buildSectionHeader(l10n.accountAndSync),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildSettingsTile(
                  icon: Icons.person_outline,
                  title: l10n.userProfile,
                  subtitle: "Logistics Officer",
                  onTap: () => _showUserProfile(context),
                ),
              ),
              SliverToBoxAdapter(
                child: FutureBuilder<List<FacilityLayout>>(
                  future: DatabaseService.instance.getAllAssessments(),
                  builder: (context, snapshot) {
                    final assessments = snapshot.data ?? [];
                    final bool hasData = assessments.isNotEmpty;
                    
                    return _buildSettingsTile(
                      icon: syncState.value?.status == SyncStatus.syncing
                          ? Icons.sync_rounded
                          : Icons.cloud_sync_outlined,
                      title: l10n.offlineSync,
                      subtitle: hasData 
                          ? _getSyncSubtitle(syncState.value, assessments) 
                          : "No data to synchronize",
                      trailing: hasData ? _buildSyncTrailing(syncState.value, assessments) : const Icon(Icons.cloud_off, color: Colors.grey, size: 20),
                      onTap: hasData ? () => ref.read(syncProvider.notifier).syncAll() : null,
                    );
                  },
                ),
              ),

              // SEZIONE: PREFERENZE
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: _buildSectionHeader(l10n.preferences),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildSettingsTile(
                  icon: Icons.language,
                  title: l10n.language,
                  subtitle: ref.watch(localeProvider).languageCode == 'it' ? 'Italiano' : 
                            ref.watch(localeProvider).languageCode == 'es' ? 'Español' : 
                            ref.watch(localeProvider).languageCode == 'fr' ? 'Français' : 'English',
                  onTap: () => _showLanguageSelector(context, ref, l10n),
                ),
              ),

              // SEZIONE: ABOUT
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: _buildSectionHeader(l10n.about),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildSettingsTile(
                    icon: Icons.menu_book, title: l10n.whoGuidelines),
              ),
              SliverToBoxAdapter(
                child: _buildSettingsTile(
                    icon: Icons.privacy_tip_outlined, title: l10n.privacyPolicy),
              ),
              SliverToBoxAdapter(
                child: _buildSettingsTile(
                  icon: Icons.info_outline,
                  title: l10n.appVersion,
                  subtitle: "1.0.0-beta",
                  isLink: false,
                ),
              ),

              // AZIONE DI LOGOUT (DESIGN PREMIUM)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 48, 20, 40),
                  child: InkWell(
                    onTap: () async {
                      // 1. Controlla se ci sono dati offline pendenti
                      final db = DatabaseService.instance;
                      var dirtyAssessments = await db.getDirtyAssessments();
                      
                      if (dirtyAssessments.isNotEmpty) {
                        // 2. Sincronizza eventuali dati offline pendenti verso Firebase prima di uscire
                        try {
                          await ref.read(syncProvider.notifier).pushPendingData();
                        } catch (e) {
                          debugPrint("Push fallito durante il logout: $e");
                        }
                        
                        // 3. Ricontrolla se ci sono ancora dati pendenti (es. senza rete)
                        dirtyAssessments = await db.getDirtyAssessments();
                        
                        if (dirtyAssessments.isNotEmpty) {
                          if (context.mounted) {
                            final lang = ref.read(localeProvider).languageCode;
                            final title = lang == 'it' ? "Sincronizzazione necessaria" : "Sync Required";
                            final content = lang == 'it' 
                                ? "Ci sono dati offline non ancora inviati al server. Connettiti a Internet per sincronizzare prima di fare logout, altrimenti andranno persi." 
                                : "You have offline data that hasn't been synced to the server. Please connect to the internet to sync before logging out, otherwise it will be lost.";
                            
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Row(
                                  children: [
                                    const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                                    const SizedBox(width: 8),
                                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                  ],
                                ),
                                content: Text(content),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("OK", style: TextStyle(fontWeight: FontWeight.bold)),
                                  ),
                                ],
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            );
                          }
                          return; // Interrompe il logout
                        }
                      }

                      // 4. LOGICA DI LOGOUT IBRIDA (Firebase + Isar)
                      await ref.read(authServiceProvider).logout();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.red.shade100),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout_rounded,
                              color: Colors.redAccent, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            l10n.logOut,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
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

  // LOGICA DI PRESENTAZIONE SYNC
  // Metodi per la gestione dinamica dei testi e degli indicatori di sincronizzazione
  String _getSyncSubtitle(SyncState? state, List<FacilityLayout> assessments) {
    final bool anyDirty = assessments.any((f) => f.isDirty);
    
    if (state?.status == SyncStatus.syncing) {
      return "Synchronizing data...";
    }

    if (!anyDirty) {
      if (state?.status == SyncStatus.success) return "Last synced: Just now";
      return "All data synchronized";
    }

    switch (state?.status) {
      case SyncStatus.error:
        return "Sync failed. Tap to retry.";
      case SyncStatus.success:
        return "Last synced: Just now";
      case SyncStatus.idle:
      default:
        if (state?.lastSyncedAt == null) return "Never synced";
        return "Last synced: ${DateFormat('HH:mm').format(state!.lastSyncedAt!)}";
    }
  }

  Widget _buildSyncTrailing(SyncState? state, List<FacilityLayout> assessments) {
    final bool anyDirty = assessments.any((f) => f.isDirty);

    if (state?.status == SyncStatus.syncing) {
      return const SizedBox(
        width: 18,
        height: 18,
        child:
            CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF005DA8)),
      );
    }

    if (anyDirty && state?.status == SyncStatus.error) {
      return const Icon(Icons.error_outline, color: Colors.redAccent, size: 20);
    }

    if (!anyDirty) {
      return const Icon(Icons.cloud_done_outlined, color: Colors.green, size: 20);
    }

    return const Icon(Icons.sync_rounded, color: Color(0xFF005DA8), size: 20);
  }

  // COMPONENTI UI: SEZIONI E TILE
  // Definizione dei widget per le intestazioni e le voci di impostazione

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Colors.blueGrey.shade500,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    bool isLink = true,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF005DA8).withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF005DA8), size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Color(0xFF0F172A),
          ),
        ),
        subtitle: subtitle != null
            ? Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  subtitle,
                  style:
                      TextStyle(fontSize: 14, color: Colors.blueGrey.shade500),
                ),
              )
            : null,
        trailing: trailing ??
            (isLink
                ? Icon(Icons.chevron_right_rounded,
                    color: Colors.blueGrey.shade400)
                : null),
        onTap: onTap ?? (isLink ? () {} : null),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
