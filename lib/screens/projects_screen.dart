import 'package:flutter/material.dart';
import '../models/organization.dart';
import '../models/project_data.dart';
import 'project_details_screen.dart';

class ProjectsScreen extends StatefulWidget {
  final Organization organization;
  final BusinessUnit currentUnit;

  const ProjectsScreen({
    super.key,
    required this.organization,
    required this.currentUnit,
  });

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All';

  List<ProjectData> get _filteredProjects {
    var result = mockProjects;

    if (_selectedFilter != 'All') {
      result =
          result.where((p) => p.status.contains(_selectedFilter)).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where(
            (p) =>
                p.projectName.toLowerCase().contains(q) ||
                p.dealOwnerName.toLowerCase().contains(q) ||
                p.projectType.toLowerCase().contains(q),
          )
          .toList();
    }

    return result;
  }

  static Map<String, Color> _statusStyle(String status) {
    if (status.contains('Not Started')) {
      return {
        'color': const Color(0xFF64748B),
        'dot': const Color(0xFF94A3B8),
        'bg': const Color(0xFFF1F5F9),
      };
    } else if (status.contains('In Progress')) {
      return {
        'color': const Color(0xFF3B82F6),
        'dot': const Color(0xFF3B82F6),
        'bg': const Color(0xFFEFF6FF),
      };
    } else if (status.contains('Completed')) {
      return {
        'color': const Color(0xFF10B981),
        'dot': const Color(0xFF10B981),
        'bg': const Color(0xFFD1FAE5),
      };
    }
    return {
      'color': const Color(0xFF64748B),
      'dot': const Color(0xFF94A3B8),
      'bg': const Color(0xFFF1F5F9),
    };
  }

  static Map<String, Color> _typeStyle(String type) {
    if (type.contains('Hourly')) {
      return {
        'color': const Color(0xFF6366F1),
        'bg': const Color(0xFFEEF2FF),
        'border': const Color(0xFF818CF8),
      };
    } else if (type.contains('Hirebase')) {
      return {
        'color': const Color(0xFFD97706),
        'bg': const Color(0xFFFEF3C7),
        'border': const Color(0xFFFBBF24),
      };
    } else if (type.contains('Fixed')) {
      return {
        'color': const Color(0xFF059669),
        'bg': const Color(0xFFD1FAE5),
        'border': const Color(0xFF34D399),
      };
    }
    return {
      'color': const Color(0xFF475569),
      'bg': const Color(0xFFF1F5F9),
      'border': const Color(0xFFCBD5E1),
    };
  }

