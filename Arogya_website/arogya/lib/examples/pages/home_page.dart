import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _heroController;
  late Animation<double> _heroFade;
  late Animation<Offset> _heroSlide;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _heroController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _heroFade = CurvedAnimation(
      parent: _heroController,
      curve: const Interval(0, 0.7, curve: Curves.easeOut),
    );
    _heroSlide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
        CurvedAnimation(parent: _heroController, curve: Curves.easeOutCubic));
    _heroController.forward();
  }

  @override
  void dispose() {
    _heroController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceWhite,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(child: Navbar(scrollController: _scrollController)),
          SliverToBoxAdapter(child: _HeroSection(fade: _heroFade, slide: _heroSlide)),
          const SliverToBoxAdapter(child: _StatsBar()),
          const SliverToBoxAdapter(child: _FeaturesSection()),
          const SliverToBoxAdapter(child: _HowItWorksSection()),
          const SliverToBoxAdapter(child: _RegistrationCTASection()),
          const SliverToBoxAdapter(child: Footer()),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final Animation<double> fade;
  final Animation<Offset> slide;

  const _HeroSection({required this.fade, required this.slide});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: Stack(
        children: [
          // Decorative background circle
          Positioned(
            right: -80,
            top: -80,
            child: Container(
              width: 480,
              height: 480,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.lightGreen.withOpacity(0.18),
              ),
            ),
          ),
          Positioned(
            left: -40,
            bottom: -60,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.mediumGreen.withOpacity(0.07),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 80 : 24,
              vertical: isWide ? 80 : 48,
            ),
            child: isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 5, child: _HeroText(fade: fade, slide: slide)),
                      const SizedBox(width: 60),
                      Expanded(flex: 4, child: _HeroIllustration()),
                    ],
                  )
                : Column(
                    children: [
                      _HeroText(fade: fade, slide: slide),
                      const SizedBox(height: 40),
                      _HeroIllustration(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  final Animation<double> fade;
  final Animation<Offset> slide;

  const _HeroText({required this.fade, required this.slide});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: fade,
      child: SlideTransition(
        position: slide,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.lightGreen.withOpacity(0.35),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Hospital Management Platform',
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGreen,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Smarter Care,\nBetter Outcomes.',
              style: GoogleFonts.playfairDisplay(
                fontSize: 52,
                fontWeight: FontWeight.w700,
                color: AppColors.darkText,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Arogya brings hospitals, doctors, and patients together on one seamless platform — from patient registration to medication reminders.',
              style: GoogleFonts.dmSans(
                fontSize: 17,
                color: AppColors.mutedText,
                height: 1.7,
              ),
            ),
            const SizedBox(height: 36),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/register'),
                  icon: const Icon(Icons.add_business_rounded, size: 18),
                  label: const Text('Register Your Hospital'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  icon: const Icon(Icons.login_rounded, size: 18),
                  label: const Text('Hospital Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _StatCard(icon: Icons.local_hospital_rounded, label: 'Hospitals', value: '120+', color: AppColors.primaryGreen),
              const SizedBox(width: 12),
              _StatCard(icon: Icons.people_alt_rounded, label: 'Patients', value: '50K+', color: AppColors.mediumGreen),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatCard(icon: Icons.medical_services_rounded, label: 'Doctors', value: '800+', color: AppColors.mediumGreen),
              const SizedBox(width: 12),
              _StatCard(icon: Icons.receipt_long_rounded, label: 'Receipts', value: '200K+', color: AppColors.primaryGreen),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.qr_code_2_rounded,
                      color: AppColors.primaryGreen, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Patient QR Card System',
                          style: GoogleFonts.dmSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColors.darkText)),
                      Text('Instant verification at every visit',
                          style: GoogleFonts.dmSans(
                              fontSize: 12, color: AppColors.mutedText)),
                    ],
                  ),
                ),
                const Icon(Icons.check_circle_rounded,
                    color: AppColors.successGreen, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 8),
            Text(value,
                style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkText)),
            Text(label,
                style: GoogleFonts.dmSans(
                    fontSize: 12, color: AppColors.mutedText)),
          ],
        ),
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  const _StatsBar();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Container(
      color: AppColors.primaryGreen,
      padding: EdgeInsets.symmetric(
          vertical: 28, horizontal: isWide ? 80 : 24),
      child: isWide
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: _statsItems(),
            )
          : Column(
              children: _statsItems()
                  .map((w) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: w))
                  .toList()),
    );
  }

  List<Widget> _statsItems() => [
        _StatsItem(value: '99.9%', label: 'Uptime'),
        _StatsItem(value: 'HIPAA', label: 'Compliant'),
        _StatsItem(value: '< 1s', label: 'QR Scan Speed'),
        _StatsItem(value: '24/7', label: 'Support'),
      ];
}

class _StatsItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatsItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: AppColors.white)),
        Text(label,
            style: GoogleFonts.dmSans(
                fontSize: 13,
                color: AppColors.lightGreen,
                letterSpacing: 0.5)),
      ],
    );
  }
}

