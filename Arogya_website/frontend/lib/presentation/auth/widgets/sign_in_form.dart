import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class SignInForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final VoidCallback onForgotPassword;

  const SignInForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    required this.onForgotPassword,
  });

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool _obscurePassword = true;
  bool _keepLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Welcome Back',
            style: TextStyle(fontFamily: 'Georgia', fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        const Text('Enter your clinical credentials to access your dashboard.',
            style: AppTextStyles.pageSubtitle),
        const SizedBox(height: 28),

        const Text('Work Email', style: AppTextStyles.label),
        const SizedBox(height: 8),
        TextField(
          controller: widget.emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'dr.smith@hospital.com'),
        ),
        const SizedBox(height: 18),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Password', style: AppTextStyles.label),
            GestureDetector(
              onTap: widget.onForgotPassword, // TODO: forgot-password flow
              child: const Text('Forgot?',
                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: '••••••••',
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: AppColors.textMuted,
                size: 20,
              ),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: _keepLoggedIn,
                activeColor: AppColors.primary,
                onChanged: (v) => setState(() => _keepLoggedIn = v ?? false),
              ),
            ),
            const SizedBox(width: 10),
            const Text('Keep me logged in for 30 days', style: AppTextStyles.cardBody),
          ],
        ),
        const SizedBox(height: 22),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            // TODO: validate + dispatch sign-in event to auth bloc/repository
            onPressed: widget.onSubmit,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Access Portal', style: AppTextStyles.buttonLabel),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, size: 18, color: Colors.white),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