  Widget _buildSummaryRow() {
    final total = mockProjects.length;
    final notStarted =
        mockProjects.where((p) => p.status.contains('Not Started')).length;
    final inProgress =
        mockProjects.where((p) => p.status.contains('In Progress')).length;
    final completed =
        mockProjects.where((p) => p.status.contains('Completed')).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatChip(label: 'Total', value: total),
          _StatChip(label: 'Not Started', value: notStarted),
          _StatChip(label: 'In Progress', value: inProgress),
          _StatChip(label: 'Completed', value: completed),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    final filters = ['All', 'Not Started', 'In Progress', 'Completed'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: filters.map((f) {
          final isSelected = _selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = f),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1E293B)
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Text(
                  f,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF64748B),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final projects = _filteredProjects;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                const Text(
                  'Projects',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFC7D2FE)),
                  ),
                  child: Text(
                    '${projects.length} ${projects.length == 1 ? 'Project' : 'Projects'}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4F46E5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // _buildSummaryRow(), // Removed as per request

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'Search projects or clients...',
                hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8), fontSize: 13),
                prefixIcon: const Icon(Icons.search_rounded,
                    color: Color(0xFF94A3B8), size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close,
                            size: 18, color: Color(0xFF94A3B8)),
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
                  borderSide: const BorderSide(
                      color: Color(0xFF4F46E5), width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // _buildFilterRow(), // Removed as per request

          const SizedBox(height: 4),
          Expanded(
            child: projects.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                    itemCount: projects.length,
                    itemBuilder: (context, i) => _ProjectCard(
                      project: projects[i],
                      statusStyle: _statusStyle(projects[i].status),
                      typeStyle: _typeStyle(projects[i].projectType),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: Color(0xFFEEF2FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_off_rounded,
                size: 32, color: Color(0xFF4F46E5)),
          ),
          const SizedBox(height: 16),
          const Text(
            'No projects found',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try a different search term or filter',
            style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }
}

// ── Custom Expandable Project Card ─────────────────────────────────────────

class _ProjectCard extends StatefulWidget {
  final ProjectData project;
  final Map<String, Color> statusStyle;
  final Map<String, Color> typeStyle;

  const _ProjectCard({
    required this.project,
    required this.statusStyle,
    required this.typeStyle,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _expanded = false;

  String _ownerInitials(String name) {
    if (name.isEmpty || name == '-') return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  /// Builds stacked overlapping avatar circles with optional +N overflow chip.
  Widget _buildAvatarStack(List<String> pmNames) {
    const avatarSize = 26.0;
    const overlapOffset = 16.0;
    const maxVisible = 3;

    final visibleCount =
        pmNames.length > maxVisible ? maxVisible : pmNames.length;
    final hasOverflow = pmNames.length > maxVisible;
    final overflowCount = pmNames.length - maxVisible;

    final totalAvatars = hasOverflow ? visibleCount + 1 : visibleCount;
    final stackWidth = avatarSize + ((totalAvatars - 1) * overlapOffset);

    final colors = [
      const Color(0xFF6366F1),
      const Color(0xFFF97316),
      const Color(0xFF10B981),
    ];

    final avatarWidgets = <Widget>[];

    for (int i = 0; i < visibleCount; i++) {
      avatarWidgets.add(
        Positioned(
          left: i * overlapOffset,
          child: Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              color: colors[i % colors.length],
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: Center(
              child: Text(
                _ownerInitials(pmNames[i]),
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (hasOverflow) {
      avatarWidgets.add(
        Positioned(
          left: visibleCount * overlapOffset,
          child: Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 1.5),
            ),
            child: Center(
              child: Text(
                '+$overflowCount',
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: stackWidth,
      height: avatarSize,
      child: Stack(children: avatarWidgets),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final hasPm =
        p.projectManagers.trim().isNotEmpty && p.projectManagers.trim() != '-';
    final List<String> pmNames = hasPm
        ? p.projectManagers.split(',').map((e) => e.trim()).toList()
        : [];

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProjectDetailsScreen(project: p),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        // FIX: Flutter does not allow non-uniform Border with borderRadius.
        // Using clipBehavior + IntrinsicHeight + Row with a colored left strip instead.
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        clipBehavior: Clip.antiAlias,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Colored left accent strip
              Container(
                width: 5,
                color: widget.typeStyle['border'],
              ),
              // Card body
              Expanded(
                child: ColoredBox(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 11),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Type badge + Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: widget.typeStyle['bg'],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                p.projectType,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: widget.typeStyle['color'],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: widget.statusStyle['dot'],
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  p.status,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: widget.statusStyle['color'],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 9),
                        // Project title
                        Text(
                          p.projectName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 9),
                        // PM row
                        if (hasPm)
                          Row(
                            children: [
                              _buildAvatarStack(pmNames),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  pmNames.length == 1
                                      ? 'Project Manager'
                                      : '${pmNames.length} Project Managers',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF475569),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => _expanded = !_expanded),
                                behavior: HitTestBehavior.opaque,
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(
                                    _expanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    size: 18,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Unassigned',
                                style: TextStyle(
                                    fontSize: 11, color: Color(0xFF94A3B8)),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => _expanded = !_expanded),
                                behavior: HitTestBehavior.opaque,
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Icon(
                                    _expanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    size: 18,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        // Expanded section
                        if (_expanded) ...[
                          const SizedBox(height: 11),
                          const Divider(
                              height: 1, color: Color(0xFFF1F5F9)),
                          const SizedBox(height: 11),
                          // Deal
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.link_rounded,
                                  size: 13, color: Color(0xFF94A3B8)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Deal',
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: Color(0xFF94A3B8),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      p.associatedDeal,
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF4F46E5),
                                          fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Owner
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.business_center_outlined,
                                  size: 13, color: Color(0xFF94A3B8)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Owner',
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: Color(0xFF94A3B8),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      p.dealOwnerName,
                                      style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF0F172A),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Summary Stats Chip ─────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final String label;
  final int value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
