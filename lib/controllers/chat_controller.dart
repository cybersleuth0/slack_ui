import "package:flutter/material.dart";
import "../models/channel.dart";
import "../models/message.dart";
import "../models/user.dart";

class ChatController extends ChangeNotifier {
  List<Channel> _channels = [];
  List<User> _dmUsers = [];
  List<Message> _messages = [];
  String? _activeChatId;

  List<Channel> get channels => _channels;
  List<User> get dmUsers => _dmUsers;
  List<Message> get messages => _messages;
  String? get activeChatId => _activeChatId;

  void setActiveChat(String? chatId) {
    _activeChatId = chatId;
    notifyListeners();
  }

  ChatController() {
    _loadSimulatedData();
  }

  void _loadSimulatedData() {
    _channels = [
      Channel(id: "c1", name: "cloud", unreadCount: 0),
      Channel(id: "c2", name: "community-chat", unreadCount: 2),
      Channel(id: "c3", name: "maestro-questions", unreadCount: 0),
      Channel(id: "c4", name: "product-wishlist", unreadCount: 1),
    ];

    _dmUsers = [
      User(id: "u2", name: "Alexander Gherschon", email: "alex@example.com", isOnline: false),
      User(id: "u3", name: "Christophe MALLFERT", email: "chris@example.com", isOnline: true),
    ];

    _messages = [
      // ── #cloud ────────────────────────────────────────────
      Message(id: "m01", senderId: "u2", senderName: "Alexander Gherschon",
          content: "Morning team! The cloud infra migration is scheduled for tonight at 11 PM.",
          timestamp: DateTime.now().subtract(const Duration(hours: 5)), channelId: "c1"),
      Message(id: "m02", senderId: "u3", senderName: "Christophe MALLFERT",
          content: "Got it. I'll make sure the staging environment is backed up before we start.",
          timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 50)), channelId: "c1"),
      Message(id: "m03", senderId: "u1", senderName: "Ayush Shende",
          content: "Should I keep the monitoring dashboard open during the migration?",
          timestamp: DateTime.now().subtract(const Duration(hours: 4, minutes: 30)), channelId: "c1"),
      Message(id: "m04", senderId: "u2", senderName: "Alexander Gherschon",
          content: "Yes please! Watch the latency metrics closely. Alert if p99 crosses 500ms.",
          timestamp: DateTime.now().subtract(const Duration(hours: 4)), channelId: "c1"),

