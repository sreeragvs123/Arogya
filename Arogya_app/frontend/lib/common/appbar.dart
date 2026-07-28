import 'package:flutter/material.dart';
import 'package:frontend/presentation/profile/pages/profile_edit_page.dart';
import 'package:frontend/presentation/profile/pages/profile_page.dart';

class ArogyaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final ImageProvider? profileImage;
  final VoidCallback onTap;
  const ArogyaAppBar({super.key, required this.title, this.profileImage,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      automaticallyImplyLeading: false,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.2),
      surfaceTintColor: Colors.transparent,
      backgroundColor: const Color.fromARGB(255, 250, 251, 250),
      title: Text(
        title,
        style: TextStyle(
          color: Color.fromARGB(255, 39, 80, 17),
          fontWeight: FontWeight.w900,
          fontSize: 30,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: const Color.fromARGB(255, 245, 245, 244),
              backgroundImage: profileImage,
              child: profileImage == null
                  ? const Icon(
                      Icons.person,
                      color: Color.fromARGB(255, 82, 79, 79),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
