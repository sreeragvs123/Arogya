import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/auth_footer_links.dart';
import '../widgets/auth_hero_panel.dart';
import '../widgets/auth_tab_toggle.dart';
import '../widgets/create_account_form.dart';
import '../widgets/sign_in_form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  AuthTab _selectedTab = AuthTab.signIn;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _createEmailController = TextEditingController();
  final _createPasswordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _createEmailController.dispose();
    _createPasswordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    // TODO: dispatch sign-in event, then Navigator.pushReplacementNamed(context, AppRoutes.dashboard)
  }

  void _handleCreateAccount() {
    // TODO: dispatch registration event
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1160, maxHeight: 760),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 40)],
          ),
          child: Row(
            children: [
              const Expanded(flex: 5, child: AuthHeroPanel()),
              Expanded(
                flex: 6,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 40),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AuthTabToggle(
                          selected: _selectedTab,
                          onChanged: (tab) => setState(() => _selectedTab = tab),
                        ),
                        const SizedBox(height: 32),
                        if (_selectedTab == AuthTab.signIn)
                          SignInForm(
                            emailController: _emailController,
                            passwordController: _passwordController,
                            onSubmit: _handleSignIn,
                            onForgotPassword: () {}, // TODO
                          )
                        else
                          CreateAccountForm(
                            nameController: _nameController,
                            emailController: _createEmailController,
                            passwordController: _createPasswordController,
                            onSubmit: _handleCreateAccount,
                          ),
                        const SizedBox(height: 28),
                        AuthFooterLinks(
                          onPrivacyTap: () {},
                          onTermsTap: () {},
                          onSupportTap: () {},
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
