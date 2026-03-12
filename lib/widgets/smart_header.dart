import 'package:flutter/material.dart';
import '../models/organization.dart';

class SmartHeader extends StatelessWidget implements PreferredSizeWidget {
  final Organization organization;
  final BusinessUnit currentUnit;
  final VoidCallback? onBuTap;

  const SmartHeader({
    super.key,
    required this.organization,
    required this.currentUnit,
    this.onBuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // ── Left: Business Unit Switcher ──
            Expanded(
              child: GestureDetector(
                onTap: onBuTap,
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      currentUnit.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xFF0F172A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (organization.hasMultipleBusinessUnits) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.keyboard_arrow_down_rounded,
                          size: 22, color: Color(0xFF4F46E5)),
                    ],
                  ],
                ),
              ),
            ),

            // ── Right: Notification bell ──
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Icon(Icons.notifications_outlined,
                      size: 20, color: Color(0xFF475569)),
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.white, blurRadius: 0, spreadRadius: 1.5)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottom: const PreferredSize(
        preferredSize: Size.fromHeight(1),
        child: Divider(height: 1, color: Color(0xFFF1F5F9)),
      ),
    );
  }
}
