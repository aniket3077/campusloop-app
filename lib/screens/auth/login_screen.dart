import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/utils/validators.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../providers/app_state_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String _selectedUniversity = 'Stanford University';

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _onContinue() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = AppStateProvider.of(context).authProvider;
      final success = await authProvider.verifyAndLogin(
        _emailController.text,
        _selectedUniversity,
      );
      if (success && mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.mainShell);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = AppStateProvider.of(context).authProvider;

    return Scaffold(
      appBar: AppBar(title: const Text('Verified Student Access')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.shield_outlined, color: theme.colorScheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'CampusLoop requires a verified college email (.edu) to maintain a trusted student community.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Text(
                'Select University',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedUniversity,
                decoration: const InputDecoration(),
                items: const [
                  DropdownMenuItem(value: 'Stanford University', child: Text('Stanford University')),
                  DropdownMenuItem(value: 'MIT', child: Text('MIT')),
                  DropdownMenuItem(value: 'UC Berkeley', child: Text('UC Berkeley')),
                  DropdownMenuItem(value: 'Harvard University', child: Text('Harvard University')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedUniversity = val);
                },
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _emailController,
                label: 'Student Email Address',
                hint: 'your.name@university.edu',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateCollegeEmail,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Verify Student Identity',
                onPressed: _onContinue,
                isLoading: authProvider.isLoading,
                icon: Icons.verified_user_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
