import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/organization.dart';

class SmartHeader extends StatelessWidget implements PreferredSizeWidget {
  final Organization organization;
  final String title; // Dynamic screen title (Deals / Projects / Messages)
  final VoidCallback? onProfileTap;

  const SmartHeader({
    super.key,
    required this.organization,
    required this.title,
    this.onProfileTap,
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
            // ── Left: CollabCRM Logo ──
            SvgPicture.asset(
              'assets/collabcrm_logo.svg',
              height: 32,
              width: 32,
            ),
            const SizedBox(width: 12),

            // ── Center: Current screen name ──
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: Color(0xFF0F172A),
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
                        BoxShadow(
                            color: Colors.white,
                            blurRadius: 0,
                            spreadRadius: 1.5)
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),

            // ── Profile avatar → opens settings ──
            GestureDetector(
              onTap: onProfileTap,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF8B5CF6).withAlpha(60),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'JM',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
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
