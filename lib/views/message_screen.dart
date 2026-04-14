import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:provider/provider.dart";
import "package:slack_ui/controllers/auth_controller.dart";
import "package:slack_ui/controllers/chat_controller.dart";
import "package:slack_ui/models/message.dart";

class MessageScreen extends StatefulWidget {
  final String chatName;
  final String chatId;
  final bool isChannel;

  const MessageScreen({super.key, required this.chatName, required this.chatId, this.isChannel = true});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = context.read<ChatController>();
      chatProvider.setActiveChat(widget.chatId);
      if (widget.isChannel) {
        chatProvider.markChannelAsRead(widget.chatId);
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  static const Color kPurpleDark = Color(0xFF3F0E40);
  static const Color kTextPrimary = Color(0xFF1A1D21);
  static const Color kTextSecondary = Color(0xFF616061);
  static const Color kDivider = Color(0xFFE8E8E8);

  @override
  Widget build(BuildContext context) {
    final currentUserId = context.select<AuthController, String>((a) => a.currentUser?.id ?? "u1");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Scrollable Dynamic Message List
          Expanded(
            child: Consumer<ChatController>(
              builder: (context, chatProvider, child) {
                final messages = widget.isChannel
                    ? chatProvider.getMessagesForChannel(widget.chatId)
                    : chatProvider.getMessagesForDM(currentUserId, widget.chatId);

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return _buildMessageItem(
                      sender: msg.senderName,
                      time: "${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}",
                      content: msg.content,
                      isMe: msg.senderId == currentUserId,
                    );
                  },
                );
              },
            ),
          ),

          // Sticky Bottom Chat Input Bar
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: kTextPrimary),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: kDivider, height: 1),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.isChannel ? Icons.tag : Icons.chat_bubble_outline, size: 18, color: kTextPrimary),
          const SizedBox(width: 8),
          Text(
            widget.chatName,
            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: kTextPrimary),
          ),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
        IconButton(icon: const Icon(Icons.info_outline_rounded), onPressed: () {}),
      ],
    );
  }

  Widget _buildMessageItem({
    required String sender,
    required String time,
    required String content,
    required bool isMe,
  }) {
    final initials = sender.trim().split(" ").take(2).map((w) => w.isNotEmpty ? w[0].toUpperCase() : "").join();

    final colors = [const Color(0xFFE8A838), const Color(0xFF7C3085), const Color(0xFF2BAC76), const Color(0xFFCC4E2A)];
    final bg = colors[sender.length % colors.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: bg,
            child: Text(
              initials,
              style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.white),
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
                      sender,
                      style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: kTextPrimary),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, color: kTextSecondary),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w400, color: kTextPrimary, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kDivider, width: 1)),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF868686)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              TextField(
                controller: _messageController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                style: GoogleFonts.inter(fontSize: 16, color: kTextPrimary),
                decoration: InputDecoration(
                  hintText: "Message ${widget.isChannel ? '#' : ''}${widget.chatName}",
                  hintStyle: GoogleFonts.inter(color: kTextSecondary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(7), bottomRight: Radius.circular(7)),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                      color: kTextSecondary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.sentiment_satisfied_rounded, size: 20),
                      color: kTextSecondary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.alternate_email_rounded, size: 20),
                      color: kTextSecondary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {},
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(color: kPurpleDark, borderRadius: BorderRadius.circular(4)),
                      child: IconButton(
                        icon: const Icon(Icons.send_rounded, size: 16),
                        color: Colors.white,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                        onPressed: () {
                          if (_messageController.text.trim().isNotEmpty) {
                            final text = _messageController.text.trim();
                            final currentUser = context.read<AuthController>().currentUser;
                            if (currentUser != null) {
                              final newMsg = Message(
                                id: DateTime.now().millisecondsSinceEpoch.toString(),
                                senderId: currentUser.id,
                                senderName: currentUser.name,
                                content: text,
                                timestamp: DateTime.now(),
                                channelId: widget.isChannel ? widget.chatId : null,
                                receiverId: !widget.isChannel ? widget.chatId : null,
                              );
                              context.read<ChatController>().sendMessage(newMsg);
                              _messageController.clear();
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
