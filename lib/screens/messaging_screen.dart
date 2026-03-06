import 'package:flutter/material.dart';
import '../models/organization.dart';
import '../models/message_data.dart';
import 'project_messaging_detail_screen.dart';
import '../widgets/members_bottom_sheet.dart';

class MessagingScreen extends StatelessWidget {
  final Organization organization;
  final BusinessUnit currentUnit;

  const MessagingScreen({
    super.key,
    required this.organization,
    required this.currentUnit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Match Deals and Projects tab bg
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Row(
                children: [
                  const Text(
                    "Projects",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF), // Light blue background
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Text(
                      '${mockMessageThreads.length} Projects',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2563EB), // Blue text
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final thread = mockMessageThreads[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: _buildProjectChatCard(context, thread),
                );
              },
              childCount: mockMessageThreads.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildProjectChatCard(BuildContext context, MessageThread thread) {
    final int totalUnread = thread.boardUnreadCount + thread.chatUnreadCount + thread.dmUnreadCount;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProjectMessagingDetailScreen(thread: thread),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top: Project Name & Type Badge
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Project Type Badge
                      _buildProjectTypeBadge(thread.projectType),
                      const Spacer(),
                      if (totalUnread > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$totalUnread New',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    thread.projectName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  if (thread.lastMessagePreview != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.subdirectory_arrow_right_rounded, size: 16, color: Color(0xFF94A3B8)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    thread.lastMessageSender ?? '',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
                                  ),
                                  Text(
                                    thread.lastMessageTimestamp ?? '',
                                    style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                thread.lastMessagePreview!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            
            // Bottom: Unread Breakdown and Participants
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                   Expanded(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (thread.boardUnreadCount > 0) _buildUnreadBreakdownBadge('Board', thread.boardUnreadCount),
                        if (thread.chatUnreadCount > 0) _buildUnreadBreakdownBadge('Chat', thread.chatUnreadCount),
                        if (thread.dmUnreadCount > 0) _buildUnreadBreakdownBadge('DM', thread.dmUnreadCount),
                        if (totalUnread == 0)
                           const Text('No new activity', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      // Stacked avatars
                      GestureDetector(
                        onTap: () => showMembersBottomSheet(context, thread),
                        child: SizedBox(
                          width: 42,
                          height: 28,
                          child: Stack(
                            children: [
                              Positioned(
                                right: 0,
                                child: _buildSmallAvatar(thread.clientUser, const Color(0xFF8B5CF6)),
                              ),
                              Positioned(
                                right: 14,
                                child: _buildSmallAvatar(thread.internalUser, const Color(0xFF14B8A6)),
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

  Widget _buildProjectTypeBadge(String type) {
    Color bgColor;
    Color textColor;
    
    switch (type.toLowerCase()) {
      case 'hourly':
        bgColor = const Color(0xFFEEF2FF); // Indigo
        textColor = const Color(0xFF4F46E5);
        break;
      case 'fixed cost':
        bgColor = const Color(0xFFF5F3FF); // Purple
        textColor = const Color(0xFF7C3AED);
        break;
      case 'hirebase':
        bgColor = const Color(0xFFF0FDF4); // Green
        textColor = const Color(0xFF16A34A);
        break;
      default:
        bgColor = const Color(0xFFF1F5F9);
        textColor = const Color(0xFF475569);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        type,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }

  Widget _buildUnreadBreakdownBadge(String label, int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: Color(0xFF64748B)),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '+$count',
              style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallAvatar(ChatParticipant user, Color fallbackColor) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: CircleAvatar(
        radius: 12,
        backgroundColor: fallbackColor,
        backgroundImage: user.avatarImagePath != null ? AssetImage(user.avatarImagePath!) : null,
        child: user.avatarImagePath == null && user.initials != null
            ? Text(user.initials!, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white))
            : null,
      ),
    );
  }


  Widget _buildProfileTooltip(ChatParticipant user, {bool isRightAlign = false}) {
    return Column(
      crossAxisAlignment: isRightAlign ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // The Tooltip simulates the web hover by showing the name on tap.
        Tooltip(
          message: user.fullName,
          triggerMode: TooltipTriggerMode.tap, // Shows on tap instead of just long press
          preferBelow: false, // Force tooltip to appear *above* the avatar
          verticalOffset: 24, // Push it slightly higher so it clears the avatar
          decoration: BoxDecoration(
            color: const Color(0xFF333333),
            borderRadius: BorderRadius.circular(4),
          ),
          textStyle: const TextStyle(color: Colors.white, fontSize: 12),
          child: CircleAvatar(
             radius: 16,
             backgroundColor: const Color(0xFF8B5CF6), // Fallback purple color
             backgroundImage: user.avatarImagePath != null 
                 ? AssetImage(user.avatarImagePath!) 
                 : null,
             child: user.avatarImagePath == null && user.initials != null
                 ? Text(
                     user.initials!, 
                     style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)
                   )
                 : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          user.label, // "Yopmails" or "Client"
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}
