import 'package:flutter/material.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String _selectedTimezone = 'Asia/Kabul (GMT+4:30)';
  String _selectedDateFormat = 'DD-MMM-YYYY';
  String _selectedTimeFormat = '12 hour (01:00 PM)';
  bool _twoFactorEnabled = false;
  bool _isSaving = false;

  final List<String> _timezones = [
    'Asia/Kabul (GMT+4:30)',
    'America/New_York (GMT-5:00)',
    'America/Los_Angeles (GMT-8:00)',
    'Europe/London (GMT+0:00)',
    'Europe/Paris (GMT+1:00)',
    'Asia/Kolkata (GMT+5:30)',
    'Asia/Dubai (GMT+4:00)',
    'Asia/Singapore (GMT+8:00)',
    'Australia/Sydney (GMT+11:00)',
  ];

  final List<String> _dateFormats = [
    'DD-MMM-YYYY',
    'MM/DD/YYYY',
    'DD/MM/YYYY',
    'YYYY-MM-DD',
  ];

  final List<String> _timeFormats = ['12 hour (01:00 PM)', '24 hour (13:00)'];

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
          'Preferences',
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
          // Timezone
          _buildSection(
            title: 'Time Zone',
            subtitle:
                'Select your timezone to ensure all communications reflect your local time.',
            child: _buildDropdown(
              icon: Icons.public_outlined,
              value: _selectedTimezone,
              items: _timezones,
              onChanged: (v) => setState(() => _selectedTimezone = v!),
            ),
          ),
          const SizedBox(height: 16),

          // Date & Time
          _buildSection(
            title: 'Date & Time Preferences',
            subtitle:
                'Select how you want to see dates and times across the portal.',
            child: Column(
              children: [
                _buildDropdown(
                  icon: Icons.calendar_today_outlined,
                  label: 'Date Format',
                  value: _selectedDateFormat,
                  items: _dateFormats,
                  onChanged: (v) => setState(() => _selectedDateFormat = v!),
                ),
                const SizedBox(height: 12),
                _buildDropdown(
                  icon: Icons.access_time_outlined,
                  label: 'Time Format',
                  value: _selectedTimeFormat,
                  items: _timeFormats,
                  onChanged: (v) => setState(() => _selectedTimeFormat = v!),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2FA
          _buildSection(
            title: '2 Factor Authentication',
            subtitle:
                'Add an extra layer of security. After login, you can choose to receive OTP on your email.',
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _twoFactorEnabled
                        ? const Color(0xFFEEF2FF)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Icon(
                    Icons.shield_outlined,
                    size: 20,
                    color: _twoFactorEnabled
                        ? const Color(0xFF4F46E5)
                        : const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enable 2 Factor Authentication',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Receive OTP on your email each sign‑in',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _twoFactorEnabled,
                  onChanged: (v) => setState(() => _twoFactorEnabled = v),
                  activeThumbColor: const Color(0xFF4F46E5),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF94A3B8),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required IconData icon,
    String? label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 6),
        ],
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF64748B)),
              const SizedBox(width: 8),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    isExpanded: true,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF0F172A),
                    ),
                    items: items
                        .map(
                          (item) =>
                              DropdownMenuItem(value: item, child: Text(item)),
                        )
                        .toList(),
                    onChanged: onChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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
            Text('Preferences saved!', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
    Navigator.pop(context);
  }
}
