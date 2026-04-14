import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:provider/provider.dart";
import "package:slack_ui/controllers/auth_controller.dart";
import "package:slack_ui/views/widgets/LogoBanner.dart";
import "../core/app_routes.dart";

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  void _validateForm() {
    if (_isLoading) return;
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    final isNameValid = name.length >= 2;
    final isEmailValid = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
    final isPasswordValid = password.length >= 8;

    final newIsButtonEnabled = isNameValid && isEmailValid && isPasswordValid;
    if (_isButtonEnabled != newIsButtonEnabled) {
      setState(() {
        _isButtonEnabled = newIsButtonEnabled;
      });
    }
  }

  void _handleSignUp() async {
    if (_formKey.currentState!.validate() && !_isLoading) {
      setState(() {
        _isLoading = true;
        _isButtonEnabled = false;
      });

      final auth = context.read<AuthController>();
      final success = await auth.signup(
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.main);
      } else {
        setState(() {
          _isLoading = false;
          _isButtonEnabled = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sign up failed. Check inputs."), backgroundColor: Color(0xFFD93025)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1D21)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Sign Up",
          style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: const Color(0xFF1A1D21)),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE8E8E8), height: 1),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              // Main Slack App Logo Banner
              buildLogoBanner(),
              const SizedBox(height: 40),

              // Full Name Input Section
              Text(
                "Your name",
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1A1D21)),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
                ),
                child: TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.next,
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: const Color(0xFF1A1D21)),
                  decoration: InputDecoration(
                    hintText: "John Doe",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFA1A1A1),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your name";
                    }
                    if (value.trim().length < 2) {
                      return "Name must be at least 2 characters";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Your email address",
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1A1D21)),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
                ),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: const Color(0xFF1A1D21)),
                  decoration: InputDecoration(
                    hintText: "name@work-email.com",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFA1A1A1),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your email";
                    }
                    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Create a password",
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF1A1D21)),
              ),
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
                ),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  textInputAction: TextInputAction.done,
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: const Color(0xFF1A1D21)),
                  decoration: InputDecoration(
                    hintText: "At least 8 characters",
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFA1A1A1),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                        color: const Color(0xFF616061),
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a password";
                    }
                    if (value.length < 8) {
                      return "Password must be at least 8 characters";
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _handleSignUp(),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Use at least 8 characters. We recommend using a mix of letters, numbers, and symbols.",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF616061),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Animated Submit Registration Button
              ElevatedButton(
                onPressed: _isButtonEnabled || _isLoading ? _handleSignUp : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (_isButtonEnabled || _isLoading) ? const Color(0xFF4A154B) : const Color(0xFFE8E8E8),
                  foregroundColor: (_isButtonEnabled || _isLoading) ? Colors.white : const Color(0xFF616061),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text("Continue", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 40),

              // Redirect to Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF616061)),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                    },
                    child: Text(
                      "Sign In",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1264A3),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
