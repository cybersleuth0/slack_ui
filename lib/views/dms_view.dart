import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:slack_ui/views/widgets/shared_profile_avatar.dart";
import "package:slack_ui/views/widgets/slack_main_layout.dart";

class DMsView extends StatelessWidget {
  const DMsView({super.key});

  @override
  Widget build(BuildContext context) {
    return SlackMainLayout(
      appBarTitle: Text(
        "Direct messages",
        style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
      ),
      trailing: const SharedProfileAvatar(),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _buildRecentDMsRow(),
          const SizedBox(height: 16),
          _buildFilterChips(),
          const SizedBox(height: 80),
          _buildEmptyState(),
        ],
      ),
    );
  }

  Widget _buildRecentDMsRow() {
    return SizedBox(
      height: 100,

      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildAvatarItem("Aadil\nShaikh", color: const Color(0xFF902196), isOnline: true),
          _buildAvatarItem("Aashish", color: const Color(0xFF14649C), isOnline: true),
          _buildAvatarItem("_sonatard", imageUrl: "https://i.pravatar.cc/100?img=12", isOnline: false),
          _buildAvatarItem("001 test", color: const Color(0xFF208A7C), isOnline: false),
          _buildAvatarItem("3V", imageUrl: "https://i.pravatar.cc/150?img=14", isOnline: false),
        ],
      ),
    );
  }

  Widget _buildAvatarItem(String name, {Color? color, String? imageUrl, bool isOnline = false}) {
    return Container(
      width: 72,
      margin: const EdgeInsets.only(right: 8),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color ?? const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(16),
                  image: imageUrl != null ? DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover) : null,
                ),
                alignment: Alignment.center,
                child: imageUrl == null
                    ? (name == "001 test"
                          ? Text(
                              "t",
                              style: GoogleFonts.inter(fontSize: 28, color: Colors.white, fontWeight: FontWeight.w500),
                            )
                          : Icon(Icons.person_rounded, size: 40, color: Colors.white.withOpacity(0.8)))
                    : null,
              ),
              Positioned(
                right: -2,
                bottom: -2,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: isOnline ? const Color(0xFF2BAC76) : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: !isOnline
                      ? Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF616061), width: 1.5),
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: const Color(0xFF1A1D21)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildChip("All", isFilled: true),
          const SizedBox(width: 8),
          _buildChip("Unreads", icon: Icons.mark_chat_unread_outlined),
          const SizedBox(width: 8),
          _buildChip("External connections", icon: Icons.business_rounded),
        ],
      ),
    );
  }

  Widget _buildChip(String label, {bool isFilled = false, IconData? icon}) {
    const Color kPurpleMid = Color(0xFF611F69);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isFilled ? kPurpleMid : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isFilled ? kPurpleMid : const Color(0xFFDCDCDC), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 16, color: kPurpleMid), const SizedBox(width: 6)],
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isFilled ? Colors.white : kPurpleMid,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(color: const Color(0xFFF3E5F5), borderRadius: BorderRadius.circular(20)),
            alignment: Alignment.center,
            child: const Icon(Icons.chat_bubble_rounded, size: 48, color: Color(0xFFAB47BC)),
          ),
          const SizedBox(height: 24),
          Text(
            "Slack is better when everyone's here",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFF1A1D21)),
          ),
          const SizedBox(height: 12),
          Text(
            "Browse everyone in Maestro and strike up a conversation.",
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF616061)),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007A5A),

              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text("Browse all people", style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
