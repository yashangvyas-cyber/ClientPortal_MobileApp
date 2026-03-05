import 'package:flutter/material.dart';
import '../models/organization.dart';
import 'deal_details_screen.dart';

class DealsScreen extends StatefulWidget {
  final Organization organization;
  final BusinessUnit currentUnit;

  const DealsScreen({
    super.key,
    required this.organization,
    required this.currentUnit,
  });

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  String _searchQuery = '';

  // Mock deal data with stage info
  static final List<Map<String, String>> _allDeals = [
    {
      'id': '1',
      'title': 'IT Support & Development – Apex Consulting Group',
      'owner': 'Super User',
      'ownerEmail': 'superuser.staging@yopmail.com',
      'project': 'IT Support & Development – Apex Consulting Group',
      'closingDate': '15-Apr-2026',
      'stage': 'Negotiation',
    },
    {
      'id': '2',
      'title': 'IT Staff Augmentation – Apex Consulting Group',
      'owner': 'Super User',
      'ownerEmail': 'superuser.staging@yopmail.com',
      'project': 'IT Staff Augmentation – Apex Consulting Group',
      'closingDate': '31-Mar-2026',
      'stage': 'Proposal',
    },
    {
      'id': '3',
      'title': 'IT Infrastructure Setup – Apex Consulting Group',
      'owner': 'Super User',
      'ownerEmail': 'superuser.staging@yopmail.com',
      'project': 'IT Infrastructure Setup – Apex Consulting Group',
      'closingDate': '30-May-2026',
      'stage': 'Qualified',
    },
  ];

