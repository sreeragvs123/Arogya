import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';

class CreateAccountForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;

  const CreateAccountForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Create Your Account',
            style: TextStyle(fontFamily: 'Georgia', fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        const Text('Register with your clinical credentials to get started.',
            style: AppTextStyles.pageSubtitle),
        const SizedBox(height: 28),

        const Text('Full Name', style: AppTextStyles.label),
        const SizedBox(height: 8),
        TextField(controller: nameController, decoration: const InputDecoration(hintText: 'Dr. Jane Smith')),
        const SizedBox(height: 18),

        const Text('Work Email', style: AppTextStyles.label),
        const SizedBox(height: 8),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'dr.smith@hospital.com'),
        ),
        const SizedBox(height: 18),

        const Text('Password', style: AppTextStyles.label),
        const SizedBox(height: 8),
        TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(hintText: '••••••••')),
        const SizedBox(height: 22),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            // TODO: validate + dispatch registration event
            onPressed: onSubmit,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Create Account', style: AppTextStyles.buttonLabel),
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
