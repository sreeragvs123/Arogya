import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget {
  final bool isSidebarCollapsed;
  final VoidCallback onToggleSidebar;

  const AppTopBar({
    super.key,
    required this.isSidebarCollapsed,
    required this.onToggleSidebar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu_rounded, color: Color(0xFF334155)),
            onPressed: onToggleSidebar,
            tooltip: isSidebarCollapsed ? 'Expand sidebar' : 'Collapse sidebar',
          ),
          const SizedBox(width: 12),
          const Text(
            'Hospital Dashboard — Arogya',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(width: 8),
          const Text('|', style: TextStyle(color: Color(0xFFCBD5E1))),
          const SizedBox(width: 8),
          const Text(
            'Apollo Health City',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: const Text(
              'HOSP-BLR-0192',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: const Row(
              children: [
                CircleAvatar(radius: 3.5, backgroundColor: Color(0xFF10B981)),
                SizedBox(width: 8),
                Text(
                  'Facility Active: Normal Flow',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF065F46),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF64748B)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search_rounded, color: Color(0xFF64748B)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
          const VerticalDivider(width: 24, indent: 16, endIndent: 16),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Dr. Arvind Rao',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
              ),
              Text(
                'Chief Medical Admin',
                style: TextStyle(
                  fontSize: 11,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          const CircleAvatar(
            radius: 18,
            backgroundColor: Color(0xFF2563EB),
            child: Text(
              'AR',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
