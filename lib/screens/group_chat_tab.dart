import 'package:flutter/material.dart';
import '../models/message_data.dart';

class GroupChatTab extends StatefulWidget {
  final MessageThread thread;

  const GroupChatTab({super.key, required this.thread});

  @override
  State<GroupChatTab> createState() => _GroupChatTabState();
}

class _GroupChatTabState extends State<GroupChatTab> {
  late List<GroupMessage> _messages;
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _messages = List.from(mockGroupMessages);
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          // Channel header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.white,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: const Icon(Icons.lock_open_outlined, size: 16, color: Color(0xFFF59E0B)),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Group Chat', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    Text('Project General Channel', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                  ],
                ),
                const Spacer(),
                Text('${_messages.length + 1} Members', style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: _messages.length + 1, // +1 for date divider
                    itemBuilder: (context, index) {
                      if (index == 0) return _buildDateDivider('Today');
                      final msg = _messages[index - 1];
                      return _buildMessageBubble(msg);
                    },
                  ),
          ),

          // Input bar
          Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.sentiment_satisfied_alt_outlined, color: Color(0xFF94A3B8)),
                  onPressed: () {},
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: TextField(
                      controller: _inputController,
                      style: const TextStyle(fontSize: 13),
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(color: Color(0xFFCBD5E1), fontSize: 13),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        suffixIcon: Icon(Icons.auto_awesome, size: 18, color: Color(0xFF94A3B8)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.attach_file, color: Color(0xFF94A3B8)),
                  onPressed: () {},
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4F46E5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFFFFFBEB),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chat_bubble_outline, size: 40, color: Color(0xFFF59E0B)),
            ),
            const SizedBox(height: 20),
            const Text('No conversations yet.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 8),
            const Text(
              'Kickstart the project collaboration.\nShare updates, ask questions, or just say hello to the team.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.5),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _inputController.text = '',
              icon: const Icon(Icons.bolt, size: 16),
              label: const Text('Start Discussion'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateDivider(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(GroupMessage msg) {
    final isMe = msg.isMe;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF64748B),
              child: Text(msg.authorInitials, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, left: 4),
                    child: Text(msg.authorName, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isMe ? const Color(0xFF4F46E5) : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isMe ? 16 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 16),
                    ),
                    boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Text(
                    msg.bodyText,
                    style: TextStyle(fontSize: 13, color: isMe ? Colors.white : const Color(0xFF334155), height: 1.4),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                  child: Text(msg.timestamp, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                ),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF8B5CF6),
              child: const Text('JM', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(GroupMessage(
        id: 'gm-${DateTime.now().millisecondsSinceEpoch}',
        authorName: 'James Mitchell',
        authorInitials: 'JM',
        bodyText: text,
        timestamp: 'Just now',
        isMe: true,
      ));
      _inputController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
