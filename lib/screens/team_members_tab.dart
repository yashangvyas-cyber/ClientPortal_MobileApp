import 'package:flutter/material.dart';
import '../models/message_data.dart';
import 'direct_chat_screen.dart';

class TeamMembersTab extends StatelessWidget {
  final MessageThread thread;

  const TeamMembersTab({super.key, required this.thread});

  @override
  Widget build(BuildContext context) {
    // Group members by company
    final Map<String, List<TeamMember>> grouped = {};
    for (final member in mockTeamMembers) {
      grouped.putIfAbsent(member.company, () => []).add(member);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                const Icon(Icons.people_outline, size: 18, color: Color(0xFF4F46E5)),
                const SizedBox(width: 8),
                const Text('Team Members', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFC7D2FE)),
                  ),
                  child: Text(
                    '${mockTeamMembers.length}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF4F46E5)),
                  ),
                ),
              ],
            ),
          ),

          // Company sections
          ...grouped.entries.map((entry) => _buildCompanySection(context, entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildCompanySection(BuildContext context, String company, List<TeamMember> members) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Company header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Text(
              company.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF64748B),
                letterSpacing: 1.2,
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          ...members.map((member) => _buildMemberRow(context, member)),
        ],
      ),
    );
  }

  Widget _buildMemberRow(BuildContext context, TeamMember member) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          // Tapping row opens direct chat
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DirectChatScreen(member: member)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF64748B),
                backgroundImage: member.avatarImagePath != null ? AssetImage(member.avatarImagePath!) : null,
                child: member.avatarImagePath == null
                    ? Text(member.initials ?? member.fullName[0],
                        style: const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold))
                    : null,
              ),
              const SizedBox(width: 14),
              // Name
              Expanded(
                child: Text(
                  member.fullName,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                ),
              ),
              // Chat button
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => DirectChatScreen(member: member)),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFC7D2FE)),
                  ),
                  child: const Icon(Icons.chat_bubble_rounded, size: 20, color: Color(0xFF4F46E5)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
