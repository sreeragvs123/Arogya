import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class AuthHeroPanel extends StatelessWidget {
  const AuthHeroPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(left: Radius.circular(24)),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // TODO: replace with real clinic imagery (Image.asset/Image.network)
          Container(color: const Color(0xFF0E6B5C)),
          Container(color: AppColors.primary.withOpacity(0.55)),
          Padding(
            padding: const EdgeInsets.fromLTRB(32, 36, 32, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.medical_services_outlined,
                          color: AppColors.primary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Arogya Portal',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Text(
                  'Empowering Clinical Excellence.',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Join a network of elite practitioners dedicated to '
                  'data-driven patient care and seamless hospital management.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.5,
                    height: 1.5,
                  ),
                ),
                const Spacer(flex: 2),
                Row(
                  children: [
                    const _AvatarStack(),
                    const SizedBox(width: 12),
                    const Text(
                      'Trusted by 4,000+ specialized doctors',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  const _AvatarStack();

  @override
  Widget build(BuildContext context) {
    const size = 34.0;
    return SizedBox(
      width: size * 2.4,
      height: size,
      child: Stack(
        children: [
          for (int i = 0; i < 3; i++)
            Positioned(
              left: i * (size * 0.6),
              child: CircleAvatar(
                radius: size / 2,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: size / 2 - 2,
                  backgroundColor: AppColors.softPanel,
                ),
              ),
            ),
          Positioned(
            left: 3 * (size * 0.6),
            child: CircleAvatar(
              radius: size / 2,
              backgroundColor: Colors.white,
              child: const CircleAvatar(
                radius: size / 2 - 2,
                backgroundColor: AppColors.softPanel,
                child: Text('+4k',
                    style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
