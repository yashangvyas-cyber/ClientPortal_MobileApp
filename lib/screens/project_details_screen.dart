import 'package:flutter/material.dart';
import '../models/project_data.dart';

class ProjectDetailsScreen extends StatefulWidget {
  final ProjectData project;

  const ProjectDetailsScreen({super.key, required this.project});

  @override
  State<ProjectDetailsScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;

  // Resource State
  bool _isShowingCurrentResources = true;
  String _resourceSearchQuery = '';
  int? _expandedResourceIndex;
  int _visibleResourcesCount = 10;
  final TextEditingController _resourceSearchController = TextEditingController();

  // Timesheet State
  String _activeTimeFilter = 'Last 7 Days';
  String _dateRangeText = '27 Feb 2026 - 05 Mar 2026';

  void _updateTimeFilter(String filter) {
    setState(() {
      _activeTimeFilter = filter;
      if (filter == 'Last 7 Days') {
        _dateRangeText = '27 Feb 2026 - 05 Mar 2026';
      } else if (filter == 'This Month') {
        _dateRangeText = '01 Mar 2026 - 31 Mar 2026';
      }
    });
  }

  Future<void> _selectCustomDate() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0F172A),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _activeTimeFilter = 'Custom Date';
        _dateRangeText = '${_formatDate(picked.start)} - ${_formatDate(picked.end)}';
      });
    }
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}';
  }

  @override
  void initState() {
    super.initState();
    // Only Hourly Projects have Tabs (Details / Timesheet). Others just have Details.
    final bool hasTabs = widget.project.projectType == 'Hourly Projects';
    _tabController = TabController(length: hasTabs ? 2 : 1, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index != _currentTabIndex) {
        setState(() {
          _currentTabIndex = _tabController.index;
        });
      }
    });

    _resourceSearchController.addListener(() {
      if (_resourceSearchController.text != _resourceSearchQuery) {
        setState(() {
          _resourceSearchQuery = _resourceSearchController.text;
          _visibleResourcesCount = 10; // Reset pagination on search
          _expandedResourceIndex = null; // Close any open row
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _resourceSearchController.dispose();
    super.dispose();
  }

  // ── Type & status colours ──────────────────────────────────────────────────

  Map<String, Color> get _typeStyle {
    switch (widget.project.projectType) {
      case 'Hourly Projects':
        return {'color': const Color(0xFF6366F1), 'bg': const Color(0xFFEEF2FF), 'accent': const Color(0xFF818CF8)};
      case 'Hirebase Projects':
        return {'color': const Color(0xFFD97706), 'bg': const Color(0xFFFEF3C7), 'accent': const Color(0xFFFBBF24)};
      case 'Fixed Cost':
        return {'color': const Color(0xFF059669), 'bg': const Color(0xFFECFDF5), 'accent': const Color(0xFF34D399)};
      default:
        return {'color': const Color(0xFF475569), 'bg': const Color(0xFFF1F5F9), 'accent': const Color(0xFFCBD5E1)};
    }
  }

  Color get _statusDot {
    if (widget.project.status.contains('In Progress')) return const Color(0xFF3B82F6);
    if (widget.project.status.contains('Completed')) return const Color(0xFF10B981);
    return const Color(0xFF94A3B8);
  }

  String _initials(String name) {
    if (name.isEmpty || name == '-') return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name[0].toUpperCase();
  }

  // ── Shared helpers ─────────────────────────────────────────────────────────

  Widget _sectionTitle(String label, {String? badge, Color badgeColor = const Color(0xFF4F46E5)}) {
    return Row(
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        if (badge != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: badgeColor.withOpacity(0.3)),
            ),
            child: Text(badge,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: badgeColor)),
          ),
        ],
      ],
    );
  }

  Widget _card({required Widget child, EdgeInsets? padding, Color? color}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: child,
    );
  }

  // ── HOURLY: Timesheet View ──────────────────────────────────────────────────

  Widget _buildTimesheetSection() {
    final logs = widget.project.timesheetLogs ?? [];
    
    // Calculate total logged hours in period snippet
    int totalMins = 0;
    for (var log in logs) {
      try {
        final p = log.hours.split(':');
        totalMins += (int.parse(p[0]) * 60) + int.parse(p[1]);
      } catch (_) {}
    }
    final totalHrsStr = '${(totalMins ~/ 60).toString().padLeft(2, '0')}:${(totalMins % 60).toString().padLeft(2, '0')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // White Top Banner
        _card(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Remaining Balance', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(widget.project.balanceHours ?? '00:00', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Total Logged', style: TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(widget.project.totalBilledHours ?? '00:00', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Color(0xFF10B981))),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Date Filter Chips (Horizontal Scroll)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _filterChip('Last 7 Days', isActive: _activeTimeFilter == 'Last 7 Days', onTap: () => _updateTimeFilter('Last 7 Days')),
              const SizedBox(width: 8),
              _filterChip('This Month', isActive: _activeTimeFilter == 'This Month', onTap: () => _updateTimeFilter('This Month')),
              const SizedBox(width: 8),
              _filterChip('Custom Date', isActive: _activeTimeFilter == 'Custom Date', onTap: _selectCustomDate),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Active Date Range Indicator
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 14, color: Color(0xFF94A3B8)),
                  const SizedBox(width: 8),
                  Text(_dateRangeText, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B), fontFamily: 'monospace')),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(6)),
                child: Text('${logs.length} Record${logs.length == 1 ? '' : 's'}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Log Table
        if (logs.isNotEmpty) ...[
          _card(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('LOG ENTRY', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8), letterSpacing: 0.8)),
                      Text('LOGGED', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8), letterSpacing: 0.8)),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                // Rows
                ...logs.map((log) {
                  return Container(
                    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9)))),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(log.date, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), fontFamily: 'monospace')),
                              const SizedBox(height: 6),
                              Text(log.description, style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B), fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(color: const Color(0xFFF5F3FF), borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            children: [
                              Text(log.hours, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF6366F1))),
                              const Text('hrs', style: TextStyle(fontSize: 9, color: Color(0xFF818CF8), fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                // Footer Total
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: const BoxDecoration(color: Color(0xFFFAFAFA), borderRadius: BorderRadius.vertical(bottom: Radius.circular(14))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Period Total', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                      Text(totalHrsStr, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF6366F1))),
                    ],
                  ),
                )
              ],
            ),
          )
        ] else ...[
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: Text("No timesheet logs for this period.", style: TextStyle(color: Color(0xFF94A3B8)))),
          )
        ]
      ],
    );
  }

  Widget _filterChip(String label, {bool isActive = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0F172A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0)),
        ),
        child: Text(label, style: TextStyle(
          fontSize: 12, 
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          color: isActive ? Colors.white : const Color(0xFF64748B)
        )),
      ),
    );
  }

  // ── COMMON: Project header card ────────────────────────────────────────────

  Widget _buildHeaderCard() {
    final ts = _typeStyle;
    final pms = widget.project.projectManagers.trim().isNotEmpty && widget.project.projectManagers.trim() != '-'
        ? widget.project.projectManagers.split(',').map((e) => e.trim()).toList()
        : <String>[];

    return _card(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coloured top strip
          Container(
            height: 5,
            decoration: BoxDecoration(
              color: ts['accent'],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type badge + status
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: ts['bg'],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(widget.project.projectType,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ts['color'])),
                    ),
                    const SizedBox(width: 10),
                    Container(width: 6, height: 6,
                        decoration: BoxDecoration(color: _statusDot, shape: BoxShape.circle)),
                    const SizedBox(width: 5),
                    Text(widget.project.status,
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 12),
                // Project name
                Text(widget.project.projectName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                const SizedBox(height: 16),
                // Associated Deal
                const Text('ASSOCIATED DEAL',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8), letterSpacing: 0.8)),
                const SizedBox(height: 6),
                Text(widget.project.associatedDeal,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF4F46E5))),
                const SizedBox(height: 16),
                // Managers Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project Manager(s)
                    if (pms.isNotEmpty)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('PROJECT MANAGER',
                                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8), letterSpacing: 0.8)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: pms.map((name) {
                                final colors = [
                                  const Color(0xFF6366F1), const Color(0xFFF97316), const Color(0xFF10B981), const Color(0xFF0EA5E9),
                                ];
                                final ci = pms.indexOf(name) % colors.length;
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 24, height: 24,
                                      decoration: BoxDecoration(color: colors[ci], borderRadius: BorderRadius.circular(6)),
                                      child: Center(
                                        child: Text(_initials(name),
                                            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Flexible(
                                      child: Text(name,
                                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(width: 16),

                    // Deal Manager
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('DEAL MANAGER',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8), letterSpacing: 0.8)),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 24, height: 24,
                                decoration: BoxDecoration(color: const Color(0xFF64748B), borderRadius: BorderRadius.circular(6)),
                                child: Center(
                                  child: Text(_initials(widget.project.dealOwnerName),
                                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(widget.project.dealOwnerName,
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── HOURLY: Top-up summary ─────────────────────────────────────────────────

  Widget _buildHourlySection() {
    final totalHours = widget.project.totalHours ?? 0;
    final billedHours = widget.project.totalBilledHours ?? '00:00';
    final initiallyBought = widget.project.initiallyBoughtHours ?? 0;
    final topUp = widget.project.topUpHours ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Top-Up Summary',
            badge: '${widget.project.topUpRecords?.length ?? 0} Records',
            badgeColor: const Color(0xFF6366F1)),
        const SizedBox(height: 12),

        // ── Balance hours visual card ──
        _card(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text('Balance Hours',
                  style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
              const SizedBox(height: 6),
              Text(
                totalHours.toString(),
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
              ),
              const Text('remaining',
                  style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
              const SizedBox(height: 24),
              Row(
                children: [
                  _hourlyStatBox('Initially Bought', '${initiallyBought.toString()}\nhrs',
                      valueColor: const Color(0xFF6366F1)),
                  const SizedBox(width: 8),
                  _hourlyStatBox('Top-Up', '+${topUp}\nhrs',
                      valueColor: const Color(0xFF10B981)),
                  const SizedBox(width: 8),
                  _hourlyStatBox('Total Hours', '${initiallyBought + topUp}\nhrs',
                      valueColor: const Color(0xFFF97316)),
                  const SizedBox(width: 8),
                  _hourlyStatBox('Total Billed', '$billedHours\n',
                      valueColor: const Color(0xFF0F172A)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // ── Records table ──
        if (widget.project.topUpRecords != null && widget.project.topUpRecords!.isNotEmpty) ...[
          _card(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // Header row
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('COMMENT',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8), letterSpacing: 0.8)),
                      Text('DETAILS',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8), letterSpacing: 0.8)),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                // Rows
                ...widget.project.topUpRecords!.asMap().entries.map((e) {
                  final record = e.value;
                  final isLast = e.key == widget.project.topUpRecords!.length - 1;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(14)) : null,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(record.comment,
                              style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B), fontWeight: FontWeight.w500)),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('${record.topUpHours} hrs',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF6366F1))),
                            const SizedBox(height: 4),
                            Text(record.addedOn,
                                style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _hourlyStatBox(String label, String value, {Color valueColor = const Color(0xFF0F172A)}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            Text(value,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: valueColor)),
          ],
        ),
      ),
    );
  }

  // ── HIREBASE: Skills + Timeline + Resources ────────────────────────────────

  Widget _buildHirebaseSection() {
    final allResources = widget.project.dedicatedResources ?? [];
    
    // Filtering logic
    final filteredByTab = allResources.where((r) => r.isCurrent == _isShowingCurrentResources).toList();
    final filteredBySearch = filteredByTab.where((r) {
      if (_resourceSearchQuery.isEmpty) return true;
      final query = _resourceSearchQuery.toLowerCase();
      return r.name.toLowerCase().contains(query) || r.hiredFor.toLowerCase().contains(query);
    }).toList();

    final currentCount = allResources.where((r) => r.isCurrent).length;
    final pastCount = allResources.where((r) => !r.isCurrent).length;
    
    final displayedResources = filteredBySearch.take(_visibleResourcesCount).toList();
    final remainingCount = filteredBySearch.length - displayedResources.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Required Skills
        if (widget.project.requiredSkills != null && widget.project.requiredSkills!.isNotEmpty) ...[
          _sectionTitle('Required Skills'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.project.requiredSkills!.map((skill) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F3FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(skill,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6366F1))),
            )).toList(),
          ),
          const SizedBox(height: 24),
        ],

        // Project Timeline
        if (widget.project.startDate != null) ...[
          _sectionTitle('Project Timeline'),
          const SizedBox(height: 12),
          Row(
            children: [
              _timelineCard('Start Date', widget.project.startDate!),
              const SizedBox(width: 8),
              _timelineCard('End Date', widget.project.endDate!),
              const SizedBox(width: 8),
              _timelineCard('Sign Off', widget.project.signOffDate!),
            ],
          ),
          const SizedBox(height: 24),
        ],

        // Dedicated Resources Header
        _buildResourceHeader(currentCount, pastCount),
        const SizedBox(height: 16),
        
        // Search Bar
        _buildResourceSearchBar(filteredBySearch.length),
        const SizedBox(height: 8),

        // Result indicator text
        if (_resourceSearchQuery.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 4),
            child: Text(
              'Showing ${displayedResources.length} of ${filteredBySearch.length} results for "$_resourceSearchQuery"',
              style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
            ),
          )
        else if (filteredBySearch.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 4),
            child: Text(
              'Showing ${displayedResources.length} of ${filteredBySearch.length} ${_isShowingCurrentResources ? 'current' : 'past'} resources',
              style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
            ),
          ),

        // Resources List
        if (displayedResources.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: Text('No resources found.', style: TextStyle(color: Color(0xFF94A3B8)))),
          )
        else
          ...displayedResources.asMap().entries.map((entry) {
            final index = entry.key;
            final res = entry.value;
            return _buildResourceRow(res, index);
          }).toList(),

        // Load More Button
        if (remainingCount > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: InkWell(
              onTap: () => setState(() => _visibleResourcesCount += 10),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0), style: BorderStyle.solid), // Dart doesn't have native "dashed" Border, using solid for now or could use CustomPainter
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    'Load more ($remainingCount remaining)',
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B)),
                  ),
                ),
              ),
            ),
          ),

        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildResourceHeader(int currentCount, int pastCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const Text('Dedicated\nResources', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), height: 1.1)),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: const Color(0xFF6366F1).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Text('${currentCount + pastCount}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF6366F1))),
            )
          ],
        ),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              _resourceToggleButton('Current', currentCount, _isShowingCurrentResources, () => setState(() => _isShowingCurrentResources = true)),
              _resourceToggleButton('Past', pastCount, !_isShowingCurrentResources, () => setState(() => _isShowingCurrentResources = false)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _resourceToggleButton(String label, int count, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF818CF8) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))] : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isActive ? Colors.white : const Color(0xFF94A3B8))),
            Text('($count)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isActive ? Colors.white.withOpacity(0.8) : const Color(0xFFCBD5E1))),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceSearchBar(int total) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: _resourceSearchController,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Search by name or skill...',
          hintStyle: const TextStyle(color: Color(0xFFCBD5E1)),
          prefixIcon: const Icon(Icons.search, color: Color(0xFFCBD5E1), size: 20),
          suffixIcon: _resourceSearchQuery.isNotEmpty 
            ? IconButton(icon: const Icon(Icons.close, size: 18), onPressed: () => _resourceSearchController.clear())
            : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildResourceRow(DedicatedResource res, int index) {
    final isExpanded = _expandedResourceIndex == index;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => _expandedResourceIndex = isExpanded ? null : index),
        borderRadius: BorderRadius.circular(14),
        child: _card(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(color: const Color(0xFF818CF8), borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text(_initials(res.name), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(res.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                          Text(res.hiredFor, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(20)),
                          child: Text(res.expiresIn, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6366F1))),
                        ),
                        const SizedBox(height: 4),
                        Text(res.dateFrom, style: const TextStyle(fontSize: 9, color: Color(0xFFCBD5E1))),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 18, color: const Color(0xFFCBD5E1)),
                  ],
                ),
              ),
              if (isExpanded) ...[
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: _lightStatCard('From', res.dateFrom)),
                          const SizedBox(width: 8),
                          Expanded(child: _lightStatCard('To', res.dateTo)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _statTile(
                              label: 'Working Days',
                              value: res.totalWorkingDays,
                              unit: 'days',
                              valueColor: const Color(0xFF0F172A),
                              bgColor: const Color(0xFFF8FAFC),
                              borderColor: const Color(0xFFF1F5F9),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _statTile(
                              label: 'Expires In',
                              value: res.expiresIn.replaceAll('d', ''),
                              unit: 'days',
                              valueColor: const Color(0xFFD97706),
                              bgColor: const Color(0xFFFFFBEB),
                              borderColor: const Color(0xFFFEF3C7),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Hired For', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: const Color(0xFFF5F3FF), borderRadius: BorderRadius.circular(10)),
                                child: Text(res.hiredFor, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6366F1))),
                              ),
                             if (res.name.contains('Lin')) 
                               Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: const Color(0xFFF5F3FF), borderRadius: BorderRadius.circular(10)),
                                child: const Text('Node JS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF6366F1))),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _timelineCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
          ],
        ),
      ),
    );
  }

  Widget _lightStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }

  Widget _statTile({required String label, required String value, required String unit,
      required Color valueColor, required Color bgColor, required Color borderColor}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: bgColor, 
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: valueColor)),
          Text(unit, style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  // ── FIXED COST: Skills + Milestones + Change Requests ─────────────────────

  Widget _buildFixedCostSection() {
    final milestones = widget.project.milestones ?? [];
    final changeRequests = widget.project.changeRequests ?? [];
    final completedCount = milestones.where((m) =>
        m.status == 'Invoice raised' || m.status.toLowerCase().contains('complet') || m.status.toLowerCase().contains('invoice')).length;
    final progress = milestones.isEmpty ? 0.0 : completedCount / milestones.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Required Skills
        if (widget.project.requiredSkills != null && widget.project.requiredSkills!.isNotEmpty) ...[
          _sectionTitle('Required Skills'),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.project.requiredSkills!.map((skill) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFA7F3D0)),
              ),
              child: Text(skill,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF059669))),
            )).toList(),
          ),
          const SizedBox(height: 24),
        ],

        // Milestones
        if (milestones.isNotEmpty) ...[
          _sectionTitle('Milestones'),
          const SizedBox(height: 12),
          _card(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // Progress header removed as requested.

                // Milestone rows
                ...milestones.asMap().entries.map((e) {
                  final m = e.value;
                  final isLast = e.key == milestones.length - 1;
                  final isDone = m.status == 'Invoice raised' || m.status.toLowerCase().contains('complet') || m.status.toLowerCase().contains('invoice');
                  
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24, height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: isDone ? const Color(0xFF10B981) : const Color(0xFFCBD5E1), width: 2),
                          ),
                          child: isDone
                              ? Center(child: Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)))
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(m.name,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF0F172A))),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isDone ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: isDone ? const Color(0xFFA7F3D0) : const Color(0xFFFECACA)),
                                ),
                                child: Text(m.status,
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: isDone ? const Color(0xFF059669) : const Color(0xFFEF4444))),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Change Requests
        if (changeRequests.isNotEmpty) ...[
          _sectionTitle('Change Requests',
              badge: '${changeRequests.length} Request${changeRequests.length == 1 ? '' : 's'}',
              badgeColor: const Color(0xFF6366F1)),
          const SizedBox(height: 12),
          _card(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('COMMENT',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8), letterSpacing: 0.8)),
                      Text('DETAILS',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF94A3B8), letterSpacing: 0.8)),
                    ],
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                ...changeRequests.asMap().entries.map((e) {
                  final cr = e.value;
                  final isLast = e.key == changeRequests.length - 1;
                  final isChargeable = cr.freeOfCost == 'No';
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      border: isLast ? null : const Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                      borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(14)) : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(cr.comment,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1E293B))),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isChargeable ? const Color(0xFFFEF2F2) : const Color(0xFFECFDF5),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isChargeable ? 'Chargeable' : 'Free of Cost',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: isChargeable ? const Color(0xFFEF4444) : const Color(0xFF059669)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(cr.addedOn,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ── Main build ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bool isHourly = widget.project.projectType == 'Hourly Projects';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF6366F1)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text('Projects',
            style: TextStyle(fontSize: 15, color: Color(0xFF6366F1), fontWeight: FontWeight.bold)),
      ),
      body: CustomScrollView(
        slivers: [
          // Header content (Title + Project Header Card)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.project.projectName.split('–').first.trim(),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
                  ),
                  Text(
                    widget.project.projectName.split('–').last.trim(),
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF94A3B8)),
                  ),
                  const SizedBox(height: 20),
                  _buildHeaderCard(),
                ],
              ),
            ),
          ),

          // Sticky Tab Bar (Only for Hourly Projects)
          if (isHourly)
            SliverPersistentHeader(
              pinned: true,
              delegate: _StickyTabBarDelegate(
                child: Container(
                  color: const Color(0xFFF8FAFC), // Match background to blend seamlessly
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9), // Light grey pill background
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      dividerColor: Colors.transparent, // Removes the default black line spanning the width
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 2))
                        ],
                        border: const Border(bottom: BorderSide(color: Color(0xFF6366F1), width: 3)), // Purple underline
                      ),
                      labelColor: const Color(0xFF0F172A),
                      unselectedLabelColor: const Color(0xFF64748B),
                      labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      unselectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      tabs: const [
                        Tab(text: 'Details'),
                        Tab(text: 'Timesheet'),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Content section
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            sliver: SliverToBoxAdapter(
              child: Builder(
                builder: (context) {
                  if (isHourly) {
                    // Hourly is the only one with tabs rn
                    if (_currentTabIndex == 0) {
                      return _buildHourlySection();
                    } else {
                      return _buildTimesheetSection();
                    }
                  } else if (widget.project.projectType == 'Hirebase Projects') {
                    return _buildHirebaseSection();
                  } else if (widget.project.projectType == 'Fixed Cost') {
                    return _buildFixedCostSection();
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper for sticky tab bar ────────────────────────────────────────────────

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _StickyTabBarDelegate({required this.child});

  @override
  double get minExtent => 64.0;
  
  @override
  double get maxExtent => 64.0;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
