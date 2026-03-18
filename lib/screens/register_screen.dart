import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  
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

  void _submitRegistration() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select your Date of Birth"), backgroundColor: Colors.red));
        return;
      }
      if (!(_hasMinLength && _hasUpper && _hasNumber && _hasSpecial)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please meet all password requirements"), backgroundColor: Colors.red));
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registration Successful! Please Login."), backgroundColor: Colors.green));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
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
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  
                  // --- HEADER IDENTICO AL LOGIN PER L'EFFETTO HERO ---
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
                  const Text(
                    "Create Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF003D73), height: 1.1, letterSpacing: -0.5),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "HEALTH FACILITIES PLATFORM",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blue.shade800, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0),
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

                  // --- FORM ---
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildTextField(controller: _firstNameController, hint: "First Name", icon: Icons.person_outline)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildTextField(controller: _lastNameController, hint: "Last Name", icon: Icons.person_outline)),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // DATA DI NASCITA
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
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today_outlined, color: Colors.grey.shade500),
                                const SizedBox(width: 12),
                                Text(
                                  _selectedDate == null ? "Date of Birth" : DateFormat('dd MMM yyyy').format(_selectedDate!),
                                  style: TextStyle(color: _selectedDate == null ? Colors.grey.shade600 : Colors.black87, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // EMAIL
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: _isWhoStaff ? "WHO Email Address" : "Email Address",
                            prefixIcon: const Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) return "Required";
                            if (_isWhoStaff && !value.toLowerCase().endsWith("@who.int")) return "WHO Staff must use a @who.int email";
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // PASSWORD
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: "Create Password",
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // REQUISITI PASSWORD VISIVI
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Password must contain:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
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

                        // BUTTON REGISTRAZIONE
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
                            onPressed: _submitRegistration,
                            child: const Text("Create Account", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // TORNA AL LOGIN
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account? ", style: TextStyle(color: Colors.grey.shade600)),
                            TextButton(
                              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                              child: Text("Sign In", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
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

  Widget _buildTextField({required TextEditingController controller, required String hint, required IconData icon}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      validator: (value) => value == null || value.isEmpty ? "Required" : null,
    );
  }

  Widget _buildRequirement(bool isMet, String text) {
    return Row(
      children: [
        Icon(isMet ? Icons.check_circle : Icons.radio_button_unchecked, color: isMet ? Colors.green : Colors.grey.shade400, size: 16),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isMet ? Colors.green.shade700 : Colors.grey.shade600)),
      ],
    );
  }
}