import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/auth/auth_session.dart';
import '../core/routing/app_routes.dart';

/// Animated Collapsible Sidebar supporting both Expanded (260px) and Collapsed (72px) states
class AppSidebar extends StatelessWidget {
  final bool isCollapsed;
  final String currentRoute;
  final VoidCallback onToggleCollapse;
  final HospitalAdminSession? session;

  const AppSidebar({
    super.key,
    required this.isCollapsed,
    required this.currentRoute,
    required this.onToggleCollapse,
    this.session,
  });

  @override
  Widget build(BuildContext context) {
    final width = isCollapsed ? 72.0 : 260.0;
    final hospitalName = session?.hospitalName ?? 'Hospital';
    final hospitalSubtitle = session?.hospitalCode ??
        (session?.hospitalId != null ? 'Facility ID: ${session!.hospitalId}' : '—');

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOutCubic,
      width: width,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      // ClipRect guarantees that even if a child briefly requests more
      // width than is available mid-animation, it gets clipped instead of
      // throwing a RenderFlex overflow error.
      child: ClipRect(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Brand Header
            Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDFA),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFCCFBF1)),
                    ),
                    child: const Icon(Icons.local_hospital_rounded, color: Color(0xFF0F766E), size: 20),
                  ),
                  // Instead of popping the header text in/out instantly with
                  // `if (!isCollapsed)`, we let it grow/shrink and fade with
                  // the same 250ms duration as the sidebar's width, so it
                  // never demands full width while the container is still
                  // narrow.
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOutCubic,
                    child: isCollapsed
                        ? const SizedBox(width: 0, height: 38)
                        : Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: isCollapsed ? 0 : 1,
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Arogya',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF0F172A),
                                      height: 1.1,
                                    ),
                                  ),
                                  Text(
                                    'CLINICAL ENTERPRISE',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 10,
                                      letterSpacing: 1.1,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),

            // Navigation Links
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                children: [
                  if (!isCollapsed)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Text(
                        'CLINICAL GOVERNANCE',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ),

                  _SidebarItem(
                    icon: Icons.dashboard_outlined,
                    label: 'Hospital Overview',
                    isActive: currentRoute == AppRoutes.hospitalOverview,
                    isCollapsed: isCollapsed,
                  ),
                  _SidebarItem(
                    icon: Icons.people_alt_rounded,
                    label: 'Doctors & Medical Staff',
                    isActive: currentRoute == AppRoutes.doctorsDirectory,
                    isCollapsed: isCollapsed,
                  ),
                  _SidebarItem(
                    icon: Icons.apartment_outlined,
                    label: 'Departments & Wards',
                    isActive: currentRoute == AppRoutes.departments,
                    isCollapsed: isCollapsed,
                  ),
                  _SidebarItem(
                    icon: Icons.assignment_outlined,
                    label: 'Patient Records',
                    isActive: currentRoute == AppRoutes.patientRecords,
                    isCollapsed: isCollapsed,
                  ),

                  const SizedBox(height: 20),
                  if (!isCollapsed)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Text(
                        'OPERATIONS & AUDIT',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ),

                  _SidebarItem(
                    icon: Icons.settings_outlined,
                    label: 'Facility Settings',
                    isActive: currentRoute == AppRoutes.facilitySettings,
                    isCollapsed: isCollapsed,
                  ),
                  _SidebarItem(
                    icon: Icons.verified_user_outlined,
                    label: 'Audit & Compliance',
                    isActive: currentRoute == AppRoutes.auditCompliance,
                    isCollapsed: isCollapsed,
                  ),
                ],
              ),
            ),

            // Bottom Campus Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
              ),
              child: isCollapsed
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  hospitalName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                                Text(
                                  hospitalSubtitle,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const CircleAvatar(
                            radius: 4,
                            backgroundColor: Color(0xFF10B981),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isCollapsed;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isCollapsed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {},
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOutCubic,
            padding: EdgeInsets.symmetric(
              horizontal: isCollapsed ? 0 : 14,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF0F766E) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            alignment: isCollapsed ? Alignment.center : Alignment.centerLeft,
            // ClipRect keeps this row's contents from ever throwing an
            // overflow error while the parent AnimatedContainer is still
            // resizing — any excess is clipped rather than crashing layout.
            child: ClipRect(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    size: 20,
                    color: isActive ? Colors.white : const Color(0xFF64748B),
                  ),
                  // AnimatedSize lets the label's allotted space grow/shrink
                  // in step with the sidebar's own width animation, instead
                  // of popping to full width the instant isCollapsed flips.
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOutCubic,
                    child: isCollapsed
                        ? const SizedBox(width: 0)
                        : Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: isCollapsed ? 0 : 1,
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isActive ? Colors.white : const Color(0xFF334155),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}