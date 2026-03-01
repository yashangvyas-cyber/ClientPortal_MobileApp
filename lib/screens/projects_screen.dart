import 'package:flutter/material.dart';

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFF1E3A8A),
              child: Text(
                'JD',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "What's happening?",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Your Teams & Projects",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildListDelegate([
                _buildProjectCard(
                  context,
                  title: 'Brand Identity',
                  team: 'Design Team',
                  updates: 3,
                  icon: Icons.brush,
                  color: const Color(0xFF38BDF8),
                ),
                _buildProjectCard(
                  context,
                  title: 'Mobile App',
                  team: 'Engineering',
                  updates: 12,
                  icon: Icons.phone_android,
                  color: const Color(0xFF1E3A8A),
                ),
                _buildProjectCard(
                  context,
                  title: 'Backend API',
                  team: 'Engineering',
                  updates: 0,
                  icon: Icons.settings_input_component,
                  color: const Color(0xFF10B981),
                ),
                _buildProjectCard(
                  context,
                  title: 'Marketing Site',
                  team: 'Marketing',
                  updates: 5,
                  icon: Icons.language,
                  color: const Color(0xFFF59E0B),
                ),
              ]),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Text(
                    "Recent Activity",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildActivityItem(
                  user: index % 2 == 0 ? 'Sarah Jenkins' : 'Alex Rivera',
                  action: index % 2 == 0 ? 'posted a comment' : 'completed a task',
                  target: index % 2 == 0 ? 'Logo Variations v2' : 'Fix Auth Bug',
                  time: '${index + 2}h ago',
                );
              },
              childCount: 5,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: const Text('New Project'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, {
    required String title,
    required String team,
    required int updates,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8), // ~0.03 opacity
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withAlpha(25), // ~0.1 opacity
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const Spacer(),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  team,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 12),
                if (updates > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$updates new',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  )
                else
                  const Text(
                    'Up to date',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required String user,
    required String action,
    required String target,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFF1F5F9),
            child: Text(
              user[0],
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 14, color: Color(0xFF0F172A)),
                    children: [
                      TextSpan(text: user, style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: ' $action in '),
                      TextSpan(text: target, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF38BDF8))),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
