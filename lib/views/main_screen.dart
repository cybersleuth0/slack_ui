import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:slack_ui/views/home_view.dart";
import "package:slack_ui/views/dms_view.dart";
import "../core/app_routes.dart";

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  static const Color kPurpleDark = Color(0xFF3F0E40);
  static const Color kTextSecondary = Color(0xFF616061);

  final List<Widget> _pages = const [HomeView(), DMsView(), SizedBox()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _pages[_currentIndex], bottomNavigationBar: _buildBottomNav());
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFEBEBEB), width: 1)),
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (Set<WidgetState> states) => states.contains(WidgetState.selected)
                ? GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: kPurpleDark)
                : GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: kTextSecondary),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (i) {
            if (i == 2) {
              Navigator.pushNamed(context, AppRoutes.search);
            } else {
              setState(() => _currentIndex = i);
            }
          },
          backgroundColor: Colors.white,
          indicatorColor: const Color(0xFFEFE8F0),

          elevation: 10,
          shadowColor: Colors.black26,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_filled, color: kPurpleDark),
              label: "Home",
            ),
            NavigationDestination(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.forum_outlined),
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: kPurpleDark, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                      child: const Text(
                        "3",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
              label: "DMs",
            ),
            const NavigationDestination(icon: Icon(Icons.search_rounded), label: "Search"),
          ],
        ),
      ),
    );
  }
}
