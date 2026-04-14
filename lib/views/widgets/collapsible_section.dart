import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class CollapsibleSection extends StatefulWidget {
  final String label;
  final List<Widget> children;
  final bool showIcon;
  final IconData? sectionIcon;

  const CollapsibleSection({
    super.key,
    required this.label,
    required this.children,
    this.showIcon = false,
    this.sectionIcon,
  });

  @override
  State<CollapsibleSection> createState() => _CollapsibleSectionState();
}

class _CollapsibleSectionState extends State<CollapsibleSection> {
  bool _isExpanded = true;

  static const Color kTextPrimary = Color(0xFF1A1D21);
  static const Color kTextSecondary = Color(0xFF616061);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            highlightColor: const Color(0xFFEAEAEA),

            splashColor: const Color(0xFFEAEAEA),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),

              child: Row(
                children: [
                  if (widget.showIcon && widget.sectionIcon != null) ...[
                    Icon(widget.sectionIcon, size: 17, color: kTextSecondary),
                    const SizedBox(width: 7),
                  ],
                  Text(
                    widget.label,
                    style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: kTextPrimary),
                  ),
                  const SizedBox(width: 3),
                  const Icon(Icons.chevron_right_rounded, size: 18, color: kTextSecondary),
                  const Spacer(),
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: kTextSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_isExpanded) ...widget.children,
      ],
    );
  }
}
