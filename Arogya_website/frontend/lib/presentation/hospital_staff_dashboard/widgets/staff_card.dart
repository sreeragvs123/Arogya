import 'package:flutter/material.dart';
import 'package:frontend/domain/entities/hospital_staff/staff_entities.dart';
import 'package:frontend/domain/entities/hospital_staff/staff_enums.dart';

class StaffCard extends StatelessWidget {
  final StaffSummaryEntity staff;
  const StaffCard({super.key, required this.staff});

  @override
  Widget build(BuildContext context) {
    final initials = staff.name.trim().isEmpty
        ? '?'
        : staff.name
              .trim()
              .split(RegExp(r'\s+'))
              .take(2)
              .map((p) => p[0].toUpperCase())
              .join();

    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFCCFBF1),
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Color(0xFF0F766E),
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prettyRole(staff.role),
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (staff.department != null)
                _chip(
                  prettyEnum(staff.department!),
                  const Color(0xFFF0FDFA),
                  const Color(0xFF0F766E),
                ),
              _chip(
                staff.isActive ? 'Active' : 'Inactive',
                staff.isActive
                    ? const Color(0xFFDCFCE7)
                    : const Color(0xFFF1F5F9),
                staff.isActive
                    ? const Color(0xFF15803D)
                    : const Color(0xFF64748B),
              ),
              if (staff.onCall)
                _chip(
                  'On call',
                  const Color(0xFFFEF3C7),
                  const Color(0xFFB45309),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.mail_outline_rounded,
                size: 14,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  staff.email,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF475569),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.phone_outlined,
                size: 14,
                color: Color(0xFF94A3B8),
              ),
              const SizedBox(width: 6),
              Text(
                staff.phoneNumber,
                style: const TextStyle(fontSize: 12, color: Color(0xFF475569)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            staff.lastLoginAt == null
                ? 'Never logged in'
                : 'Last login · ${staff.lastLoginAt!.toLocal().toString().substring(0, 16)}',
            style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, Color bg, Color fg) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      text,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: fg),
    ),
  );
}

String prettyRole(String r) => r.isEmpty
    ? '—'
    : r.split('_').map((w) => w[0] + w.substring(1).toLowerCase()).join(' ');
