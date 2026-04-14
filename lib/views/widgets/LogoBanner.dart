import "package:flutter/cupertino.dart";

Widget buildLogoBanner() {
  return Container(
    height: 160,
    decoration: BoxDecoration(color: const Color(0xFF4A154B), borderRadius: BorderRadius.circular(12)),
    child: Center(child: Image.asset("assets/images/slack.png", width: 100, height: 100, fit: BoxFit.contain)),
  );
}
