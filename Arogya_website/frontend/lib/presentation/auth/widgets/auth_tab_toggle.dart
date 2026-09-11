import 'package:flutter/material.dart';

import '../pages/auth_page.dart';

class AuthTabToggle extends StatelessWidget {
  final AuthTab selected;
  final ValueChanged<AuthTab> onChanged;

  const AuthTabToggle({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 58,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFE2E8F0),
        ),
      ),
      child: Row(
        children: [
          _TabItem(
            icon: Icons.person_outline,
            title: 'Doctor Sign In',
            selected: selected == AuthTab.doctorSignIn,
            onTap: () => onChanged(AuthTab.doctorSignIn),
          ),

          _TabItem(
            icon: Icons.local_hospital_outlined,
            title: 'Hospital Sign In',
            selected: selected == AuthTab.hospitalSignIn,
            onTap: () => onChanged(AuthTab.hospitalSignIn),
          ),

          _TabItem(
            icon: Icons.add_business_outlined,
            title: 'Register Hospital',
            selected: selected == AuthTab.registerHospital,
            onTap: () => onChanged(AuthTab.registerHospital),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _TabItem({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(9),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 17,
                  color: selected
                      ? const Color(0xFF00695C)
                      : const Color(0xFF475569),
                ),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w400,
                      color: selected
                          ? const Color(0xFF00695C)
                          : const Color(0xFF475569),
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
}