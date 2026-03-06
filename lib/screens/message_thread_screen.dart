import 'package:flutter/material.dart';
import '../models/message_data.dart';

class MessageThreadScreen extends StatefulWidget {
  final BoardPost post;

  const MessageThreadScreen({super.key, required this.post});

  @override
  State<MessageThreadScreen> createState() => _MessageThreadScreenState();
}

class _MessageThreadScreenState extends State<MessageThreadScreen> {
  late List<BoardComment> _comments;
  final _replyController = TextEditingController();
  bool _canReply = false;

  @override
  void initState() {
    super.initState();
    _comments = List.from(widget.post.comments);
    _replyController.addListener(_validateReply);
  }

  void _validateReply() {
    final bool hasText = _replyController.text.trim().isNotEmpty;
    if (_canReply != hasText) {
      setState(() => _canReply = hasText);
    }
  }

  @override
  void dispose() {
    _replyController.dispose();
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
        title: const Text(
          'Message Thread',
          style: TextStyle(color: Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Original Post block
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Post header
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8F7FF),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.post.title,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: const Color(0xFF8B5CF6),
                                  child: Text(
                                    widget.post.authorInitials,
                                    style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Created by ${widget.post.authorName} • ${widget.post.timestamp}',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Post body
                      Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          widget.post.bodyText,
                          style: const TextStyle(fontSize: 14, color: Color(0xFF334155), height: 1.6),
                        ),
                      ),
                    ],
                  ),
                ),

                // Comments section
                if (_comments.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        const Icon(Icons.chat_bubble_outline, size: 14, color: Color(0xFF64748B)),
                        const SizedBox(width: 8),
                        const Text(
                          'Comments',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEEF2FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_comments.length}',
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ..._comments.map((comment) => _buildCommentCard(comment)),
                ],
              ],
            ),
          ),
          // Reply input bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color(0xFF8B5CF6),
                  child: const Text('JM', style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: TextField(
                      controller: _replyController,
                      style: const TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Type something...',
                        hintStyle: TextStyle(color: Color(0xFFCBD5E1), fontSize: 13),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _canReply ? _addComment : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canReply ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
                    foregroundColor: _canReply ? Colors.white : const Color(0xFF94A3B8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    elevation: _canReply ? 1 : 0,
                  ),
                  child: const Text('Reply', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentCard(BoardComment comment) {
    final bool isMe = comment.authorName == 'James Mitchell';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 1)),
        ],
      ),
      child: Column(
        children: [
          if (isMe)
            Container(
              height: 3,
              decoration: const BoxDecoration(
                color: Color(0xFF4F46E5),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: isMe ? const Color(0xFF4F46E5) : const Color(0xFF8B5CF6),
                  child: Text(comment.authorInitials, style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(comment.authorName, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                          if (isMe) ...[
                            const SizedBox(width: 4),
                            const Text('(You)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF4F46E5))),
                          ],
                          const SizedBox(width: 8),
                          Text(comment.timestamp, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(comment.bodyText, style: const TextStyle(fontSize: 13, color: Color(0xFF334155), height: 1.5)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addComment() {
    final text = _replyController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _comments.add(BoardComment(
        id: 'cmt-${DateTime.now().millisecondsSinceEpoch}',
        authorName: 'James Mitchell',
        authorInitials: 'JM',
        bodyText: text,
        timestamp: 'Just now',
      ));
      _replyController.clear();
    });
  }
}
