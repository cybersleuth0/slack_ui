import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:provider/provider.dart";
import "../core/app_routes.dart";
import "../controllers/auth_controller.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final Future<void> _fontsPending;

  bool _fontsLoaded = false;

  @override
  void initState() {
    super.initState();
    _fontsPending = _preloadFonts();
    _initializeApp();
  }

  Future<void> _preloadFonts() async {
    await GoogleFonts.pendingFonts([
      GoogleFonts.inter(fontWeight: FontWeight.w400),
      GoogleFonts.inter(fontWeight: FontWeight.w500),
      GoogleFonts.inter(fontWeight: FontWeight.w600),
      GoogleFonts.inter(fontWeight: FontWeight.w700),
      GoogleFonts.inter(fontWeight: FontWeight.w800),
      GoogleFonts.inter(fontWeight: FontWeight.w900),
    ]);

    _preloadOtherFonts();
  }

  Future<void> _preloadOtherFonts() async {
    await GoogleFonts.pendingFonts([
      GoogleFonts.inter(fontWeight: FontWeight.w300),
      GoogleFonts.inter(fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
    ]);
  }

  Future<void> _initializeApp() async {
    // 1. Give the splash screen UI time to construct its first frame
    await Future.delayed(const Duration(milliseconds: 100));

    // 2. Wait for fonts to finish
    await _fontsPending;

    if (mounted) {
      setState(() {
        _fontsLoaded = true; // Triggers the AnimatedOpacity perfectly once
      });

      // Precache the Slack image to avoid decode jank during the fade animation
      precacheImage(const AssetImage("assets/images/slack.png"), context);

      _navigateToNext();
    }
  }

  Future<void> _navigateToNext() async {
    // Wait minimum splash time
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      final auth = context.read<AuthController>();

      // Wait for auth to finish reading SharedPreferences to avoid early logouts
      while (auth.isLoading) {
        await Future.delayed(const Duration(milliseconds: 50));
      }
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(auth.currentUser != null ? AppRoutes.main : AppRoutes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedOpacity(
        opacity: _fontsLoaded ? 1 : 0,
        duration: const Duration(milliseconds: 400),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/slack.png", width: 80, height: 80, fit: BoxFit.contain),
              const SizedBox(width: 16),
              Text(
                "slack",
                style: GoogleFonts.inter(
                  fontSize: 82,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1D21),
                  letterSpacing: -1.5,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
