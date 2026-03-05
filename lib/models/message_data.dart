// ===========================================================
// PARTICIPANT MODELS
// ===========================================================

class ChatParticipant {
  final String fullName;
  final String label;
  final String? initials;
  final String? avatarImagePath;

  ChatParticipant({
    required this.fullName,
    required this.label,
    this.initials,
    this.avatarImagePath,
  });
}

// ===========================================================
// MESSAGING LISTING MODEL
// ===========================================================

class MessageThread {
  final String id;
  final String projectName;
  final ChatParticipant internalUser;
  final ChatParticipant clientUser;

  MessageThread({
    required this.id,
    required this.projectName,
    required this.internalUser,
    required this.clientUser,
  });
}

// ===========================================================
// MESSAGE BOARD MODELS
// ===========================================================

class BoardComment {
  final String id;
  final String authorName;
  final String authorInitials;
  final String bodyText;
  final String timestamp;

  BoardComment({
    required this.id,
    required this.authorName,
    required this.authorInitials,
    required this.bodyText,
    required this.timestamp,
  });
}

class BoardPost {
  final String id;
  final String authorName;
  final String authorInitials;
  final String title;
  final String bodyText;
  final String timestamp;
  final List<BoardComment> comments;

  BoardPost({
    required this.id,
    required this.authorName,
    required this.authorInitials,
    required this.title,
    required this.bodyText,
    required this.timestamp,
    required this.comments,
  });

  int get commentCount => comments.length;
}

// ===========================================================
// GROUP CHAT MODELS
// ===========================================================

class GroupMessage {
  final String id;
  final String authorName;
  final String authorInitials;
  final String bodyText;
  final String timestamp;
  final bool isMe; // true if the message is from the logged-in user (James Mitchell)

  GroupMessage({
    required this.id,
    required this.authorName,
    required this.authorInitials,
    required this.bodyText,
    required this.timestamp,
    required this.isMe,
  });
}

// ===========================================================
// TEAM MEMBERS MODELS
// ===========================================================

class TeamMember {
  final String id;
  final String fullName;
  final String company;
  final String? initials;
  final String? avatarImagePath;

  TeamMember({
    required this.id,
    required this.fullName,
    required this.company,
    this.initials,
    this.avatarImagePath,
  });
}

// ===========================================================
// DIRECT CHAT MODELS
// ===========================================================

class DirectMessage {
  final String id;
  final String authorName;
  final String bodyText;
  final String timestamp;
  final bool isMe;

  DirectMessage({
    required this.id,
    required this.authorName,
    required this.bodyText,
    required this.timestamp,
    required this.isMe,
  });
}

// ===========================================================
// MOCK DATA
// ===========================================================

// --- Listing ---
final List<MessageThread> mockMessageThreads = [
  MessageThread(
    id: 'msg-1',
    projectName: 'IT Support & Development – Apex Consulting Group',
    internalUser: ChatParticipant(fullName: 'Super User', label: 'Yopmails'),
    clientUser: ChatParticipant(fullName: 'James Mitchell', label: 'Client', initials: 'JM'),
  ),
  MessageThread(
    id: 'msg-2',
    projectName: 'IT Staff Augmentation – Apex Consulting Group',
    internalUser: ChatParticipant(fullName: 'Super User', label: 'Yopmails'),
    clientUser: ChatParticipant(fullName: 'James Mitchell', label: 'Client', initials: 'JM'),
  ),
  MessageThread(
    id: 'msg-3',
    projectName: 'IT Infrastructure Setup – Apex Consulting Group',
    internalUser: ChatParticipant(fullName: 'Super User', label: 'Yopmails'),
    clientUser: ChatParticipant(fullName: 'James Mitchell', label: 'Client', initials: 'JM'),
  ),
];

// --- Message Board Posts ---
final List<BoardPost> mockBoardPosts = [
  BoardPost(
    id: 'post-1',
    authorName: 'James Mitchell',
    authorInitials: 'JM',
    title: 'This to understand what is a message board is for',
    bodyText:
        'Hi, I am Yashang vyas creating a message so that I can understand the purpose of the message board.',
    timestamp: 'Today, 01:25 AM',
    comments: [
      BoardComment(
        id: 'cmt-1',
        authorName: 'James Mitchell',
        authorInitials: 'JM',
        bodyText: 'Hi this a starting conversation for this message.',
        timestamp: 'Today, 01:25 AM',
      ),
      BoardComment(
        id: 'cmt-2',
        authorName: 'Super User',
        authorInitials: 'SU',
        bodyText: 'Okay, Understood',
        timestamp: 'Today, 01:26 AM',
      ),
    ],
  ),
];

// --- Group Chat Messages ---
final List<GroupMessage> mockGroupMessages = [
  GroupMessage(
    id: 'gm-1',
    authorName: 'Super User',
    authorInitials: 'SU',
    bodyText: 'Hi this is a group chat section we are talking about',
    timestamp: 'Today, 01:25 AM',
    isMe: false,
  ),
  GroupMessage(
    id: 'gm-2',
    authorName: 'James Mitchell',
    authorInitials: 'JM',
    bodyText: 'Great, I can see it working now!',
    timestamp: 'Today, 01:27 AM',
    isMe: true,
  ),
];

// --- Team Members ---
final List<TeamMember> mockTeamMembers = [
  TeamMember(
    id: 'tm-1',
    fullName: 'Super User',
    company: 'Yopmails',
    initials: 'SU',
  ),
];

// --- Direct Messages ---
final Map<String, List<DirectMessage>> mockDirectMessages = {
  'tm-1': [
    DirectMessage(
      id: 'dm-1',
      authorName: 'Super User',
      bodyText: 'wqdwqdwq',
      timestamp: '01:27 PM',
      isMe: false,
    ),
    DirectMessage(
      id: 'dm-2',
      authorName: 'Super User',
      bodyText: 'test',
      timestamp: '01:27 PM',
      isMe: false,
    ),
    DirectMessage(
      id: 'dm-3',
      authorName: 'James Mitchell',
      bodyText: 'Got it, thanks!',
      timestamp: '01:30 PM',
      isMe: true,
    ),
  ],
};
