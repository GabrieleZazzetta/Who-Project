import 'package:flutter/material.dart';
import '../main.dart'; // Serve per navigare alla Home dopo il login
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Modalità: true = WHO Staff, false = External
  bool _isWhoStaff = true;
  bool _obscurePassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainDashboardScreen()),
      );
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400), // Ottimizzato anche per Web/Tablet
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  
                  // --- HEADER: LOGO ANIMATO (Vola tra login e register) ---
                  Hero(
                    tag: 'who_logo',
                    child: Center(
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset(
                            'assets/images/who_logo.png',
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.public, size: 60, color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // --- TITOLI ---
                  const Text(
                    "Health Facilities\nAssessment Tool",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF003D73), height: 1.1, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 8),
                  
                  // BADGE ROSSO (Sfuma via in modo fluido se è External Partner)
                  AnimatedOpacity(
                    opacity: _isWhoStaff ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 40),
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "AUTHORIZED PERSONNEL ONLY",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red.shade800, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- TOGGLE (WHO vs EXTERNAL) ---
                  Container(
                    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() { _isWhoStaff = true; _emailController.clear(); }),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: _isWhoStaff ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: _isWhoStaff ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : [],
                              ),
                              child: Center(child: Text("WHO Staff", style: TextStyle(fontWeight: _isWhoStaff ? FontWeight.bold : FontWeight.w500, color: _isWhoStaff ? Theme.of(context).colorScheme.primary : Colors.grey.shade600))),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() { _isWhoStaff = false; _emailController.clear(); }),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: !_isWhoStaff ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: !_isWhoStaff ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)] : [],
                              ),
                              child: Center(child: Text("External Partner", style: TextStyle(fontWeight: !_isWhoStaff ? FontWeight.bold : FontWeight.w500, color: !_isWhoStaff ? Theme.of(context).colorScheme.primary : Colors.grey.shade600))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- FORM DI LOGIN ---
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_isWhoStaff ? "WHO ID / Email" : "Partner Email", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: _isWhoStaff ? "e.g. jdoe@who.int" : "name@example.com",
                            prefixIcon: const Icon(Icons.badge_outlined),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Required field";
                            if (_isWhoStaff && !value.toLowerCase().endsWith("@who.int")) return "Must be a valid @who.int email address";
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        
                        const Text("WIMS Password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                          validator: (value) => value == null || value.isEmpty ? "Required field" : null,
                        ),
                        
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Contact Global IT Desk for password reset."))),
                            child: Text("Forgot Password?", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Tasto Login
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 2,
                            ),
                            onPressed: _login,
                            child: const Text("Authenticate", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // REGISTRAZIONE
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account? ", style: TextStyle(color: Colors.grey.shade600)),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                              },
                              child: Text("Register Here", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}