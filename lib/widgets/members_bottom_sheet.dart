import 'package:flutter/material.dart';
import '../models/message_data.dart';

void showMembersBottomSheet(BuildContext context, MessageThread thread) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent, // Transparent to show rounded corners
    builder: (context) {
      return Container(
        padding: const EdgeInsets.only(top: 10, bottom: 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            // Client Section
            _buildSectionHeader(Icons.person_outline, 'Client', 1),
            _buildCompanySubheader('Apex Consulting Group'),
            _buildMemberRow(thread.clientUser, isClient: true, isMe: thread.clientUser.fullName == 'James Mitchell'),

            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 16),

            // Business Unit Section
            _buildSectionHeader(Icons.business_outlined, 'Business Unit', 1),
            _buildCompanySubheader('Yopmails'),
            _buildMemberRow(thread.internalUser, isClient: false, isMe: thread.internalUser.fullName == 'James Mitchell'),

            const SizedBox(height: 40),
          ],
        ),
      );
    },
  );
}

Widget _buildSectionHeader(IconData icon, String title, int count) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    child: Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF64748B)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
          ),
        ),
      ],
    ),
  );
}

Widget _buildCompanySubheader(String companyName) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    child: Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Text(
            companyName,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );
}

Widget _buildMemberRow(ChatParticipant user, {required bool isClient, required bool isMe}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    child: Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: isClient ? const Color(0xFF8B5CF6) : const Color(0xFF14B8A6),
          backgroundImage: user.avatarImagePath != null ? AssetImage(user.avatarImagePath!) : null,
          child: user.avatarImagePath == null && user.initials != null
              ? Text(user.initials!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))
              : null,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    user.fullName,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                  ),
                  if (isMe) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '(YOU)',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        if (!isClient && !isMe)
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Color(0xFF4F46E5), size: 20),
            onPressed: () {
              // Action to start DM
            },
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xFFEEF2FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
      ],
    ),
  );
}
