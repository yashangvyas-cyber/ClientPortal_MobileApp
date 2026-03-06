import 'package:flutter/material.dart';
import '../models/message_data.dart';
import 'new_message_screen.dart';
import 'message_thread_screen.dart';

class MessageBoardTab extends StatefulWidget {
  final MessageThread thread;

  const MessageBoardTab({super.key, required this.thread});

  @override
  State<MessageBoardTab> createState() => _MessageBoardTabState();
}

class _MessageBoardTabState extends State<MessageBoardTab> {
  late List<BoardPost> _posts;

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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.campaign_outlined, size: 52, color: Color(0xFF4F46E5)),
            ),
            const SizedBox(height: 24),
            const Text(
              'No messages yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
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
    );
  }

  Widget _buildPostList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        return _buildPostCard(post);
      },
    );
  }

  Widget _buildPostCard(BoardPost post) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => MessageThreadScreen(post: post)),
        );
      },
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
            // Top Accent Bar
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
                  // Title
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Body preview (Truncated)
                  Text(
                    post.bodyText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
                  const SizedBox(height: 10),
                  // Author + timestamp + comment count badge
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: const Color(0xFF8B5CF6),
                        child: Text(
                          post.authorInitials,
                          style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${post.authorName} • ${post.timestamp}',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                        ),
                      ),
                      if (post.commentCount > 0)
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => MessageThreadScreen(post: post)),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B5CF6),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF8B5CF6).withOpacity(0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.forum_rounded, size: 12, color: Colors.white),
                                const SizedBox(width: 4),
                                Text(
                                  '${post.commentCount} Replies',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white),
                                ),
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
