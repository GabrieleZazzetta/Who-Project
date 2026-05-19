import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import '../models/user_model.dart';
import '../models/local_user_credential.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  
  // Modalità: true = WHO Staff, false = External
  bool _isWhoStaff = true;
  bool _obscurePassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await ref.read(authServiceProvider).login(
          _emailController.text.trim(),
          _passwordController.text,
        );
        if (mounted) context.go('/');
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login failed: ${e.toString()}"), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                  padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 40),
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
                      const Text(
                        "Health Facilities\nAssessment Tool",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.w900, color: Colors.white, height: 1.1, letterSpacing: -0.5),
                      ),
                      if (_isWhoStaff) ...[
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade400.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.red.shade200.withOpacity(0.3)),
                          ),
                          child: const Text("AUTHORIZED PERSONNEL ONLY", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                        ),
                      ]
                    ],
                  ),
                ),
                // Form di Login Centrata
                Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Welcome Back", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: -1)),
                          const SizedBox(height: 8),
                          Text("Sign in to continue your assessment activities.", style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                          const SizedBox(height: 40),
                          _buildForm(),
                        ]
                      ),
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
                    // Elemento decorativo astratto (opzionale)
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
                            const Text(
                              "Health Facilities\nAssessment Tool",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                height: 1.1,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                            // TAG AUTHORIZED PERSONNEL ONLY (Ripristinato per Tablet)
                            if (_isWhoStaff)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade400.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.red.shade200.withOpacity(0.3)),
                                ),
                                child: const Text(
                                  "AUTHORIZED PERSONNEL ONLY",
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
            // PARTE DESTRA: Form di Login (Scorrevole)
            Expanded(
              flex: 1,
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 450),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome Back",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF1E293B),
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Sign in to continue your assessment activities.",
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
                    const Text(
                      "Health Facilities",
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900),
                    ),
                    if (_isWhoStaff)
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          // MODIFICA: Tag personalizzato per mobile landscape
                          child: const Text(
                            "AUTHORIZED PERSONNEL ONLY",
                            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // AREA FORM DI ACCESSO (Ridimensionata per Mobile Landscape)
            Expanded(
              flex: 3,
              child: Center(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                  // MODIFICA: Vincolo di larghezza per mobile landscape
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
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
                  const Text(
                    "Health Facilities",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5),
                  ),
                  Text(
                    "Assessment Tool",
                    style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8)),
                  ),
                  const SizedBox(height: 16),
                  // TAG AUTHORIZED PERSONNEL ONLY (Ripristinato per Mobile Header)
                  if (_isWhoStaff)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      // TAG AUTHORIZED PERSONNEL ONLY (Ottimizzato per Mobile Portrait)
                      child: const Text(
                        "AUTHORIZED PERSONNEL ONLY",
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
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
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
              color: isDark ? Colors.black.withOpacity(0.2) : Colors.black.withOpacity(0.1),
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
          "Health Facilities\nAssessment Tool",
          textAlign: alignment == CrossAxisAlignment.center ? TextAlign.center : TextAlign.start,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF003D73), height: 1.1, letterSpacing: -0.5),
        ),
        const SizedBox(height: 12),
        if (_isWhoStaff)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFFFE4E6), // Pinkish background
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFFDA4AF).withOpacity(0.5)),
            ),
            child: const Text(
              "AUTHORIZED PERSONNEL ONLY",
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFFE11D48), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ),
      ],
    );
  }



  // COMPONENTE: FORM DI AUTENTICAZIONE
  Widget _buildForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // SELETTORE MODALITÀ ACCESSO
        Container(
          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              Expanded(child: _buildModeToggle("WHO Staff", _isWhoStaff, () => setState(() { _isWhoStaff = true; _emailController.clear(); }), key: const Key('toggle_who_staff'))),
              Expanded(child: _buildModeToggle("External Partner", !_isWhoStaff, () => setState(() { _isWhoStaff = false; _emailController.clear(); }), key: const Key('toggle_external_partner'))),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // CREDENZIALI
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFieldLabel(_isWhoStaff ? "WHO ID / Email" : "Partner Email"),
              const SizedBox(height: 8),
              TextFormField(
                key: const Key('input_email'),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _buildInputDecoration(
                  hint: _isWhoStaff ? "e.g. jdoe@who.int" : "name@example.com",
                  icon: Icons.badge_outlined,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Required field";
                  
                  // Regex per validazione formato email
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  
                  if (_isWhoStaff) {
                    if (!value.toLowerCase().endsWith("@who.int")) return "WHO Staff must use a @who.int email";
                  } else {
                    if (!emailRegex.hasMatch(value)) return "Please enter a valid email address";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildFieldLabel("WIMS Password"),
              const SizedBox(height: 8),
              TextFormField(
                key: const Key('input_password'),
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: _buildInputDecoration(
                  icon: Icons.lock_outline,
                  suffix: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                validator: (value) => value == null || value.isEmpty ? "Required field" : null,
              ),
              _buildForgotPasswordButton(),
              const SizedBox(height: 16),
              _buildSubmitButton(),
              const SizedBox(height: 24),
              _buildRegisterNavigation(),
            ],
          ),
        ),
      ],
    );
  }

  // METODI HELPER UI (Semplificano il codice principale)
  Widget _buildModeToggle(String title, bool isActive, VoidCallback onTap, {Key? key}) {
    return GestureDetector(
      key: key,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : [],
        ),
        child: Center(child: Text(title, style: TextStyle(fontWeight: isActive ? FontWeight.bold : FontWeight.w500, color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey.shade600))),
      ),
    );
  }

  Widget _buildFieldLabel(String label) => Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey));

  // DECORAZIONE INPUT FIELD
  InputDecoration _buildInputDecoration({required IconData icon, String? hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: const Color(0xFF64748B)),
      suffixIcon: suffix,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }


  Widget _buildForgotPasswordButton() {
    final mediaQuery = MediaQuery.of(context);
    final bool isTablet = mediaQuery.size.shortestSide >= 600;

    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          if (isTablet) {
            // Visualizzazione Premium Fluttuante Centrata su iPad/Tablet (sia Verticale che Orizzontale)
            showDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 480),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(36),
                    child: ForgotPasswordModal(isWhoStaff: _isWhoStaff),
                  ),
                );
              },
            );
          } else {
            // Visualizzazione standard Bottom Sheet per Smartphone (sia Verticale che Orizzontale)
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                    left: 24,
                    right: 24,
                    top: 32,
                  ),
                  child: ForgotPasswordModal(isWhoStaff: _isWhoStaff),
                );
              },
            );
          }
        },
        child: Text("Forgot Password?", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        key: const Key('btn_authenticate'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
        onPressed: _isLoading ? null : _login,
        child: _isLoading 
          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : const Text("Authenticate", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
      ),
    );
  }

  Widget _buildRegisterNavigation() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text("Don't have an account? ", style: TextStyle(color: Colors.grey.shade600)),
        TextButton(
          onPressed: () => context.go('/register'),
          child: Text("Register Here", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
        ),
      ],
    );
  }
}

