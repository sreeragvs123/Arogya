import 'package:flutter/material.dart';

import '../pages/auth_page.dart';

class AuthHeroPanel extends StatelessWidget {
  final AuthTab type;

  const AuthHeroPanel({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AuthTab.doctorSignIn:
        return _HeroContent(
          title: 'Empowering Clinical Excellence.',
          description:
              'Join a network of elite practitioners dedicated '
              'to data-driven patient care and seamless hospital management.',
          bottomText: 'Trusted by 4,000+ specialized doctors',
        );

      case AuthTab.hospitalSignIn:
        return _HeroContent(
          title: 'Empowering Clinical Excellence.',
          description:
              'Unifying healthcare networks, real-time hospital '
              'administration, and connected doctor workspaces.',
          bottomText: 'Trusted by 120+ accredited medical centers',
        );

      case AuthTab.registerHospital:
        return _HeroContent(
          title: 'Empowering Clinical Excellence.',
          description:
              'Register your hospital or clinic network to digitize '
              'clinical workflows, coordinate multidisciplinary doctor '
              'teams, and connect patient health records securely.',
          bottomText: 'Trusted by 650+ verified medical centers',
          showFeatureList: true,
        );
      case AuthTab.staffSignIn:
        return _HeroContent(
          title: 'Welcome Back, Care Team.',
          description:
              'Sign in to access your assigned patient schedules, '
              'coordinate with multidisciplinary departments, and '
              'manage secure clinical notes in real-time.',
          bottomText: 'HIPAA-compliant & secure staff portal',
          showFeatureList: false,
        );
    }
  }
}

class _HeroContent extends StatelessWidget {
  final String title;
  final String description;
  final String bottomText;
  final bool showFeatureList;

  const _HeroContent({
    required this.title,
    required this.description,
    required this.bottomText,
    this.showFeatureList = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFF00574B)),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(color: const Color(0xCC00574F)),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 42),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _Logo(),

                const Spacer(),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 30,
                    height: 1.1,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 18),

                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.55,
                    color: Color(0xFFD1E9E6),
                  ),
                ),

                if (showFeatureList) ...[
                  const SizedBox(height: 24),
                  const _Feature(
                    text:
                        'Centralized departmental & ward doctor account provisioning',
                  ),
                  const _Feature(
                    text:
                        'Real-time OPD, IPD, and laboratory EHR synchronization',
                  ),
                  const _Feature(
                    text:
                        'Granular HIPAA & ABDM compliant role-based data isolation',
                  ),
                ],

                const Spacer(),

                Container(height: 1, color: Colors.white.withOpacity(0.18)),

                const SizedBox(height: 20),

                Row(
                  children: [
                    _AvatarStack(),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Text(
                        bottomText,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 1.4,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
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

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            Icons.local_hospital_outlined,
            color: Color(0xFF00796B),
            size: 27,
          ),
        ),

        const SizedBox(width: 12),

        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Arogya',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'CLINICAL PORTAL',
              style: TextStyle(
                color: Color(0xFFB5DDD8),
                fontSize: 10,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Feature extends StatelessWidget {
  final String text;

  const _Feature({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF35B9A8)),
            ),
            child: const Icon(Icons.check, size: 13, color: Color(0xFF5FD3C3)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvatarStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      height: 38,
      child: Stack(
        children: [
          for (int i = 0; i < 4; i++)
            Positioned(
              left: i * 19,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: i == 3
                      ? const Color(0xFF0AA58D)
                      : const Color(0xFFD9E8E5),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: i == 3
                    ? const Center(
                        child: Text(
                          '+4k',
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}
