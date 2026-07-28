
import 'package:flutter/material.dart';


// ── Color constants ──────────────────────────────────────────────────────────
const _kGreenDark = Color(0xFF173404);
const _kGreenMid = Color(0xFF27500A);
const _kGreenBright = Color(0xFF3B6D11);
const _kGreenLight = Color(0xFFEAF3DE);
const _kGreenAccent = Color(0xFFC0DD97);
const _kGreenMuted = Color(0xFF639922);
const _kWhite = Colors.white;

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4FAF0),
      body: CustomScrollView(
        slivers: [
          _ArogyaAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _HeroSection(),
                _TrustBar(),
                _FeaturesSection(),
                _HowItWorksSection(),
                _CtaSection(),
                _Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── App Bar ──────────────────────────────────────────────────────────────────
class _ArogyaAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      elevation: 0,
      backgroundColor: _kWhite,
      surfaceTintColor: _kWhite,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _kGreenMid,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.favorite_rounded,
                color: _kGreenLight, size: 18),
          ),
          const SizedBox(width: 10),
          const Text(
            'Arogya',
            style: TextStyle(
              color: _kGreenMid,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text('Log in',
              style: TextStyle(color: _kGreenMid, fontWeight: FontWeight.w600)),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 4),
          child: ElevatedButton(
            onPressed: () {
              // Navigate to HospitalRegistrationScreen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _kGreenMid,
              foregroundColor: _kWhite,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 0,
            ),
            child: const Text('Register',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: const Color(0xFFE0EDD0)),
      ),
    );
  }
}

// ── Hero Section ─────────────────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFEAF3DE), Color(0xFFF4FAF0), _kWhite],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: _kGreenAccent,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.verified_rounded,
                    size: 13, color: _kGreenMid),
                SizedBox(width: 6),
                Text(
                  'Trusted by hospitals across India',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _kGreenMid,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Headline
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: _kGreenDark,
                height: 1.25,
              ),
              children: [
                TextSpan(text: 'Healthcare,\n'),
                TextSpan(
                  text: 'connected',
                  style: TextStyle(color: _kGreenBright),
                ),
                TextSpan(text: '\nfrom doctor to patient'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Arogya lets hospitals register, onboard doctors, and send treatment records directly to patients\' phones — securely, under the doctor\'s name.',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF5A7A3A),
              height: 1.7,
            ),
          ),
          const SizedBox(height: 28),
          // CTA buttons
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kGreenMid,
                    foregroundColor: _kWhite,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 2,
                  ),
                  child: const Text('Register your hospital',
                      style: TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _kGreenMid,
                    side: const BorderSide(color: _kGreenMid, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('How it works',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Dashboard preview card
          _DashboardPreviewCard(),
        ],
      ),
    );
  }
}

class _DashboardPreviewCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _kWhite,
        border: Border.all(color: _kGreenAccent),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: _kGreenMid.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dashboard overview',
              style: TextStyle(
                  fontSize: 11,
                  color: _kGreenMuted,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8)),
          const SizedBox(height: 14),
          Row(
            children: const [
              Expanded(child: _MiniStat(value: '124', label: 'Hospitals')),
              SizedBox(width: 12),
              Expanded(child: _MiniStat(value: '2.4k', label: 'Doctors')),
            ],
          ),
          const SizedBox(height: 14),
          const Text('Recent patient updates',
              style: TextStyle(
                  fontSize: 11,
                  color: _kGreenMuted,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const _PatientRow(
              initials: 'RK',
              name: 'Rajan Kumar',
              sub: 'Blood report sent',
              status: 'Sent',
              isGreen: true),
          const _PatientRow(
              initials: 'SA',
              name: 'Sunita Agarwal',
              sub: 'Prescription update',
              status: 'Sent',
              isGreen: true),
          const _PatientRow(
              initials: 'MV',
              name: 'Mohan Varghese',
              sub: 'Awaiting review',
              status: 'Pending',
              isGreen: false),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String value;
  final String label;
  const _MiniStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _kGreenLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _kGreenMid)),
          const SizedBox(height: 3),
          Text(label,
              style: const TextStyle(fontSize: 11, color: _kGreenBright)),
        ],
      ),
    );
  }
}

class _PatientRow extends StatelessWidget {
  final String initials;
  final String name;
  final String sub;
  final String status;
  final bool isGreen;

  const _PatientRow({
    required this.initials,
    required this.name,
    required this.sub,
    required this.status,
    required this.isGreen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: _kGreenLight, width: 1)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: _kGreenAccent,
            child: Text(initials,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _kGreenMid)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _kGreenDark)),
                Text(sub,
                    style: const TextStyle(
                        fontSize: 11, color: _kGreenMuted)),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: isGreen
                  ? _kGreenLight
                  : const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: isGreen
                    ? _kGreenBright
                    : const Color(0xFF92400E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Trust Bar ────────────────────────────────────────────────────────────────
class _TrustBar extends StatelessWidget {
  static const _stats = [
    ('124+', 'Hospitals'),
    ('2,400+', 'Doctors'),
    ('18k+', 'Records sent'),
    ('99.9%', 'Uptime'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kWhite,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _stats
            .map((s) => Column(
                  children: [
                    Text(s.$1,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: _kGreenMid)),
                    const SizedBox(height: 4),
                    Text(s.$2,
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF5A7A3A))),
                  ],
                ))
            .toList(),
      ),
    );
  }
}

