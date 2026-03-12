import 'package:flutter/material.dart';
import '../models/message_data.dart';
import 'new_message_screen.dart';
import 'message_thread_screen.dart';

// A simple model to hold reaction state per post
class _ReactionState {
  final Map<String, int> counts;
  final Set<String> myReactions;
  _ReactionState({Map<String, int>? counts, Set<String>? myReactions})
      : counts = counts ?? {},
        myReactions = myReactions ?? {};
}

const _kEmojiOptions = ['👍', '❤️', '🔥', '✅', '😊', '🙌'];

class MessageBoardTab extends StatefulWidget {
  final MessageThread thread;
  const MessageBoardTab({super.key, required this.thread});

  @override
  State<MessageBoardTab> createState() => _MessageBoardTabState();
}

class _MessageBoardTabState extends State<MessageBoardTab> {
  late List<BoardPost> _posts;
  final Map<String, _ReactionState> _reactions = {};

  @override
  void initState() {
    super.initState();
    _posts = List.from(mockBoardPosts);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openNewMessage,
        backgroundColor: const Color(0xFF4F46E5),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('New Message', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
      body: _posts.isEmpty ? _buildEmptyState() : _buildPostList(),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 64.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(color: Color(0xFFEEF2FF), shape: BoxShape.circle),
                child: const Icon(Icons.campaign_outlined, size: 52, color: Color(0xFF4F46E5)),
              ),
              const SizedBox(height: 24),
              const Text('No messages yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              const SizedBox(height: 8),
              const Text(
                'Post announcements, raise queries,\ngive feedback, or pitch your next big idea.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.5),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _openNewMessage,
                icon: const Icon(Icons.add),
                label: const Text('New Message'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _posts.length,
      itemBuilder: (context, index) => _buildPostCard(_posts[index]),
    );
  }

  Widget _buildPostCard(BoardPost post) {
    final state = _reactions.putIfAbsent(post.id, () => _ReactionState());
    final hasReactions = state.counts.isNotEmpty;

    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => MessageThreadScreen(post: post)));
      },
      onLongPress: () => _showEmojiPicker(post.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: const Border(left: BorderSide(color: Color(0xFF4F46E5), width: 4)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top accent bar
            Container(
              height: 4,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(12)),
                gradient: LinearGradient(
                  colors: [Color(0xFF818CF8), Color(0xFF4F46E5)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  const SizedBox(height: 8),
                  Text(post.bodyText, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4)),
                  // Reaction pills
                  if (hasReactions) ...[
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: state.counts.entries.map((e) {
                        final isOwn = state.myReactions.contains(e.key);
                        return GestureDetector(
                          onTap: () => _toggleReaction(post.id, e.key),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isOwn ? const Color(0xFFEEF2FF) : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isOwn ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
                                width: isOwn ? 1.5 : 1,
                              ),
                            ),
                            child: Text(
                              '${e.key} ${e.value}',
                              style: TextStyle(fontSize: 13, color: isOwn ? const Color(0xFF4F46E5) : const Color(0xFF475569)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: const Color(0xFF8B5CF6),
                        child: Text(post.authorInitials, style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text('${post.authorName} • ${post.timestamp}', style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                      ),
                      if (post.commentCount > 0)
                        InkWell(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => MessageThreadScreen(post: post))),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B5CF6),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [BoxShadow(color: const Color(0xFF8B5CF6).withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.forum_rounded, size: 12, color: Colors.white),
                                const SizedBox(width: 4),
                                Text('${post.commentCount} Replies', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEmojiPicker(String postId) {
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
            const Text('React to this post', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _kEmojiOptions.map((emoji) {
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    _toggleReaction(postId, emoji);
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

  void _toggleReaction(String postId, String emoji) {
    setState(() {
      final state = _reactions.putIfAbsent(postId, () => _ReactionState());
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

  void _openNewMessage() async {
    final newPost = await Navigator.push<BoardPost>(
      context,
      MaterialPageRoute(builder: (_) => const NewMessageScreen()),
    );
    if (newPost != null) {
      setState(() => _posts.insert(0, newPost));
    }
  }
}
