import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class SlackMainLayout extends StatelessWidget {
  final Widget appBarTitle;
  final Widget trailing;
  final Widget body;

  const SlackMainLayout({super.key, required this.appBarTitle, required this.trailing, required this.body});

  static const Color kPurpleDark = Color(0xFF3F0E40);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPurpleDark,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverAppBar(
            backgroundColor: kPurpleDark,
            stretch: true,
            pinned: true,
            toolbarHeight: 0,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(64),
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(height: 64, child: Row(children: [appBarTitle, const Spacer(), trailing])),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: LayoutBuilder(
                builder: (context, constraints) {
                  final statusBarHeight = MediaQuery.of(context).padding.top;
                  final collapsedHeight = statusBarHeight + 64;
                  final stretchOffset = constraints.maxHeight - collapsedHeight;
                  final opacity = (stretchOffset / 40.0).clamp(0.0, 1.0);

                  return Container(
                    color: kPurpleDark,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: statusBarHeight, bottom: 64),
                    child: Opacity(
                      opacity: opacity,
                      child: Text(
                        "Don't forget to breathe",
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: Material(
                color: Colors.white,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                clipBehavior: Clip.antiAlias,
                child: body,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
