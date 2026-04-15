import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:slack_ui/controllers/auth_controller.dart";
import "package:slack_ui/core/app_routes.dart";

class SharedProfileAvatar extends StatelessWidget {
  const SharedProfileAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    const Color kPurpleDark = Color(0xFF3F0E40);
    const Color kGreen = Color(0xFF2BAC76);

    return PopupMenuButton<String>(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onSelected: (value) async {
        if (value == "logout") {
          await context.read<AuthController>().logout();
          if (context.mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.login,
              (route) => false,
            );
          }
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: "logout",
          child: Row(
            children: [
              Icon(Icons.logout, color: Colors.black54, size: 20),
              SizedBox(width: 12),
              Text("Sign Out"),
            ],
          ),
        ),
      ],
      child: Stack(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: const Color(0xFFD4B8D4),
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: AssetImage("assets/images/user_icon.jpeg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            right: -2,
            bottom: -2,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: kGreen,
                shape: BoxShape.circle,
                border: Border.all(color: kPurpleDark, width: 2.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
