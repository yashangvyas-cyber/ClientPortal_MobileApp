import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import '../models/message_data.dart';

class NewMessageScreen extends StatefulWidget {
  const NewMessageScreen({super.key});

  @override
  State<NewMessageScreen> createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {
  final _titleController = TextEditingController();
  final _quillController = QuillController.basic();

  bool _jamesMitchellVisible = true;
  bool _superUserVisible = true;
  bool _canPost = false;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(_validateInputs);
    _quillController.addListener(_validateInputs);
  }

  void _validateInputs() {
    final bodyText = _quillController.document.toPlainText().trim();
    final bool isValid =
        _titleController.text.trim().isNotEmpty && bodyText.isNotEmpty && bodyText != '\n';
    if (_canPost != isValid) setState(() => _canPost = isValid);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quillController.dispose();
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
                  // Visible To
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
                          const Text('Visible To: ',
                              style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                          Expanded(
                            child: Wrap(spacing: 6, runSpacing: 4, children: _buildVisibleChips()),
                          ),
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
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                      decoration: const InputDecoration(
                        hintText: 'Title of the message...',
                        hintStyle: TextStyle(
                            color: Color(0xFFCBD5E1), fontWeight: FontWeight.normal),
                        contentPadding: EdgeInsets.all(16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Body: Quill toolbar + editor
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Custom toolbar
                        _buildToolbar(),
                        // Editor — scrollable:false required because parent is SingleChildScrollView
                        SizedBox(
                          height: 250,
                          child: QuillEditor.basic(
                            controller: _quillController,
                            config: const QuillEditorConfig(
                              placeholder: 'Write your message here...',
                              padding: EdgeInsets.all(16),
                              scrollable: false,
                            ),
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
                      foregroundColor: const Color(0xFF64748B),
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
                    onPressed: _canPost ? _postMessage : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _canPost ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
                      foregroundColor:
                          _canPost ? Colors.white : const Color(0xFF94A3B8),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      elevation: _canPost ? 2 : 0,
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

  Widget _buildToolbar() {
    final style = _quillController.getSelectionStyle();
    final isBold = style.containsKey(Attribute.bold.key);
    final isItalic = style.containsKey(Attribute.italic.key);
    final isUnderline = style.containsKey(Attribute.underline.key);
    final isBullet = style.attributes[Attribute.list.key]?.value == 'bullet';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      child: Row(
        children: [
          _fmtBtn(Icons.format_bold, isBold, () {
            _quillController.formatSelection(
                isBold ? Attribute.clone(Attribute.bold, null) : Attribute.bold);
          }),
          _fmtBtn(Icons.format_italic, isItalic, () {
            _quillController.formatSelection(
                isItalic ? Attribute.clone(Attribute.italic, null) : Attribute.italic);
          }),
          _fmtBtn(Icons.format_underline, isUnderline, () {
            _quillController.formatSelection(isUnderline
                ? Attribute.clone(Attribute.underline, null)
                : Attribute.underline);
          }),
          const SizedBox(width: 4),
          Container(width: 1, height: 20, color: const Color(0xFFE2E8F0)),
          const SizedBox(width: 4),
          _fmtBtn(Icons.format_list_bulleted, isBullet, () {
            _quillController.formatSelection(
                isBullet ? Attribute.clone(Attribute.ul, null) : Attribute.ul);
          }),
        ],
      ),
    );
  }

  Widget _fmtBtn(IconData icon, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: active ? const Color(0xFFEEF2FF) : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 18,
            color: active ? const Color(0xFF4F46E5) : const Color(0xFF64748B)),
      ),
    );
  }

  List<Widget> _buildVisibleChips() {
    final chips = <Widget>[];
    if (_jamesMitchellVisible) chips.add(_personChip('James Mitchell', 'JM'));
    if (_superUserVisible) chips.add(_personChip('Super User', 'SU'));
    if (chips.isEmpty) {
      chips.add(const Text('Nobody',
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF4F46E5))));
    }
    return chips;
  }

  Widget _personChip(String name, String initials) {
    return Container(
      padding: const EdgeInsets.only(right: 8, top: 2, bottom: 2, left: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFC7D2FE)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: const Color(0xFF8B5CF6),
            child: Text(initials,
                style: const TextStyle(
                    fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 6),
          Text(name,
              style: const TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF4F46E5))),
        ],
      ),
    );
  }

  void _showEditMembersDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Edit Members',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A))),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: Color(0xFF64748B)),
                    onPressed: () => Navigator.pop(ctx),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Client',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF94A3B8),
                      letterSpacing: 1.2)),
              const Divider(color: Color(0xFFF1F5F9)),
              Opacity(
                opacity: 0.6,
                child: _memberCheckboxRow(
                  initials: 'JM',
                  name: 'James Mitchell (You)',
                  value: true,
                  onChanged: null,
                ),
              ),
              const SizedBox(height: 16),
              const Text('Yopmails',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF94A3B8),
                      letterSpacing: 1.2)),
              const Divider(color: Color(0xFFF1F5F9)),
              _memberCheckboxRow(
                initials: 'SU',
                name: 'Super User',
                value: _superUserVisible,
                onChanged: (val) {
                  setSheetState(() => _superUserVisible = val ?? true);
                  setState(() {});
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Save Settings', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _memberCheckboxRow({
    required String initials,
    required String name,
    required bool value,
    required ValueChanged<bool?>? onChanged,
  }) {
    return GestureDetector(
      onTap: onChanged != null ? () => onChanged(!value) : null,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: value ? const Color(0xFF4F46E5) : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                    color: value ? const Color(0xFF4F46E5) : const Color(0xFFCBD5E1)),
              ),
              child: value ? const Icon(Icons.check, size: 14, color: Colors.white) : null,
            ),
            const SizedBox(width: 12),
            CircleAvatar(
              radius: 14,
              backgroundColor: const Color(0xFF8B5CF6),
              child: Text(initials,
                  style: const TextStyle(
                      fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(name,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF0F172A))),
            ),
          ],
        ),
      ),
    );
  }

  void _postMessage() {
    if (!_canPost) return;
    final title = _titleController.text.trim();
    final body = _quillController.document.toPlainText().trim();
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