  List<Map<String, String>> get _filteredDeals {
    if (_searchQuery.isEmpty) return _allDeals;
    final q = _searchQuery.toLowerCase();
    return _allDeals.where((d) =>
        d['title']!.toLowerCase().contains(q) ||
        d['owner']!.toLowerCase().contains(q)).toList();
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  /// Returns [color, bg, label] for a stage chip
  static Map<String, Color> _stageStyle(String stage) {
    switch (stage) {
      case 'Negotiation':
        return {'color': const Color(0xFF7C3AED), 'bg': const Color(0xFFF3E8FF)};
      case 'Proposal':
        return {'color': const Color(0xFF0284C7), 'bg': const Color(0xFFE0F2FE)};
      case 'Qualified':
        return {'color': const Color(0xFF059669), 'bg': const Color(0xFFD1FAE5)};
      default:
        return {'color': const Color(0xFF64748B), 'bg': const Color(0xFFF1F5F9)};
    }
  }

  /// Parse "dd-MMM-yyyy" and return urgency info
  static Map<String, dynamic> _dateUrgency(String dateStr) {
    const months = {
      'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4, 'May': 5, 'Jun': 6,
      'Jul': 7, 'Aug': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12
    };
    try {
      final parts = dateStr.split('-');
      final day = int.parse(parts[0]);
      final month = months[parts[1]] ?? 1;
      final year = int.parse(parts[2]);
      final date = DateTime(year, month, day);
      final now = DateTime.now();
      final diff = date.difference(now).inDays;

      if (diff < 0) return {'color': const Color(0xFFEF4444), 'bg': const Color(0xFFFEF2F2), 'icon': Icons.warning_amber_rounded, 'label': 'Overdue'};
      if (diff <= 14) return {'color': const Color(0xFFF59E0B), 'bg': const Color(0xFFFFFBEB), 'icon': Icons.schedule_rounded, 'label': 'Due soon'};
      return {'color': const Color(0xFF10B981), 'bg': const Color(0xFFD1FAE5), 'icon': Icons.check_circle_outline_rounded, 'label': 'On track'};
    } catch (_) {
      return {'color': const Color(0xFF64748B), 'bg': const Color(0xFFF1F5F9), 'icon': Icons.calendar_today_outlined, 'label': ''};
    }
  }

  String _ownerInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  // ── Summary stats ─────────────────────────────────────────────────────────

  Widget _buildSummaryRow() {
    final closingSoon = _allDeals.where((d) {
      final u = _dateUrgency(d['closingDate']!);
      return u['label'] == 'Due soon' || u['label'] == 'Overdue';
    }).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          _StatChip(
            value: '${_allDeals.length}',
            label: 'Total',
            color: const Color(0xFF4F46E5),
            bg: const Color(0xFFEEF2FF),
          ),
          const SizedBox(width: 8),
          if (closingSoon > 0)
            _StatChip(
              value: '$closingSoon',
              label: 'Closing soon',
              color: const Color(0xFFF59E0B),
              bg: const Color(0xFFFFFBEB),
            ),
          if (closingSoon == 0)
            _StatChip(
              value: 'All on track',
              label: '',
              color: const Color(0xFF10B981),
              bg: const Color(0xFFD1FAE5),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deals = _filteredDeals;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Title row ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                const Text('Deals',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF0F172A))),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFC7D2FE)),
                  ),
                  child: Text(
                    '${deals.length} ${deals.length == 1 ? 'Deal' : 'Deals'}',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF4F46E5), fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),

          // ── Mini stats row ──
          // summary row removed as per request


          // ── Search bar ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search by deal title or owner...',
                hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF94A3B8), size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, size: 18, color: Color(0xFF94A3B8)),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFF4F46E5), width: 1.5),
                ),
              ),
            ),
          ),

          // ── Deal list ──
          Expanded(
            child: deals.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    itemCount: deals.length,
                    itemBuilder: (context, i) => _buildDealCard(context, deals[i], i + 1),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDealCard(BuildContext context, Map<String, String> deal, int index) {
    final stage = deal['stage'] ?? 'Active';
    final stageStyle = _stageStyle(stage);
    final urgency = _dateUrgency(deal['closingDate']!);
    final initials = _ownerInitials(deal['owner']!);

    // Left border accent color per stage
    final accentColor = stageStyle['color']!;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DealDetailsScreen(
              organization: widget.organization,
              currentUnit: widget.currentUnit,
              dealId: deal['id']!,
              dealTitle: deal['title']!,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(6),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Colored left accent bar
                Container(width: 4, color: accentColor),

                // Card content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Header row: index + title + stage chip ──
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Index badge
                            Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                color: accentColor.withAlpha(20),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Center(
                                child: Text(
                                  '$index',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: accentColor,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                deal['title']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF0F172A),
                                  height: 1.3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Stage chip removed as per request
                          ],
                        ),

                        const SizedBox(height: 12),
                        const Divider(height: 1, color: Color(0xFFF1F5F9)),
                        const SizedBox(height: 12),

                        // ── Owner row ──
                        Row(
                          children: [
                            // Owner avatar
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Center(
                                child: Text(initials,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Deal Owner',
                                      style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
                                  Text(deal['owner']!,
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // ── Closing date with urgency badge ──
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: urgency['bg'] as Color,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(urgency['icon'] as IconData,
                                      size: 12, color: urgency['color'] as Color),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Closing Date: ${deal['closingDate']!}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: urgency['color'] as Color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFFCBD5E1)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64, height: 64,
            decoration: const BoxDecoration(color: Color(0xFFEEF2FF), shape: BoxShape.circle),
            child: const Icon(Icons.search_off_rounded, size: 32, color: Color(0xFF4F46E5)),
          ),
          const SizedBox(height: 16),
          const Text('No deals found', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A))),
          const SizedBox(height: 6),
          const Text('Try a different search term', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }
}

// ── Reusable stat chip widget ─────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final Color bg;

  const _StatChip({required this.value, required this.label, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700),
          children: [
            TextSpan(text: value),
            if (label.isNotEmpty)
              TextSpan(
                text: ' $label',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
          ],
        ),
      ),
    );
  }
}
