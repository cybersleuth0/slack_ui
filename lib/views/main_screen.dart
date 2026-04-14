import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

/// Slack-style home screen — improved to match screenshot closely
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Slack brand purple
  static const Color kPurpleDark = Color(0xFF3F0E40);
  static const Color kPurpleMid = Color(0xFF611F69);
  static const Color kGreen = Color(0xFF2BAC76);
  static const Color kTextPrimary = Color(0xFF1A1D21);
  static const Color kTextSecondary = Color(0xFF616061);
  static const Color kDivider = Color(0xFFF3F3F3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _currentIndex == 0
          ? _buildHomeTab()
          : Center(
              child: Text("Coming Soon", style: GoogleFonts.inter(color: kTextSecondary)),
            ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _currentIndex == 0 ? _buildFAB() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHomeTab() {
    return Column(
      children: [
        // Purple app bar
        _buildAppBar(),
        // White scrollable content with rounded top
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 16),
                _buildTopCards(),
                _buildSectionDivider(),
                _buildCollapsibleSection(
                  label: "Mentions",
                  showIcon: false,
                  children: [_buildChannelItem(name: "announcements", badge: 3, isBold: true)],
                ),
                _buildSectionDivider(),
                _buildCollapsibleSection(
                  label: "Channels",
                  showIcon: true,
                  sectionIcon: Icons.tag,
                  children: [
                    _buildChannelItem(name: "cloud"),
                    _buildChannelItem(name: "community-chat"),
                    _buildChannelItem(name: "maestro-questions"),
                    _buildChannelItem(name: "product-wishlist"),
                    _buildAddRow(label: "Add channel"),
                  ],
                ),
                _buildSectionDivider(),
                _buildCollapsibleSection(
                  label: "Direct messages",
                  showIcon: true,
                  sectionIcon: Icons.chat_bubble_outline,
                  children: [
                    _buildDMItem(name: "Ayush Shende (you)", isOnline: true),
                    _buildDMItem(name: "Alexander Gherschon", isOnline: false),
                    _buildDMItem(name: "Christophe MALLFERT", isOnline: false),
                  ],
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build the purple app bar
  Widget _buildAppBar() {
    return Container(
      color: kPurpleDark,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                alignment: Alignment.center,
                child: Text(
                  "M",
                  style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w800, color: kPurpleDark),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Maestro",
                style: GoogleFonts.inter(fontSize: 19, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 22),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: const Icon(Icons.history_rounded, color: Colors.white70, size: 24),
              ),
              const SizedBox(width: 6),
              Stack(
                children: [
                  CircleAvatar(
                    radius: 17,
                    backgroundColor: const Color(0xFFD4B8D4),
                    child: Text(
                      "AS",
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: kPurpleDark),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: kGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: kPurpleDark, width: 2),
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

  Widget _iconButton(IconData icon) {
    return GestureDetector(
      onTap: () {},
      child: Icon(icon, color: Colors.white70, size: 24),
    );
  }

  // ─── Top Cards ──────────────────────────────────────────────────────────────

  Widget _buildTopCards() {
    return SizedBox(
      height: 116,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        scrollDirection: Axis.horizontal,
        children: [
          _topCard(iconWidget: _catchUpIcon(), title: "Catch up", subtitle: "5 new", isSelected: true),
          _topCard(
            iconWidget: const Icon(Icons.bookmark_border_rounded, color: kTextSecondary, size: 22),
            title: "Later",
            subtitle: "0 items",
          ),
          _topCard(
            iconWidget: const Icon(Icons.send_rounded, color: kTextSecondary, size: 22),
            title: "Drafts & Sent",
            subtitle: "0 drafts",
          ),
          _topCard(
            iconWidget: const Icon(Icons.headset_mic_outlined, color: kTextSecondary, size: 22),
            title: "Huddles",
            subtitle: "0 live",
          ),
        ],
      ),
    );
  }

  /// "Catch up" card icon — two overlapping squares with a purple notification dot
  Widget _catchUpIcon() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        const Icon(Icons.workspaces_rounded, color: kPurpleMid, size: 22),
        Positioned(
          right: -4,
          top: -4,
          child: Container(
            width: 9,
            height: 9,
            decoration: const BoxDecoration(color: kPurpleMid, shape: BoxShape.circle),
          ),
        ),
      ],
    );
  }

  Widget _topCard({
    required Widget iconWidget,
    required String title,
    required String subtitle,
    bool isSelected = false,
  }) {
    return Container(
      width: 126,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF5EFF6) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isSelected ? const Color(0xFFDDD0DE) : const Color(0xFFE8E8E8), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconWidget,
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: isSelected ? kPurpleMid : kTextPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w400, color: kTextSecondary),
          ),
        ],
      ),
    );
  }

  // ─── Section Divider ────────────────────────────────────────────────────────

  Widget _buildSectionDivider() => Container(height: 8, color: const Color(0xFFF5F5F5));

  // ─── Collapsible Section Header ─────────────────────────────────────────────

  /// Reusable section header (Mentions / Channels / Direct messages)
  Widget _buildCollapsibleSection({
    required String label,
    required List<Widget> children,
    bool showIcon = false,
    IconData? sectionIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: Row(
            children: [
              if (showIcon && sectionIcon != null) ...[
                Icon(sectionIcon, size: 17, color: kTextSecondary),
                const SizedBox(width: 7),
              ],
              Text(
                label,
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: kTextPrimary),
              ),
              const SizedBox(width: 3),
              const Icon(Icons.chevron_right_rounded, size: 18, color: kTextSecondary),
              const Spacer(),
              const Icon(Icons.keyboard_arrow_up_rounded, size: 20, color: kTextSecondary),
            ],
          ),
        ),
        ...children,
      ],
    );
  }

  // ─── Channel Item ────────────────────────────────────────────────────────────

  Widget _buildChannelItem({required String name, int badge = 0, bool isBold = false}) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(Icons.tag, size: 19, color: isBold ? kTextPrimary : kTextSecondary),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                  color: kTextPrimary,
                ),
              ),
            ),
            if (badge > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(color: kPurpleMid, borderRadius: BorderRadius.circular(12)),
                child: Text(
                  "$badge",
                  style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddRow({required String label}) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            const Icon(Icons.add_rounded, size: 20, color: kTextSecondary),
            const SizedBox(width: 14),
            Text(
              label,
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w400, color: kTextSecondary),
            ),
          ],
        ),
      ),
    );
  }

  // ─── DM Item ─────────────────────────────────────────────────────────────────

  Widget _buildDMItem({required String name, bool isOnline = false}) {
    final initials = name.trim().split(" ").take(2).map((w) => w.isNotEmpty ? w[0].toUpperCase() : "").join();

    // Deterministic background color from name
    final colors = [const Color(0xFFE8A838), const Color(0xFF7C3085), const Color(0xFF2BAC76), const Color(0xFFCC4E2A)];
    final bg = colors[name.length % colors.length];

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: bg,
                  child: Text(
                    initials,
                    style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
                if (isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: kGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Text(
              name,
              style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w400, color: kTextPrimary),
            ),
          ],
        ),
      ),
    );
  }

  // ─── FAB ────────────────────────────────────────────────────────────────────

  Widget _buildFAB() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: kPurpleDark,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: kPurpleDark.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 5))],
      ),
      child: IconButton(
        icon: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
        onPressed: () {},
      ),
    );
  }

  // ─── Bottom Nav ──────────────────────────────────────────────────────────────

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (i) => setState(() => _currentIndex = i),
      type: BottomNavigationBarType.fixed,
      selectedItemColor: kPurpleDark,
      unselectedItemColor: kTextSecondary,
      selectedLabelStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w400),
      backgroundColor: Colors.white,
      elevation: 8,
      items: [
        // Home — with purple notification dot
        BottomNavigationBarItem(
          label: "Home",
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.home_rounded),
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: kPurpleMid, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ),
        // DMs — with badge count
        BottomNavigationBarItem(
          label: "DMs",
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.chat_bubble_outline_rounded),
              Positioned(
                right: -5,
                top: -5,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(color: kPurpleMid, shape: BoxShape.circle),
                  constraints: const BoxConstraints(minWidth: 15, minHeight: 15),
                  child: const Text(
                    "3",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Activity — with dot indicator
        BottomNavigationBarItem(
          label: "Activity",
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_none_rounded),
              Positioned(
                right: -3,
                top: -3,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(color: kPurpleMid, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
        ),
        const BottomNavigationBarItem(label: "Search", icon: Icon(Icons.search_rounded)),
        // More — bordered box icon
        BottomNavigationBarItem(
          label: "More",
          icon: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(color: kTextSecondary, width: 1.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Icon(Icons.more_horiz_rounded, size: 17, color: kTextSecondary),
          ),
        ),
      ],
    );
  }
}
