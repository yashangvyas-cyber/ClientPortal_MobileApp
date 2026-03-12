import 'package:flutter/material.dart';
import '../models/message_data.dart';

// ── Reaction helpers ──────────────────────────────────────────────────────────
const _kEmojiOptions = ['👍', '❤️', '🔥', '✅', '😊', '🙌'];

class _MsgReactionState {
  final Map<String, int> counts;
  final Set<String> myReactions;
  _MsgReactionState({Map<String, int>? counts, Set<String>? myReactions})
      : counts = counts ?? {},
        myReactions = myReactions ?? {};
}
// ─────────────────────────────────────────────────────────────────────────────

class DirectChatScreen extends StatefulWidget {
  final TeamMember member;
  const DirectChatScreen({super.key, required this.member});

  @override
  State<DirectChatScreen> createState() => _DirectChatScreenState();
}

class _DirectChatScreenState extends State<DirectChatScreen> {
  late List<DirectMessage> _messages;
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  bool _canSend = false;
  final Map<String, _MsgReactionState> _reactions = {};

  @override
  void initState() {
    super.initState();
    _messages = List<DirectMessage>.from(mockDirectMessages[widget.member.id] ?? []).reversed.toList();
    _inputController.addListener(() {
      final hasText = _inputController.text.trim().isNotEmpty;
      if (hasText != _canSend) setState(() => _canSend = hasText);
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF64748B),
              backgroundImage: widget.member.avatarImagePath != null ? AssetImage(widget.member.avatarImagePath!) : null,
              child: widget.member.avatarImagePath == null
                  ? Text(widget.member.initials ?? widget.member.fullName[0], style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold))
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.member.fullName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                Text(widget.member.company, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.normal)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Color(0xFF64748B)), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    controller: _scrollController,
                    reverse: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: _messages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _messages.length) return _buildDateDivider('Today');
                      final msg = _messages[index];
                      final bool isFirstInGroup = index == _messages.length - 1 || _messages[index + 1].isMe != msg.isMe;
                      final bool isLastInGroup = index == 0 || _messages[index - 1].isMe != msg.isMe;
                      return _buildMessageBubble(msg, isFirstInGroup, isLastInGroup);
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
                IconButton(icon: const Icon(Icons.sentiment_satisfied_alt_outlined, color: Color(0xFF94A3B8)), onPressed: () {}),
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
                IconButton(icon: const Icon(Icons.attach_file, color: Color(0xFF94A3B8)), onPressed: () {}),
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
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: const Color(0xFF64748B),
            backgroundImage: widget.member.avatarImagePath != null ? AssetImage(widget.member.avatarImagePath!) : null,
            child: widget.member.avatarImagePath == null
                ? Text(widget.member.initials ?? widget.member.fullName[0], style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold))
                : null,
          ),
          const SizedBox(height: 16),
          Text(widget.member.fullName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
          const SizedBox(height: 6),
          Text(widget.member.company, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
          const SizedBox(height: 20),
          const Text('Start a conversation!', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
        ],
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

  Widget _buildMessageBubble(DirectMessage msg, bool isFirstInGroup, bool isLastInGroup) {
    final isMe = msg.isMe;
    final state = _reactions.putIfAbsent(msg.id, () => _MsgReactionState());
    final hasReactions = state.counts.isNotEmpty;

    return Padding(
      padding: EdgeInsets.only(bottom: isLastInGroup ? 12.0 : 4.0),
      child: GestureDetector(
        onLongPress: () => _showEmojiPicker(msg.id),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isMe) ...[
              if (isLastInGroup)
                CircleAvatar(
                  radius: 14,
                  backgroundColor: const Color(0xFF64748B),
                  child: Text(widget.member.initials ?? widget.member.fullName[0], style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
                )
              else
                const SizedBox(width: 28),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
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
                  // Reaction pills
                  if (hasReactions)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Wrap(
                        spacing: 4,
                        children: state.counts.entries.map((e) {
                          final isOwn = state.myReactions.contains(e.key);
                          return GestureDetector(
                            onTap: () => _toggleReaction(msg.id, e.key),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: isOwn ? const Color(0xFFEEF2FF) : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isOwn ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
                                  width: isOwn ? 1.5 : 1,
                                ),
                              ),
                              child: Text(
                                '${e.key} ${e.value}',
                                style: TextStyle(fontSize: 12, color: isOwn ? const Color(0xFF4F46E5) : const Color(0xFF475569)),
                              ),
                            ),
                          );
                        }).toList(),
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
                const SizedBox(width: 28),
            ],
          ],
        ),
      ),
    );
  }

  void _showEmojiPicker(String msgId) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Text('React to message', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _kEmojiOptions.map((emoji) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    _toggleReaction(msgId, emoji);
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _toggleReaction(String msgId, String emoji) {
    setState(() {
      final state = _reactions.putIfAbsent(msgId, () => _MsgReactionState());
      if (state.myReactions.contains(emoji)) {
        state.myReactions.remove(emoji);
        state.counts[emoji] = (state.counts[emoji] ?? 1) - 1;
        if ((state.counts[emoji] ?? 0) <= 0) state.counts.remove(emoji);
      } else {
        state.myReactions.add(emoji);
        state.counts[emoji] = (state.counts[emoji] ?? 0) + 1;
      }
    });
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.insert(0, DirectMessage(
        id: 'dm-${DateTime.now().millisecondsSinceEpoch}',
        authorName: 'James Mitchell',
        bodyText: text,
        timestamp: 'Just now',
        isMe: true,
      ));
      _inputController.clear();
      _canSend = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }
}
