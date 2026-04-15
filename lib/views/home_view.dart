import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:provider/provider.dart";
import "package:slack_ui/controllers/auth_controller.dart";
import "package:slack_ui/controllers/chat_controller.dart";
import "package:slack_ui/views/widgets/collapsible_section.dart";
import "package:slack_ui/views/widgets/shared_profile_avatar.dart";
import "package:slack_ui/views/widgets/slack_main_layout.dart";
import "../core/app_routes.dart";

import "../models/user.dart";

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const Color kPurpleDark = Color(0xFF3F0E40);
  static const Color kPurpleMid = Color(0xFF611F69);
  static const Color kGreen = Color(0xFF2BAC76);
  static const Color kTextPrimary = Color(0xFF1A1D21);
  static const Color kTextSecondary = Color(0xFF616061);
  static const Color kDivider = Color(0xFFF3F3F3);

  @override
  Widget build(BuildContext context) {
    final currentUser = context.select<AuthController, User?>((a) => a.currentUser);

    return SlackMainLayout(
      // Top Navigation Bar
      appBarTitle: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: Text(
              currentUser?.name.isNotEmpty == true ? currentUser!.name[0].toUpperCase() : "M",
              style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w800, color: kTextPrimary),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            "SpaceX",
            style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 24),
        ],
      ),

      // Right-side Activity/Profile Menu Navigation
      trailing: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(color: const Color(0xFF6B2B6F), borderRadius: BorderRadius.circular(10)),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.history_rounded, color: Colors.white, size: 20),
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(width: 12),
          const SharedProfileAvatar(),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // Slack "Jump In" / Top Activity Cards
          _buildTopCards(),
          _buildSectionDivider(),

          // Channels List Group (Watched via Consumer)
          Consumer<ChatController>(
            builder: (context, chatController, _) => CollapsibleSection(
              label: "Channels",
              showIcon: true,
              sectionIcon: Icons.tag,
              children: [
                ...chatController.channels.map(
                  (chan) => _buildChannelItem(
                    context,
                    name: chan.name,
                    id: chan.id,
                    badge: chan.unreadCount,
                    isBold: chan.unreadCount > 0,
                  ),
                ),
                _buildAddRow(label: "Add channel"),
              ],
            ),
          ),
          _buildSectionDivider(),

          // Direct Messages List Group (Watched via Consumer)
          Consumer<ChatController>(
            builder: (context, chatController, _) => CollapsibleSection(
              label: "Direct messages",
              showIcon: true,
              sectionIcon: Icons.chat_bubble_outline,
              children: [
                _buildDMItem(
                  context,
                  name: "${currentUser?.name ?? 'You'} (you)",
                  id: currentUser?.id ?? "u1",
                  isOnline: true,
                ),
                ...chatController.dmUsers.map(
                  (u) => _buildDMItem(context, name: u.name, id: u.id, isOnline: u.isOnline),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildTopCards() {
    return SizedBox(
      height: 116,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        scrollDirection: Axis.horizontal,
        children: [
          _topCard(iconWidget: const Icon(Icons.workspaces_rounded, color: kPurpleMid, size: 22), title: "Catch up", subtitle: "5 new", isSelected: true),
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

  Widget _buildSectionDivider() => Container(height: 1, color: const Color(0xFFEBEBEB));

  Widget _buildChannelItem(
    BuildContext context, {
    required String name,
    required String id,
    int badge = 0,
    bool isBold = false,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.messages,
          arguments: {"chatName": name, "chatId": id, "isChannel": true},
        );
      },
      child: Container(
        color: Colors.transparent,
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

  Widget _buildDMItem(BuildContext context, {required String name, required String id, bool isOnline = false}) {
    final initials = name.trim().split(" ").take(2).map((w) => w.isNotEmpty ? w[0].toUpperCase() : "").join();

    final colors = [const Color(0xFFE8A838), const Color(0xFF7C3085), const Color(0xFF2BAC76), const Color(0xFFCC4E2A)];
    final bg = colors[name.length % colors.length];

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.messages,
          arguments: {"chatName": name, "chatId": id, "isChannel": false},
        );
      },
      child: Container(
        color: Colors.transparent,
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
}
