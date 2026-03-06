import 'package:flutter/material.dart';
import '../models/message_data.dart';
import 'message_board_tab.dart';
import 'group_chat_tab.dart';
import 'team_members_tab.dart';
import '../widgets/members_bottom_sheet.dart';

class ProjectMessagingDetailScreen extends StatefulWidget {
  final MessageThread thread;

  const ProjectMessagingDetailScreen({super.key, required this.thread});

  @override
  State<ProjectMessagingDetailScreen> createState() =>
      _ProjectMessagingDetailScreenState();
}

class _ProjectMessagingDetailScreenState
    extends State<ProjectMessagingDetailScreen> {
  int _selectedTab = 0;

  static const _tabs = [
    (icon: Icons.dashboard_outlined, label: 'Board'),
    (icon: Icons.chat_bubble_outline, label: 'Group Chat'),
    (icon: Icons.people_outline, label: 'Team'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEF2FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.thread.projectType,
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.thread.projectName,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Stacked avatars in header
            GestureDetector(
              onTap: () => showMembersBottomSheet(context, widget.thread),
              child: SizedBox(
                width: 42,
                height: 28,
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      child: _buildSmallAvatar(widget.thread.clientUser, const Color(0xFF8B5CF6)),
                    ),
                    Positioned(
                      right: 14,
                      child: _buildSmallAvatar(widget.thread.internalUser, const Color(0xFF14B8A6)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // ── Telegram-style pill tab bar ──
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_tabs.length, (index) {
                  final tab = _tabs[index];
                  final isActive = _selectedTab == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF4F46E5)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              tab.icon,
                              size: 14,
                              color: isActive
                                  ? Colors.white
                                  : const Color(0xFF64748B),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              tab.label,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: isActive
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: isActive
                                    ? Colors.white
                                    : const Color(0xFF64748B),
                              ),
                            ),
                            if (_getUnreadCountForTab(index) > 0) ...[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF4444), // Red badge
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '${_getUnreadCountForTab(index)}',
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          MessageBoardTab(thread: widget.thread),
          GroupChatTab(thread: widget.thread),
          TeamMembersTab(thread: widget.thread),
        ],
      ),
    );
  }

  int _getUnreadCountForTab(int index) {
    switch (index) {
      case 0:
        return widget.thread.boardUnreadCount;
      case 1:
        return widget.thread.chatUnreadCount;
      case 2:
        return widget.thread.dmUnreadCount; // Or team unread, but we only have 3 badged tabs
      default:
        return 0;
    }
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
}