class _FeaturesSection extends StatelessWidget {
  const _FeaturesSection();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
          horizontal: isWide ? 80 : 24, vertical: 72),
      child: Column(
        children: [
          Text('Everything your hospital needs',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center),
          const SizedBox(height: 10),
          Text(
              'Arogya covers the full lifecycle of hospital operations — from registration to recovery.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: 52),
          GridView.count(
            crossAxisCount: isWide ? 3 : 1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: isWide ? 1.2 : 3,
            children: const [
              _FeatureCard(
                icon: Icons.account_tree_rounded,
                title: 'Department Management',
                description: 'Organise departments and assign doctors with ease.',
              ),
              _FeatureCard(
                icon: Icons.qr_code_scanner_rounded,
                title: 'QR Patient Cards',
                description: 'Unique QR cards for instant patient verification.',
              ),
              _FeatureCard(
                icon: Icons.inventory_2_rounded,
                title: 'Pharmacy Inventory',
                description: 'Track medicine stock in real-time.',
              ),
              _FeatureCard(
                icon: Icons.receipt_long_rounded,
                title: 'Checkup Receipts',
                description: 'Digital receipts with scan reports and prescriptions.',
              ),
              _FeatureCard(
                icon: Icons.alarm_rounded,
                title: 'Medication Reminders',
                description: 'Auto-schedule alarms for patient medication timings.',
              ),
              _FeatureCard(
                icon: Icons.upload_file_rounded,
                title: 'Data Transfer',
                description: 'Share PDFs and images securely between hospital and patient.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.primaryGreen : AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? AppColors.primaryGreen
                : AppColors.borderColor,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon,
                color: _hovered ? AppColors.white : AppColors.primaryGreen,
                size: 32),
            const SizedBox(height: 14),
            Text(widget.title,
                style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _hovered ? AppColors.white : AppColors.darkText)),
            const SizedBox(height: 6),
            Text(widget.description,
                style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: _hovered
                        ? AppColors.lightGreen
                        : AppColors.mutedText,
                    height: 1.5)),
          ],
        ),
      ),
    );
  }
}

class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    return Container(
      color: AppColors.surfaceWhite,
      padding: EdgeInsets.symmetric(
          horizontal: isWide ? 80 : 24, vertical: 72),
      child: Column(
        children: [
          Text('How Arogya works',
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center),
          const SizedBox(height: 48),
          isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _steps(context),
                )
              : Column(children: _steps(context)),
        ],
      ),
    );
  }

  List<Widget> _steps(BuildContext context) => [
        _StepCard(
            step: '01',
            title: 'Hospital registers',
            description:
                'The hospital signs up on Arogya and sets up its profile with departments and staff.'),
        _Arrow(),
        _StepCard(
            step: '02',
            title: 'Patients get QR cards',
            description:
                'On first visit, patients are registered and given a printed QR card with their unique ID.'),
        _Arrow(),
        _StepCard(
            step: '03',
            title: 'Nurse scans & verifies',
            description:
                'At every visit, the nurse scans the QR card to pull up patient records instantly.'),
        _Arrow(),
        _StepCard(
            step: '04',
            title: 'Doctor treats & prescribes',
            description:
                'Doctor records checkup details, prescriptions, and reports — sent directly to the patient app.'),
      ];
}

class _Arrow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 900;
    return isWide
        ? Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Icon(Icons.arrow_forward_rounded,
                color: AppColors.lightGreen, size: 28),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Icon(Icons.arrow_downward_rounded,
                color: AppColors.lightGreen, size: 28),
          );
  }
}

class _StepCard extends StatelessWidget {
  final String step;
  final String title;
  final String description;

  const _StepCard({
    required this.step,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(step,
                style: GoogleFonts.playfairDisplay(
                    fontSize: 36,
                    fontWeight: FontWeight.w700,
                    color: AppColors.lightGreen)),
            const SizedBox(height: 10),
            Text(title,
                style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkText)),
            const SizedBox(height: 8),
            Text(description,
                style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: AppColors.mutedText,
                    height: 1.6)),
          ],
        ),
      ),
    );
  }
}

class _RegistrationCTASection extends StatelessWidget {
  const _RegistrationCTASection();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: isWide ? 80 : 24, vertical: 60),
      padding: EdgeInsets.symmetric(
          horizontal: isWide ? 60 : 28, vertical: 52),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text('Ready to transform your hospital?',
              style: GoogleFonts.playfairDisplay(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white),
              textAlign: TextAlign.center),
          const SizedBox(height: 14),
          Text(
              'Join hundreds of hospitals already using Arogya to deliver better patient care.',
              style: GoogleFonts.dmSans(
                  fontSize: 16, color: AppColors.lightGreen, height: 1.6),
              textAlign: TextAlign.center),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.primaryGreen,
              padding:
                  const EdgeInsets.symmetric(horizontal: 36, vertical: 18),
            ),
            child: Text('Register Your Hospital',
                style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w700, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}