// ── Features Section ─────────────────────────────────────────────────────────
class _FeaturesSection extends StatelessWidget {
  static const _features = [
    (Icons.local_hospital_rounded, 'Hospital registration',
        'Simple multi-step onboarding with verification and admin setup.', Color(0xFF27500A), _kGreenLight),
    (Icons.medical_services_rounded, 'Doctor onboarding',
        'Register and manage doctors, each with their own verified profile.', Color(0xFF0F6E56), Color(0xFFE1F5EE)),
    (Icons.description_rounded, 'Treatment records',
        'Doctors send prescriptions and reports directly to patients.', Color(0xFF185FA5), Color(0xFFEBF4FF)),
    (Icons.smartphone_rounded, 'Patient app',
        'Patients receive updates on their phone securely and instantly.', Color(0xFF92400E), Color(0xFFFEF3C7)),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel('What we offer'),
          const SizedBox(height: 8),
          const Text('Everything your hospital needs',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _kGreenDark)),
          const SizedBox(height: 8),
          const Text(
            'From registration to record delivery — Arogya connects every step of the care journey.',
            style: TextStyle(
                fontSize: 13, color: Color(0xFF5A7A3A), height: 1.7),
          ),
          const SizedBox(height: 24),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 0.9,
            children: _features
                .map((f) => _FeatureCard(
                      icon: f.$1,
                      title: f.$2,
                      description: f.$3,
                      iconColor: f.$4,
                      iconBg: f.$5,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color iconColor;
  final Color iconBg;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.iconColor,
    required this.iconBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _kWhite,
        border: Border.all(color: const Color(0xFFE0EDD0)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 14),
          Text(title,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _kGreenDark)),
          const SizedBox(height: 8),
          Text(description,
              style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF5A7A3A),
                  height: 1.6)),
        ],
      ),
    );
  }
}

// ── How It Works ─────────────────────────────────────────────────────────────
class _HowItWorksSection extends StatelessWidget {
  static const _steps = [
    ('1', 'Hospital registers', 'Fill in details and get verified on the platform.'),
    ('2', 'Doctors are added', 'Admin registers doctors under their facility.'),
    ('3', 'Patient visits', 'Doctor logs the visit and adds treatment notes.'),
    ('4', 'Record delivered', 'Patient receives data on their phone instantly.'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kGreenLight,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionLabel('How it works'),
          const SizedBox(height: 8),
          const Text('From registration to\npatient in 4 steps',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _kGreenDark)),
          const SizedBox(height: 24),
          ...List.generate(_steps.length, (i) {
            final step = _steps[i];
            final isLast = i == _steps.length - 1;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        color: _kGreenMid,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(step.$1,
                            style: const TextStyle(
                                color: _kWhite,
                                fontWeight: FontWeight.w700,
                                fontSize: 14)),
                      ),
                    ),
                    if (!isLast)
                      Container(
                          width: 2, height: 48, color: _kGreenAccent),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(step.$2,
                            style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: _kGreenDark)),
                        const SizedBox(height: 4),
                        Text(step.$3,
                            style: const TextStyle(
                                fontSize: 13,
                                color: _kGreenBright,
                                height: 1.6)),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

// ── CTA Section ──────────────────────────────────────────────────────────────
class _CtaSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _kGreenMid,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 56),
      child: Column(
        children: [
          const Text(
            'Ready to bring your\nhospital online?',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: _kGreenLight,
                height: 1.3),
          ),
          const SizedBox(height: 14),
          const Text(
            'Join hundreds of hospitals already using Arogya to improve care delivery across India.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 14,
                color: _kGreenAccent,
                height: 1.7),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: _kWhite,
                foregroundColor: _kGreenMid,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text('Register your hospital',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: _kGreenAccent,
                side: const BorderSide(color: _kGreenAccent, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Contact us',
                  style: TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Footer ───────────────────────────────────────────────────────────────────
class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: _kGreenDark,
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _kGreenMid,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.favorite_rounded,
                    color: _kGreenLight, size: 16),
              ),
              const SizedBox(width: 8),
              const Text('Arogya',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _kGreenAccent)),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Connecting hospitals, doctors, and patients through secure digital health records across India.',
            style: TextStyle(
                fontSize: 12,
                color: _kGreenMuted,
                height: 1.7),
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFF27500A), thickness: 1),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('© 2026 Arogya',
                  style: TextStyle(fontSize: 11, color: _kGreenBright)),
              Text('Made with care in India 🌿',
                  style: TextStyle(fontSize: 11, color: _kGreenBright)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Shared Widgets ───────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: _kGreenMuted,
        letterSpacing: 1.2,
      ),
    );
  }
}
