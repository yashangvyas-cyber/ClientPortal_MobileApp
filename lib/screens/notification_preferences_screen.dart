import 'package:flutter/material.dart';

class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() =>
      _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState
    extends State<NotificationPreferencesScreen> {
  bool _isSaving = false;

  // Toggle states: [email, push] per notification type
  final List<List<bool>> _toggles = [
    [true, true],   // New message thread received
    [true, false],  // New comment on existing thread
    [false, true],  // Group chat message received
    [false, true],  // Individual message ping received
    [true, true],   // Someone reacted to your comment/message
  ];

  static const List<String> _labels = [
    'New message thread received',
    'New comment received on an existing message thread',
    'Group chat message received',
    'Individual message ping received',
    'Someone reacted to your comment or message in chat',
  ];

  String _emailFrequency = 'Every 15 minutes';
  static const List<String> _frequencyOptions = [
    'Every 15 minutes',
    'Every 30 minutes',
    'Every hour',
    'Every day',
  ];

  bool get _anyEmailOn => _toggles.any((t) => t[0]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notification Preferences',
          style: TextStyle(
            color: Color(0xFF0F172A),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: TextButton(
              onPressed: _isSaving ? null : _handleSave,
              child: _isSaving
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Save',
                      style: TextStyle(
                        color: Color(0xFF4F46E5),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFF1F5F9)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Toggle matrix card ──
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Column headers
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Activity',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF64748B),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      child: Text(
                        'Email',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF64748B),
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    SizedBox(
                      width: 80,
                      child: Text(
                        'Push\nNotification',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF64748B),
                          letterSpacing: 0.3,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                // Toggle rows
                ...List.generate(_labels.length, (i) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _labels[i],
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF0F172A),
                                  height: 1.35,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 60,
                              child: Center(
                                child: Transform.scale(
                                  scale: 0.75,
                                  child: Switch(
                                    value: _toggles[i][0],
                                    onChanged: (v) =>
                                        setState(() => _toggles[i][0] = v),
                                    activeTrackColor: const Color(0xFF4F46E5),
                                    activeColor: Colors.white,
                                    inactiveTrackColor: const Color(0xFFE2E8F0),
                                    inactiveThumbColor: Colors.white,
                                    trackOutlineColor:
                                        WidgetStateProperty.all(Colors.transparent),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            SizedBox(
                              width: 80,
                              child: Center(
                                child: Transform.scale(
                                  scale: 0.75,
                                  child: Switch(
                                    value: _toggles[i][1],
                                    onChanged: (v) =>
                                        setState(() => _toggles[i][1] = v),
                                    activeTrackColor: const Color(0xFF4F46E5),
                                    activeColor: Colors.white,
                                    inactiveTrackColor: const Color(0xFFE2E8F0),
                                    inactiveThumbColor: Colors.white,
                                    trackOutlineColor:
                                        WidgetStateProperty.all(Colors.transparent),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (i < _labels.length - 1)
                        const Divider(
                            height: 1, color: Color(0xFFF1F5F9)),
                    ],
                  );
                }),
              ],
            ),
          ),

          // ── Email Frequency (conditional) ──
          if (_anyEmailOn) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Email Frequency',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'How often should we batch email notifications?',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.schedule_rounded,
                            size: 16, color: Color(0xFF64748B)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _emailFrequency,
                              isExpanded: true,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF0F172A),
                              ),
                              items: _frequencyOptions
                                  .map((opt) => DropdownMenuItem(
                                      value: opt, child: Text(opt)))
                                  .toList(),
                              onChanged: (v) =>
                                  setState(() => _emailFrequency = v!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ── Footer note ──
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'You won\'t be notified if you are actively participating in a chat or a message thread.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Color(0xFF94A3B8),
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _handleSave() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isSaving = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF10B981),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text('Notification preferences saved!',
                style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
    Navigator.pop(context);
  }
}
