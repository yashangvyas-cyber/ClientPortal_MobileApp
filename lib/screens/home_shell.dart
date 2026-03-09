import 'package:flutter/material.dart';
import '../models/organization.dart';
import '../widgets/smart_header.dart';
import 'deals_screen.dart';
import 'projects_screen.dart';
import 'messaging_screen.dart';
import 'settings_screen.dart';

class HomeShell extends StatefulWidget {
  final Organization organization;
  final bool showWelcome;
  const HomeShell({
    super.key, 
    required this.organization,
    this.showWelcome = false,
  });

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;
  late BusinessUnit _currentUnit;

  static const _tabTitles = ['Deals', 'Projects', 'Messages'];

  @override
  void initState() {
    super.initState();
    _currentUnit = widget.organization.businessUnits.first;
    
    if (widget.showWelcome) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Welcome back to ${widget.organization.name}!'),
            backgroundColor: const Color(0xFF4F46E5),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
      });
    }
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsScreen(
          organization: widget.organization,
          currentUnit: _currentUnit,
          onUnitChanged: (unit) => setState(() => _currentUnit = unit),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      DealsScreen(organization: widget.organization, currentUnit: _currentUnit),
      ProjectsScreen(
        organization: widget.organization,
        currentUnit: _currentUnit,
      ),
      MessagingScreen(
        organization: widget.organization,
        currentUnit: _currentUnit,
      ),
    ];

    const activeColor = Color(0xFF4F46E5);
    const inactiveColor = Color(0xFF94A3B8);
    const activeBubble = Color(0xFFEEF2FF);

    final navItems = [
      (
        icon: Icons.monetization_on_outlined,
        activeIcon: Icons.monetization_on,
        label: 'Deals'
      ),
      (
        icon: Icons.folder_outlined,
        activeIcon: Icons.folder,
        label: 'Projects'
      ),
      (
        icon: Icons.chat_bubble_outline,
        activeIcon: Icons.chat_bubble,
        label: 'Messages'
      ),
    ];

    return Scaffold(
      appBar: SmartHeader(
        organization: widget.organization,
        title: _tabTitles[_currentIndex],
        onProfileTap: _openSettings,
      ),
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: List.generate(navItems.length, (index) {
                final item = navItems[index];
                final isActive = _currentIndex == index;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _currentIndex = index),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: isActive
                                ? activeBubble
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            isActive ? item.activeIcon : item.icon,
                            size: 22,
                            color:
                                isActive ? activeColor : inactiveColor,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color:
                                isActive ? activeColor : inactiveColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
