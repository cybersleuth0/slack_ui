import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "login_screen.dart";

/// Simple splash screen matching Slack's branding
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final Future<void> _fontsPending;

  @override
  void initState() {
    super.initState();
    // Preload fonts to prevent font swapping
    _fontsPending = _preloadFonts();
    _navigateToLogin();
  }

  /// Preload Google Fonts to prevent font swapping
  Future<void> _preloadFonts() async {
    await GoogleFonts.pendingFonts([
      GoogleFonts.inter(fontWeight: FontWeight.w400),
      GoogleFonts.inter(fontWeight: FontWeight.w500),
      GoogleFonts.inter(fontWeight: FontWeight.w600),
      GoogleFonts.inter(fontWeight: FontWeight.w700),
      GoogleFonts.inter(fontWeight: FontWeight.w800),
      GoogleFonts.inter(fontWeight: FontWeight.w900),
    ]);

    // Preload other weights in the background
    _preloadOtherFonts();
  }

  /// Preload additional fonts for other screens
  Future<void> _preloadOtherFonts() async {
    await GoogleFonts.pendingFonts([
      GoogleFonts.inter(fontWeight: FontWeight.w300),
      GoogleFonts.inter(fontWeight: FontWeight.w400, fontStyle: FontStyle.italic),
    ]);
  }

  /// Navigate to login screen after fonts are loaded
  Future<void> _navigateToLogin() async {
    await _fontsPending;
    if (mounted) {
      // Brief delay to show splash
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return FadeTransition(opacity: animation, child: const LoginScreen());
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: _fontsPending,
        builder: (context, snapshot) {
          final isLoading = snapshot.connectionState != ConnectionState.done;

          return AnimatedOpacity(
            opacity: isLoading ? 0 : 1,
            duration: const Duration(milliseconds: 400),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Slack icon logo
                  Image.asset("assets/images/slack.png", width: 80, height: 80, fit: BoxFit.contain),
                  const SizedBox(width: 16),
                  // Slack text
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
          );
        },
      ),
    );
  }
}
