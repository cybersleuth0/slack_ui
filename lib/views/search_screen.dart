import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:provider/provider.dart";
import "package:slack_ui/controllers/chat_controller.dart";
import "package:slack_ui/models/message.dart";

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Message> _results = [];

  static const Color kPurpleDark = Color(0xFF3F0E40);
  static const Color kTextPrimary = Color(0xFF1A1D21);
  static const Color kTextSecondary = Color(0xFF616061);
  static const Color kDivider = Color(0xFFE8E8E8);

  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: kTextPrimary),
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: GoogleFonts.inter(fontSize: 16, color: kTextPrimary),
          decoration: InputDecoration(
            hintText: "Search messages, channels, or people",
            hintStyle: GoogleFonts.inter(color: kTextSecondary),
            border: InputBorder.none,
          ),
          onChanged: (val) {
            setState(() {
              _isSearching = val.trim().isNotEmpty;
              if (_isSearching) {
                _results = context.read<ChatController>().searchMessages(val.trim());
              } else {
                _results = [];
              }
            });
          },
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: kDivider, height: 1),
        ),
      ),
      body: _isSearching
          // Scrollable Dynamic List of matched messages
          ? ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _results.length,
              separatorBuilder: (context, index) => const Divider(color: kDivider, height: 24),
              itemBuilder: (context, index) {
                final result = _results[index];
                return _buildSearchResult(result, context);
              },
            )
          // Empty state when search is empty
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_rounded, size: 64, color: kDivider),
                  const SizedBox(height: 16),
                  Text(
                    "Search for anything",
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: kTextPrimary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Find messages, files, and more.",
                    style: GoogleFonts.inter(fontSize: 14, color: kTextSecondary),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildSearchResult(Message msg, BuildContext context) {
    final initials = msg.senderName
        .trim()
        .split(" ")
        .take(2)
        .map((w) => w.toString().isNotEmpty ? w.toString()[0].toUpperCase() : "")
        .join();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xFFE8A838),

          child: Text(
            initials,
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    msg.senderName,
                    style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: kTextPrimary),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}",
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: kTextSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const Icon(Icons.tag, size: 12, color: kTextSecondary),
                  const SizedBox(width: 4),
                  Text(
                    msg.channelId != null ? "Channel Message" : "Direct Message",
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: kTextSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              RichText(text: _highlightText(msg.content, _searchController.text)),
            ],
          ),
        ),
      ],
    );
  }

  TextSpan _highlightText(String text, String query) {
    if (query.isEmpty || !text.toLowerCase().contains(query.toLowerCase())) {
      return TextSpan(
        text: text,
        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: kTextPrimary, height: 1.4),
      );
    }

    final List<TextSpan> spans = [];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    int start = 0;
    int indexOfMatch;

    while ((indexOfMatch = lowerText.indexOf(lowerQuery, start)) != -1) {
      if (indexOfMatch > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, indexOfMatch),
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: kTextPrimary, height: 1.4),
          ),
        );
      }

      spans.add(
        TextSpan(
          text: text.substring(indexOfMatch, indexOfMatch + query.length),
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: kPurpleDark,
            backgroundColor: const Color(0xFFF5EFF6),
            height: 1.4,
          ),
        ),
      );

      start = indexOfMatch + query.length;
    }

    if (start < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(start),
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: kTextPrimary, height: 1.4),
        ),
      );
    }

    return TextSpan(children: spans);
  }
}
