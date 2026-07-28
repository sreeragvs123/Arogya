import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FormSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;

  const FormSection({super.key, required this.title, required this.subtitle, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 4),
      Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
      const SizedBox(height: 28),
      ...children,
    ]);
  }
}
