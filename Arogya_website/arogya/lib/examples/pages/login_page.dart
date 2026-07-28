import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/auth_layout.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    // TODO: Replace with real auth service call
    // On success:
    Navigator.pushReplacementNamed(
      context,
      '/dashboard',
      arguments: {'hospitalName': _usernameController.text},
    );

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo & heading
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightGreen.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_hospital_rounded,
                  color: AppColors.primaryGreen, size: 36),
            ),
          ),
          const SizedBox(height: 20),
          Text('Welcome back',
              style: GoogleFonts.playfairDisplay(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkText),
              textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text('Sign in to your hospital dashboard',
              style: GoogleFonts.dmSans(
                  fontSize: 14, color: AppColors.mutedText),
              textAlign: TextAlign.center),
          const SizedBox(height: 36),

          // Error message
          if (_errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.errorRed.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: AppColors.errorRed.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error_outline_rounded,
                      color: AppColors.errorRed, size: 18),
                  const SizedBox(width: 8),
                  Text(_errorMessage!,
                      style: GoogleFonts.dmSans(
                          fontSize: 13, color: AppColors.errorRed)),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],

          // Form
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Hospital Username',
                    prefixIcon: Icon(Icons.business_rounded,
                        color: AppColors.mediumGreen, size: 20),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter your username' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline_rounded,
                        color: AppColors.mediumGreen, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.mutedText,
                        size: 20,
                      ),
                      onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter your password' : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text('Forgot password?',
                  style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: AppColors.mediumGreen,
                      fontWeight: FontWeight.w500)),
            ),
          ),
          const SizedBox(height: 20),

          // Login button
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.white),
                    )
                  : const Text('Sign In'),
            ),
          ),
          const SizedBox(height: 24),

          // Divider
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('or',
                    style: GoogleFonts.dmSans(
                        fontSize: 13, color: AppColors.mutedText)),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 24),

          // Register link
          OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/register'),
            icon: const Icon(Icons.add_business_rounded, size: 18),
            label: const Text('Register a New Hospital'),
          ),
        ],
      ),
    );
  }
}