// ==========================================
// FORGOT PASSWORD MODAL (OFFLINE RECOVERY)
// ==========================================

class ForgotPasswordModal extends StatefulWidget {
  final bool isWhoStaff;
  const ForgotPasswordModal({super.key, required this.isWhoStaff});

  @override
  State<ForgotPasswordModal> createState() => _ForgotPasswordModalState();
}

class _ForgotPasswordModalState extends State<ForgotPasswordModal> {
  int _step = 1; // 1 = Verify DOB, 2 = Set Password
  bool _loading = false;
  String? _errorMessage;
  LocalUserCredential? _foundCredential;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _verifyIdentity() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = "Please enter your email.");
      return;
    }
    if (_selectedDate == null) {
      setState(() => _errorMessage = "Please select your date of birth.");
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final cred = await DatabaseService.instance.getLocalCredential(email);
      if (cred == null) {
        setState(() {
          _errorMessage = "No matching registered account found locally.";
          _loading = false;
        });
        return;
      }

      // Confronta anno, mese, giorno della data di nascita
      final dob = cred.dateOfBirth;
      if (dob == null ||
          dob.year != _selectedDate!.year ||
          dob.month != _selectedDate!.month ||
          dob.day != _selectedDate!.day) {
        setState(() {
          _errorMessage = "Incorrect Date of Birth for this email.";
          _loading = false;
        });
        return;
      }

      setState(() {
        _foundCredential = cred;
        _step = 2;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Verification failed: ${e.toString()}";
        _loading = false;
      });
    }
  }

  void _submitPasswordReset() async {
    if (!(_hasMinLength && _hasUpper && _hasNumber && _hasSpecial)) {
      setState(() => _errorMessage = "Please meet all password requirements.");
      return;
    }

    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    try {
      final newPassword = _passwordController.text;
      
      // Calcola l'hash della nuova password
      final bytes = utf8.encode(newPassword);
      final passwordHash = sha256.convert(bytes).toString();

      // Memorizziamo la password hashata per offline e quella in chiaro per la sync
      final String? oldPasswordPlain = _foundCredential!.pendingPassword;

      _foundCredential!.passwordHash = passwordHash;
      _foundCredential!.pendingPassword = newPassword;
      if (oldPasswordPlain != null) {
        _foundCredential!.oldPassword = oldPasswordPlain;
      }
      _foundCredential!.passwordNeedsSync = true;
      
      await DatabaseService.instance.saveLocalCredential(_foundCredential!);

      // Crea sessione locale per login immediato
      await DatabaseService.instance.saveSession(UserSession()
        ..uid = "local_${_foundCredential!.id}"
        ..email = _foundCredential!.email
        ..displayName = _foundCredential!.displayName
        ..isLoggedIn = true
        ..isWhoStaff = _foundCredential!.isWhoStaff
        ..lastLogin = DateTime.now().toUtc()
      );

      if (mounted) {
        Navigator.of(context).pop(); // chiude il bottom sheet
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Password reset offline successful! Logged in."),
            backgroundColor: Colors.green,
          ),
        );
        context.go('/');
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Reset failed: ${e.toString()}";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final double modalWidth = mediaQuery.size.width > 500 ? 460 : double.infinity;
    final bool isTablet = mediaQuery.size.shortestSide >= 600;

    final Widget mainContent = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: modalWidth),
      child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header del Modal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _step == 1 ? "Account Recovery" : "Reset Password",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _step == 1
                    ? "Verify your registered identity using your Date of Birth."
                    : "Choose a secure password below to complete your recovery.",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),

              if (_errorMessage != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade700, fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              if (_step == 1) ...[
                // Email Input
                Text(widget.isWhoStaff ? "WHO ID / Email" : "Partner Email", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 8),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: widget.isWhoStaff ? "e.g. jdoe@who.int" : "name@example.com",
                    prefixIcon: Icon(widget.isWhoStaff ? Icons.badge_outlined : Icons.email_outlined, color: const Color(0xFF64748B)),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF005DA8), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Date of Birth Input
                const Text("Date of Birth", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 8),
                GestureDetector(
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
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined, color: Color(0xFF64748B)),
                        const SizedBox(width: 12),
                        Text(
                          _selectedDate == null
                              ? "Date of Birth"
                              : DateFormat('dd MMM yyyy').format(_selectedDate!),
                          style: TextStyle(
                            color: _selectedDate == null ? Colors.blueGrey.shade300 : Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button Step 1
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005DA8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                    onPressed: _loading ? null : _verifyIdentity,
                    child: _loading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("Verify & Continue", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ),
                ),
              ] else ...[
                // Step 2: New Password Input
                const Text("New WIMS Password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 8),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF64748B)),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF005DA8), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Requirements panel
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password must contain:",
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(child: _buildRequirement(_hasMinLength, "8+ Chars")),
                          Expanded(child: _buildRequirement(_hasUpper, "1 Uppercase")),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(child: _buildRequirement(_hasNumber, "1 Number")),
                          Expanded(child: _buildRequirement(_hasSpecial, "1 Special (!@#)")),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Submit Button Step 2
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005DA8),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                    onPressed: _loading ? null : _submitPasswordReset,
                    child: _loading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text("Save & Reset Password", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  ),
                ),
              ],
            ],
          ),
        ),
      );

    if (isTablet) {
      return mainContent;
    } else {
      return Center(child: mainContent);
    }
  }

  Widget _buildRequirement(bool met, String text) {
    return Row(
      children: [
        Icon(
          met ? Icons.check_circle : Icons.circle_outlined,
          color: met ? Colors.green.shade600 : Colors.grey.shade400,
          size: 14,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: met ? Colors.green.shade700 : Colors.grey.shade600,
            fontWeight: met ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
