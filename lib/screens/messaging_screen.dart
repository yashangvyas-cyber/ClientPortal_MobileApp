import 'package:flutter/material.dart';
import '../models/organization.dart';
import '../models/message_data.dart';
import 'project_messaging_detail_screen.dart';

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
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top: Project Name
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              thread.projectName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          
          // Bottom: Participants Layout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildProfileTooltip(thread.internalUser),
                _buildProfileTooltip(thread.clientUser, isRightAlign: true),
              ],
            ),
          ),
        ],    // closes Column children
      ),      // closes Column
    ),        // closes Container (GestureDetector child)
    );        // closes GestureDetector
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
