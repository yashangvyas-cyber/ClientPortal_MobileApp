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
      backgroundColor: const Color(0xFFF1F5F9),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Row(
                children: [
                  const Text(
                    'Messages',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Text(
                      '${mockMessageThreads.length} Projects',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF2563EB)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final thread = mockMessageThreads[index];
                  return _buildGridCard(context, thread);
                },
                childCount: mockMessageThreads.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridCard(BuildContext context, MessageThread thread) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProjectMessagingDetailScreen(thread: thread)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project type badge
              _buildProjectTypeBadge(thread.projectType),
              const SizedBox(height: 12),
              // Project name
              Expanded(
                child: Text(
                  thread.projectName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 12),
              // Stacked member avatars at bottom
              _buildStackedAvatars(thread),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProjectTypeBadge(String type) {
    Color bgColor;
    Color textColor;

    switch (type.toLowerCase()) {
      case 'hourly':
        bgColor = const Color(0xFFEEF2FF);
        textColor = const Color(0xFF4F46E5);
        break;
      case 'fixed cost':
        bgColor = const Color(0xFFF5F3FF);
        textColor = const Color(0xFF7C3AED);
        break;
      case 'hirebase':
        bgColor = const Color(0xFFF0FDF4);
        textColor = const Color(0xFF16A34A);
        break;
      default:
        bgColor = const Color(0xFFF1F5F9);
        textColor = const Color(0xFF475569);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        type,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textColor),
      ),
    );
  }

  Widget _buildStackedAvatars(MessageThread thread) {
    return SizedBox(
      width: 52,
      height: 26,
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
    );
  }

  Widget _buildSmallAvatar(ChatParticipant user, Color fallbackColor) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: CircleAvatar(
        radius: 11,
        backgroundColor: fallbackColor,
        backgroundImage: user.avatarImagePath != null ? AssetImage(user.avatarImagePath!) : null,
        child: user.avatarImagePath == null && user.initials != null
            ? Text(user.initials!, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white))
            : null,
      ),
    );
  }
}