      // ── #community-chat ───────────────────────────────────
      Message(id: "m05", senderId: "u2", senderName: "Alexander Gherschon",
          content: "Hey everyone! Did you check the latest Flutter 3.22 release notes?",
          timestamp: DateTime.now().subtract(const Duration(hours: 3)), channelId: "c2"),
      Message(id: "m06", senderId: "u3", senderName: "Christophe MALLFERT",
          content: "Yes! The Impeller engine improvements are huge. Our app feels way smoother now.",
          timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 45)), channelId: "c2"),
      Message(id: "m07", senderId: "u1", senderName: "Ayush Shende",
          content: "Can we jump on a huddle later to discuss upgrading the project?",
          timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 30)), channelId: "c2"),
      Message(id: "m08", senderId: "u2", senderName: "Alexander Gherschon",
          content: "Sure! Let's do it at 4 PM. I'll send a calendar invite.",
          timestamp: DateTime.now().subtract(const Duration(hours: 2)), channelId: "c2"),

      // ── #maestro-questions ────────────────────────────────
      Message(id: "m09", senderId: "u3", senderName: "Christophe MALLFERT",
          content: "Anyone know how to handle deep link navigation in Maestro tests?",
          timestamp: DateTime.now().subtract(const Duration(hours: 6)), channelId: "c3"),
      Message(id: "m10", senderId: "u2", senderName: "Alexander Gherschon",
          content: "Use `openLink` command with your app scheme. Works perfectly for deep links.",
          timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 50)), channelId: "c3"),
      Message(id: "m11", senderId: "u3", senderName: "Christophe MALLFERT",
          content: "Thanks! What about waiting for an element to appear after the link opens?",
          timestamp: DateTime.now().subtract(const Duration(hours: 5, minutes: 30)), channelId: "c3"),
      Message(id: "m12", senderId: "u2", senderName: "Alexander Gherschon",
          content: "Just use `- assertVisible` after the `openLink`. Maestro waits automatically.",
          timestamp: DateTime.now().subtract(const Duration(hours: 5)), channelId: "c3"),

      // ── #product-wishlist ──────────────────────────────────
      Message(id: "m13", senderId: "u1", senderName: "Ayush Shende",
          content: "Wishlist item: Dark mode support across all screens.",
          timestamp: DateTime.now().subtract(const Duration(hours: 8)), channelId: "c4"),
      Message(id: "m14", senderId: "u3", senderName: "Christophe MALLFERT",
          content: "+1 on that! Also would love swipe-to-reply on messages.",
          timestamp: DateTime.now().subtract(const Duration(hours: 7, minutes: 45)), channelId: "c4"),
      Message(id: "m15", senderId: "u2", senderName: "Alexander Gherschon",
          content: "Adding these to the next sprint planning doc. Any other items?",
          timestamp: DateTime.now().subtract(const Duration(hours: 7, minutes: 30)), channelId: "c4"),
      Message(id: "m16", senderId: "u1", senderName: "Ayush Shende",
          content: "Notification grouping by channel would be great too!",
          timestamp: DateTime.now().subtract(const Duration(hours: 7)), channelId: "c4"),

      // ── DM: Ayush ↔ Alexander ─────────────────────────────
      Message(id: "m17", senderId: "u1", senderName: "Ayush Shende",
          content: "Hey Alex, the PR is ready for review. Can you take a look when free?",
          receiverId: "u2",
          timestamp: DateTime.now().subtract(const Duration(hours: 2)), channelId: null),
      Message(id: "m18", senderId: "u2", senderName: "Alexander Gherschon",
          content: "On it! I'll review it before EOD. Left a few inline comments already.",
          receiverId: "u1",
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)), channelId: null),
      Message(id: "m19", senderId: "u1", senderName: "Ayush Shende",
          content: "Thanks! I've addressed the state management feedback. PTAL again.",
          receiverId: "u2",
          timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)), channelId: null),
      Message(id: "m20", senderId: "u2", senderName: "Alexander Gherschon",
          content: "LGTM 🚀 Merging now. Great work on the named routes refactor!",
          receiverId: "u1",
          timestamp: DateTime.now().subtract(const Duration(hours: 1)), channelId: null),

      // ── DM: Ayush ↔ Christophe ────────────────────────────
      Message(id: "m21", senderId: "u3", senderName: "Christophe MALLFERT",
          content: "Ayush, are you joining the design review at 3 PM?",
          receiverId: "u1",
          timestamp: DateTime.now().subtract(const Duration(minutes: 45)), channelId: null),
      Message(id: "m22", senderId: "u1", senderName: "Ayush Shende",
          content: "Yes, I'll be there! Should I bring the latest Figma links?",
          receiverId: "u3",
          timestamp: DateTime.now().subtract(const Duration(minutes: 40)), channelId: null),
      Message(id: "m23", senderId: "u3", senderName: "Christophe MALLFERT",
          content: "Please do! Also share the screen recording of the new onboarding flow.",
          receiverId: "u1",
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)), channelId: null),
      Message(id: "m24", senderId: "u1", senderName: "Ayush Shende",
          content: "Done! Uploaded to the shared drive. See you at 3! 👍",
          receiverId: "u3",
          timestamp: DateTime.now().subtract(const Duration(minutes: 20)), channelId: null),
    ];
    notifyListeners();
  }

  List<Message> getMessagesForChannel(String channelId) {
    final list = _messages.where((m) => m.channelId == channelId).toList();
    list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return list;
  }

  List<Message> getMessagesForDM(String currentUserId, String otherUserId) {
    final list = _messages
        .where(
          (m) =>
              (m.senderId == currentUserId && m.receiverId == otherUserId) ||
              (m.senderId == otherUserId && m.receiverId == currentUserId),
        )
        .toList();
    list.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return list;
  }

  void sendMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }

  void markChannelAsRead(String channelId) {
    final index = _channels.indexWhere((c) => c.id == channelId);
    if (index != -1 && _channels[index].unreadCount > 0) {
      _channels[index] = Channel(id: _channels[index].id, name: _channels[index].name, unreadCount: 0);
      notifyListeners();
    }
  }

  List<Message> searchMessages(String query) {
    if (query.isEmpty) return [];
    return _messages.where((m) => m.content.toLowerCase().contains(query.toLowerCase())).toList();
  }
}
