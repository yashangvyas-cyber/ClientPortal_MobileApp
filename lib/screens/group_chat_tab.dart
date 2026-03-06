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
  bool _canSend = false;

  @override
  void initState() {
    super.initState();
    _messages = List<GroupMessage>.from(mockGroupMessages).reversed.toList();
    
    _inputController.addListener(() {
      final hasText = _inputController.text.trim().isNotEmpty;
      if (hasText != _canSend) {
        setState(() => _canSend = hasText);
      }
    });
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
                // Project type badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('IT', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5))),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('IT Support & Development', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)), overflow: TextOverflow.ellipsis),
                      Text('Apex Consulting Group', style: TextStyle(fontSize: 12, color: Color(0xFF64748B)), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Stacked avatars + member count
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${_messages.length + 1} Members', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 56, // For 3 stacked avatars
                      height: 24,
                      child: Stack(
                        children: [
                          Positioned(
                            right: 0,
                            child: CircleAvatar(radius: 12, backgroundColor: Colors.amber, child: Text('JD', style: TextStyle(fontSize: 8, color: Colors.white))),
                          ),
                          Positioned(
                            right: 14,
                            child: CircleAvatar(radius: 12, backgroundColor: Colors.teal, child: Text('SU', style: TextStyle(fontSize: 8, color: Colors.white))),
                          ),
                          Positioned(
                            right: 28,
                            child: CircleAvatar(radius: 12, backgroundColor: const Color(0xFF8B5CF6), child: const Text('JM', style: TextStyle(fontSize: 8, color: Colors.white))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Messages
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : Align(
                    alignment: Alignment.bottomCenter,
                    child: ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      shrinkWrap: true, // Forces items to bottom if they don't fill screen
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      itemCount: _messages.length + 1, // +1 for date divider
                      itemBuilder: (context, index) {
                        if (index == _messages.length) return _buildDateDivider('Today');
                        
                        final msg = _messages[index];
                        
                        // In reversed view, next index is "older", previous index is "newer"
                        final bool isFirstInGroup = index == _messages.length - 1 || 
                                                    _messages[index + 1].authorInitials != msg.authorInitials;
                                                    
                        final bool isLastInGroup = index == 0 || 
                                                   _messages[index - 1].authorInitials != msg.authorInitials;

                        return _buildMessageBubble(msg, isFirstInGroup, isLastInGroup);
                      },
                    ),
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
                  onTap: _canSend ? _sendMessage : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _canSend ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.send_rounded, color: _canSend ? Colors.white : const Color(0xFF94A3B8), size: 18),
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
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
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

  Widget _buildMessageBubble(GroupMessage msg, bool isFirstInGroup, bool isLastInGroup) {
    final isMe = msg.isMe;
    return Padding(
      padding: EdgeInsets.only(bottom: isLastInGroup ? 12.0 : 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe) ...[
            if (isLastInGroup)
              CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xFF64748B),
                child: Text(msg.authorInitials, style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
              )
            else
               const SizedBox(width: 28), // placeholder 
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMe && isFirstInGroup)
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
                      bottomLeft: Radius.circular(isMe || isLastInGroup ? 16 : 4),
                      bottomRight: Radius.circular(!isMe || isLastInGroup ? 16 : 4),
                    ),
                    border: isMe ? null : Border.all(color: const Color(0xFFE2E8F0)),
                    boxShadow: isMe 
                        ? [BoxShadow(color: const Color(0xFF4F46E5).withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))] 
                        : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Text(
                    msg.bodyText,
                    style: TextStyle(fontSize: 14, color: isMe ? Colors.white : const Color(0xFF1E293B), height: 1.4),
                  ),
                ),
                if (isLastInGroup)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                    child: Text(msg.timestamp, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                  ),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 8),
            if (isLastInGroup)
              const CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFF8B5CF6),
                child: Text('JM', style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
              )
            else
              const SizedBox(width: 28), // Placeholder
          ],
        ],
      ),
    );
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.insert(0, GroupMessage(
        id: 'gm-${DateTime.now().millisecondsSinceEpoch}',
        authorName: 'James Mitchell',
        authorInitials: 'JM',
        bodyText: text,
        timestamp: 'Just now',
        isMe: true,
      ));
      _inputController.clear();
      _canSend = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          0.0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
