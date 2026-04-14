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
      Message(
        id: "m1",
        senderId: "u2",
        senderName: "Alexander Gherschon",
        content: "Hey, did you check the latest release?",
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        channelId: "c2",
      ),
      Message(
        id: "m2",
        senderId: "u3",
        senderName: "Christophe MALLFERT",
        content: "Yes, it looks solid. Can we jump on a huddle later?",
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        channelId: "c2",
      ),
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
