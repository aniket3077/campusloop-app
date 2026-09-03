import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/utils/validators.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedUniversity = AppConstants.universities[0];
  String _selectedDepartment = AppConstants.departments[0];
  String _selectedAcademicYear = AppConstants.academicYears[2];

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final authProvider = AppStateProvider.of(context).authProvider;
      final success = await authProvider.register(
        fullName: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        university: _selectedUniversity,
        department: _selectedDepartment,
        academicYear: _selectedAcademicYear,
        password: _passwordController.text.trim(),
      );

      if (success && mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.collegeVerification);
      } else if (mounted && authProvider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = AppStateProvider.of(context).authProvider;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Student Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Join Your Campus Community',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Enter your official college details to register.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // Full Name
              CustomTextField(
                controller: _fullNameController,
                label: 'Full Name',
                hint: 'e.g. Alex Rivera',
                prefixIcon: Icons.person_outline_rounded,
                validator: (v) => Validators.validateRequired(v, 'full name'),
              ),
              const SizedBox(height: 16),

              // College Email
              CustomTextField(
                controller: _emailController,
                label: 'College Email (.edu)',
                hint: 'student@university.edu',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: Validators.validateCollegeEmail,
              ),
              const SizedBox(height: 16),

              // University / College
              Text(
                'College / University',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedUniversity,
                decoration: const InputDecoration(),
                items: AppConstants.universities
                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedUniversity = val);
                },
              ),
              const SizedBox(height: 16),

              // Department
              Text(
                'Department / Major',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedDepartment,
                decoration: const InputDecoration(),
                items: AppConstants.departments
                    .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedDepartment = val);
                },
              ),
              const SizedBox(height: 16),

              // Academic Year
              Text(
                'Academic Year',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedAcademicYear,
                decoration: const InputDecoration(),
                items: AppConstants.academicYears
                    .map((y) => DropdownMenuItem(value: y, child: Text(y)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedAcademicYear = val);
                },
              ),
              const SizedBox(height: 16),

              // Password
              CustomTextField(
                controller: _passwordController,
                label: 'Password',
                hint: 'At least 8 characters',
                prefixIcon: Icons.lock_outline_rounded,
                obscureText: true,
                validator: (v) {
                  if (v == null || v.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Confirm Password
              CustomTextField(
                controller: _confirmPasswordController,
                label: 'Confirm Password',
                hint: 'Re-enter password',
                prefixIcon: Icons.lock_clock_outlined,
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Please confirm password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),

              CustomButton(
                text: 'Register & Proceed to Verification',
                onPressed: _onRegister,
                isLoading: authProvider.isLoading,
                icon: Icons.arrow_forward_rounded,
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ', style: theme.textTheme.bodyMedium),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
                    },
                    child: Text(
                      'Log In',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
