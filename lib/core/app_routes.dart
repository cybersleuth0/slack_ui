import "package:flutter/material.dart";
import "../views/splash_screen.dart";
import "../views/login_screen.dart";
import "../views/signup_screen.dart";
import "../views/main_screen.dart";
import "../views/search_screen.dart";
import "../views/message_screen.dart";

class AppRoutes {
  static const String splash = "/";
  static const String login = "/login";
  static const String signup = "/signup";
  static const String main = "/main";
  static const String search = "/search";
  static const String messages = "/messages";

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case main:
        return PageRouteBuilder(
          pageBuilder: (_, animation, _) => FadeTransition(opacity: animation, child: const MainScreen()),
          transitionDuration: const Duration(milliseconds: 400),
        );
      case search:
        return MaterialPageRoute(builder: (_) => const SearchScreen());
      case messages:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MessageScreen(
            chatName: args["chatName"] as String,
            chatId: args["chatId"] as String,
            isChannel: args["isChannel"] as bool,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(body: Center(child: Text("No route defined for ${settings.name}"))),
        );
    }
  }
}
