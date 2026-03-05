import 'package:flutter/material.dart';
import '../models/message_data.dart';

class NewMessageScreen extends StatefulWidget {
  const NewMessageScreen({super.key});

  @override
  State<NewMessageScreen> createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  // Visibility/Members state
  bool _jamesMitchellVisible = true;
  bool _superUserVisible = true;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
        ),
        leadingWidth: 80,
        title: const Text(
          'Create New Message',
          style: TextStyle(color: Color(0xFF0F172A), fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          // Edit Members
          IconButton(
            tooltip: 'Edit visible members',
            icon: const Icon(Icons.edit_outlined, color: Color(0xFF4F46E5)),
            onPressed: _showEditMembersDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Visible To indicator
                  GestureDetector(
                    onTap: _showEditMembersDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEF2FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFC7D2FE)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.visibility_outlined, size: 16, color: Color(0xFF4F46E5)),
                          const SizedBox(width: 8),
                          const Text('Visible To: ', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                          Text(
                            _visibleToText(),
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF4F46E5)),
                          ),
                          const Spacer(),
                          const Icon(Icons.edit, size: 14, color: Color(0xFF4F46E5)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: TextField(
                      controller: _titleController,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                      decoration: const InputDecoration(
                        hintText: 'Title of the message...',
                        hintStyle: TextStyle(color: Color(0xFFCBD5E1), fontWeight: FontWeight.normal),
                        contentPadding: EdgeInsets.all(16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Body field
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      children: [
                        // Minimal formatting toolbar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                          ),
                          child: Row(
                            children: [
                              _toolbarButton(Icons.format_bold, 'Bold'),
                              _toolbarButton(Icons.format_italic, 'Italic'),
                              _toolbarButton(Icons.format_underline, 'Underline'),
                              const VerticalDivider(width: 20),
                              _toolbarButton(Icons.format_list_bulleted, 'List'),
                              _toolbarButton(Icons.link, 'Link'),
                            ],
                          ),
                        ),
                        TextField(
                          controller: _bodyController,
                          maxLines: 12,
                          style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A), height: 1.5),
                          decoration: const InputDecoration(
                            hintText: 'Write your message here...',
                            hintStyle: TextStyle(color: Color(0xFFCBD5E1)),
                            contentPadding: EdgeInsets.all(16),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Bottom action bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF64748B),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Save as Draft'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _postMessage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4F46E5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send, size: 16),
                        SizedBox(width: 8),
                        Text('Post Message', style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _toolbarButton(IconData icon, String tooltip) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: IconButton(
        icon: Icon(icon, size: 18, color: const Color(0xFF64748B)),
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        onPressed: () {},
      ),
    );
  }

  String _visibleToText() {
    final visible = <String>[];
    if (_jamesMitchellVisible) visible.add('James Mitchell');
    if (_superUserVisible) visible.add('Super User');
    if (visible.isEmpty) return 'Nobody';
    return visible.join(', ');
  }

  void _showEditMembersDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Row(
            children: [
              const Text('Edit Members', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(width: 8),
              const Icon(Icons.info_outline, size: 16, color: Color(0xFF94A3B8)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => Navigator.pop(ctx),
                padding: EdgeInsets.zero,
              ),
            ],
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Client', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
              const SizedBox(height: 8),
              _memberCheckboxRow(
                initials: 'JM',
                name: 'James Mitchell (You)',
                value: _jamesMitchellVisible,
                onChanged: (val) {
                  setDialogState(() => _jamesMitchellVisible = val ?? true);
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              const Text('Yopmails', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF64748B), letterSpacing: 0.5)),
              const SizedBox(height: 8),
              _memberCheckboxRow(
                initials: 'SU',
                name: 'Super User',
                value: _superUserVisible,
                onChanged: (val) {
                  setDialogState(() => _superUserVisible = val ?? true);
                  setState(() {});
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4F46E5), foregroundColor: Colors.white),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _memberCheckboxRow({
    required String initials,
    required String name,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: const Color(0xFF8B5CF6),
          child: Text(initials, style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(name, style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)))),
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF4F46E5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ],
    );
  }

  void _postMessage() {
    final title = _titleController.text.trim();
    final body = _bodyController.text.trim();
    if (title.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in the title and message body.')),
      );
      return;
    }
    final newPost = BoardPost(
      id: 'post-${DateTime.now().millisecondsSinceEpoch}',
      authorName: 'James Mitchell',
      authorInitials: 'JM',
      title: title,
      bodyText: body,
      timestamp: 'Just now',
      comments: [],
    );
    Navigator.pop(context, newPost);
  }
}
