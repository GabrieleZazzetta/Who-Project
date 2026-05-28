import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../models/local_user_credential.dart';
import '../services/database_service.dart';
import '../providers/database_provider.dart';
import '../services/auth_service.dart';
import '../l10n/app_localizations.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  bool _isWhoStaff = true;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  DateTime? _selectedDate;
  bool _obscurePassword = true;

  bool _hasMinLength = false;
  bool _hasUpper = false;
  bool _hasNumber = false;
  bool _hasSpecial = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() {
      final p = _passwordController.text;
      setState(() {
        _hasMinLength = p.length >= 8;
        _hasUpper = p.contains(RegExp(r'[A-Z]'));
        _hasNumber = p.contains(RegExp(r'[0-9]'));
        _hasSpecial = p.contains(RegExp(r'[!@#\$&*~]'));
      });
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitRegistration() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.dateOfBirthError),
            backgroundColor: Colors.red));
        return;
      }
      if (!(_hasMinLength && _hasUpper && _hasNumber && _hasSpecial)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(AppLocalizations.of(context)!.passwordReqError),
            backgroundColor: Colors.red));
        return;
      }

      setState(() => _isLoading = true);
      try {
        final email = _emailController.text.trim();
        final password = _passwordController.text;
        final displayName =
            "${_firstNameController.text} ${_lastNameController.text}";

        await ref.read(authServiceProvider).register(
              email,
              password,
              isWhoStaff: _isWhoStaff,
              displayName: displayName,
            );

        // SALVATAGGIO CREDENZIALI LOCALI PER ACCESSO OFFLINE / RECUPERO PASSWORD
        final bytes = utf8.encode(password);
        final passwordHash = sha256.convert(bytes).toString();

        await ref.read(databaseServiceProvider).saveLocalCredential(
          LocalUserCredential()
            ..email = email
            ..displayName = displayName
            ..dateOfBirth = _selectedDate
            ..passwordHash = passwordHash
            ..isWhoStaff = _isWhoStaff
            ..passwordNeedsSync = false,
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context)!.registrationSuccess),
              backgroundColor: Colors.green));
          context.go('/');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(AppLocalizations.of(context)!.registrationFailed +
                    e.toString()),
                backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool isTablet = mediaQuery.size.shortestSide >= 600;
    final bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    // LAYOUT PREMIUM PER TABLET (Split View for Landscape, Stacked for Portrait)
    if (isTablet) {
      if (!isLandscape) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Top Header Branding per Tablet Portrait
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF005DA8), Color(0xFF003D73)],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(48),
                      bottomRight: Radius.circular(48),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildLogo(isDark: true),
                      const SizedBox(height: 32),
                      Text(AppLocalizations.of(context)!.joinPlatform,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.1,
                            letterSpacing: -0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.createAccountDescGlobal,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8), fontSize: 16),
                      ),
                      if (_isWhoStaff) ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade400.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.red.shade200.withOpacity(0.3)),
                          ),
                          child: Text(AppLocalizations.of(context)!.authorizedPersonnel,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5)),
                        ),
                      ]
                    ],
                  ),
                ),
                // Form di Registrazione Centrata
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 550),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 60),
                      child: _buildForm(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      // Layout Orizzontale (Landscape) per Tablet
      return Scaffold(
        backgroundColor: Colors.white,
        body: Row(
          children: [
            // PARTE SINISTRA: Branding & Background (Fisso)
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF005DA8),
                      Color(0xFF003D73),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -100,
                      left: -100,
                      child: Container(
                        width: 400,
                        height: 400,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildLogo(isDark: true),
                            const SizedBox(height: 40),
                            Text(AppLocalizations.of(context)!.joinPlatform,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                height: 1.1,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!
                                  .createAccountDescGlobal,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 24),
                            // TAG AUTHORIZED PERSONNEL ONLY (Ripristinato per Tablet)
                            if (_isWhoStaff)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade400.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color:
                                          Colors.red.shade200.withOpacity(0.3)),
                                ),
                                child: Text(AppLocalizations.of(context)!
                                      .authorizedPersonnel,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // PARTE DESTRA: Form di Registrazione (Scorrevole)
            Expanded(
              flex: 1,
              child: Center(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.createAccountTitle,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E293B),
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.createAccountDescAuth,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 40),
                        _buildForm(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // LAYOUT PER SMARTPHONE LANDSCAPE (Premium Rotating View)
    if (isLandscape) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Row(
          children: [
            // Pannello laterale con branding (coerente con tablet)
            Expanded(
              flex: 2,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF005DA8), Color(0xFF003D73)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLogo(isDark: true),
                    const SizedBox(height: 16),
                    Text(AppLocalizations.of(context)!.joinPlatform,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900),
                    ),
                    if (_isWhoStaff)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          // INIZIO MODIFICA: TAG AUTHORIZED PERSONNEL (Mobile Landscape)
                          child: Text(AppLocalizations.of(context)!.authorizedPersonnel,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                          // FINE MODIFICA
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // AREA FORM DI REGISTRAZIONE (Ridimensionata per Mobile Landscape)
            Expanded(
              flex: 3,
              child: Center(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420),
                    child: _buildForm(),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // LAYOUT PER SMARTPHONE PORTRAIT (Premium Mobile)
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header con Gradiente per Mobile
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF005DA8), Color(0xFF003D73)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: Column(
                children: [
                  _buildLogo(isDark: true),
                  const SizedBox(height: 24),
                  Text(AppLocalizations.of(context)!.joinPlatform,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5),
                  ),
                  Text(
                    AppLocalizations.of(context)!.createAccountDescStart,
                    style: TextStyle(
                        fontSize: 16, color: Colors.white.withOpacity(0.8)),
                  ),
                  const SizedBox(height: 16),
                  // TAG AUTHORIZED PERSONNEL ONLY (Ripristinato per Mobile Header)
                  if (_isWhoStaff)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      // TAG AUTHORIZED PERSONNEL ONLY (Ottimizzato per Mobile Portrait)
                      child: Text(AppLocalizations.of(context)!.authorizedPersonnel,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),

            // Area Form
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500.0),
                child: Column(
                  children: [
                    _buildForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // COMPONENTE: LOGO (RIUTILIZZABILE)
  Widget _buildLogo({bool isDark = false}) {
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final double size = isTablet ? 180 : 140;

    return Hero(
      tag: 'who_logo',
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.2)
                  : Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 30.0 : 20.0),
          child: Image.asset(
            'assets/images/who_logo.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.public,
              size: isTablet ? 80 : 60,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  // COMPONENTE: INTESTAZIONE (LOGO E TITOLI)
  Widget _buildHeader({required CrossAxisAlignment alignment}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: alignment,
      children: [
        _buildLogo(),
        const SizedBox(height: 24),
        Text(
          AppLocalizations.of(context)!.createAccountTitle,
          textAlign: alignment == CrossAxisAlignment.center
              ? TextAlign.center
              : TextAlign.start,
          style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Color(0xFF003D73),
              height: 1.1,
              letterSpacing: -0.5),
        ),
        const SizedBox(height: 12),
        if (_isWhoStaff)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4E6), // Pinkish background
              borderRadius: BorderRadius.circular(20),
              border:
                  Border.all(color: const Color(0xFFFDA4AF).withOpacity(0.5)),
            ),
            child: Text(AppLocalizations.of(context)!.authorizedPersonnel,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xFFE11D48),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5),
            ),
          ),
      ],
    );
  }

  // COMPONENTE: FORM DI REGISTRAZIONE
  Widget _buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // SELETTORE MODALITÀ UTENTE
        Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(
                  child: _buildModeToggle(
                      AppLocalizations.of(context)!.whoStaffRole,
                      _isWhoStaff,
                      () => setState(() {
                            _isWhoStaff = true;
                            _emailController.clear();
                          }))),
              Expanded(
                  child: _buildModeToggle(
                      AppLocalizations.of(context)!.externalPartnerRole,
                      !_isWhoStaff,
                      () => setState(() {
                            _isWhoStaff = false;
                            _emailController.clear();
                          }))),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                      child: _buildTextField(
                          controller: _firstNameController,
                          hint: AppLocalizations.of(context)!.firstNameLabel,
                          icon: Icons.person_outline)),
                  const SizedBox(width: 16),
                  Expanded(
                      child: _buildTextField(
                          controller: _lastNameController,
                          hint: AppLocalizations.of(context)!.lastNameLabel,
                          icon: Icons.person_outline)),
                ],
              ),
              const SizedBox(height: 16),
              _buildDatePicker(),
              const SizedBox(height: 16),
              _buildEmailField(),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 12),
              _buildPasswordRequirements(),
              const SizedBox(height: 32),
              _buildSubmitButton(),
              const SizedBox(height: 24),
              _buildLoginNavigation(),
            ],
          ),
        ),
      ],
    );
  }

  // METODI HELPER UI
  Widget _buildModeToggle(String title, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive
              ? [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.05), blurRadius: 4)
                ]
              : [],
        ),
        child: Center(
            child: Text(title,
                style: TextStyle(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade600))),
      ),
    );
  }

  Widget _buildDatePicker() {
    return GestureDetector(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime(2000),
          firstDate: DateTime(1930),
          lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
        );
        if (date != null) setState(() => _selectedDate = date);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today_outlined, color: const Color(0xFF64748B)),
            const SizedBox(width: 12),
            Text(
              _selectedDate == null
                  ? AppLocalizations.of(context)!.dobLabel
                  : DateFormat('dd MMM yyyy').format(_selectedDate!),
              style: TextStyle(
                  color: _selectedDate == null
                      ? Colors.blueGrey.shade300
                      : Colors.black87,
                  fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        hintText: _isWhoStaff
            ? AppLocalizations.of(context)!.whoEmailLabel
            : AppLocalizations.of(context)!.emailLabel,
        prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF64748B)),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF005DA8), width: 2),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty)
          return AppLocalizations.of(context)!.requiredValidation;

        // Regex per validazione formato email
        final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

        if (_isWhoStaff) {
          if (!value.toLowerCase().endsWith("@who.int"))
            return "WHO Staff must use a @who.int email";
        } else {
          if (!emailRegex.hasMatch(value))
            return "Please enter a valid email address";
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.createPasswordLabel,
        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF64748B)),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF005DA8), width: 2),
        ),
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context)!.passwordMustContain,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                  child: _buildRequirement(
                      _hasMinLength, AppLocalizations.of(context)!.chars8Plus)),
              Expanded(child: _buildRequirement(_hasUpper, "1 Uppercase")),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(child: _buildRequirement(_hasNumber, "1 Number")),
              Expanded(
                  child: _buildRequirement(_hasSpecial, "1 Special (!@#)")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
        onPressed: _isLoading ? null : _submitRegistration,
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2))
            : Text(AppLocalizations.of(context)!.createAccountTitle,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5)),
      ),
    );
  }

  Widget _buildLoginNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppLocalizations.of(context)!.alreadyHaveAccount,
            style: TextStyle(color: Colors.grey.shade600)),
        TextButton(
          onPressed: () => context.go('/login'),
          child: Text(AppLocalizations.of(context)!.signInLink,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary)),
        ),
      ],
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String hint,
      required IconData icon}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
        filled: true,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF005DA8), width: 2),
        ),
      ),
      validator: (value) => value == null || value.isEmpty
          ? AppLocalizations.of(context)!.requiredValidation
          : null,
    );
  }

  Widget _buildRequirement(bool isMet, String text) {
    return Row(
      children: [
        Icon(isMet ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isMet ? Colors.green : Colors.grey.shade400, size: 16),
        const SizedBox(width: 6),
        Text(text,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isMet ? Colors.green.shade700 : Colors.grey.shade600)),
      ],
    );
  }
}
