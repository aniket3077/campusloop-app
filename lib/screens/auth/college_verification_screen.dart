import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../models/user_model.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class CollegeVerificationScreen extends StatefulWidget {
  const CollegeVerificationScreen({super.key});

  @override
  State<CollegeVerificationScreen> createState() => _CollegeVerificationScreenState();
}

class _CollegeVerificationScreenState extends State<CollegeVerificationScreen> {
  final _otpController = TextEditingController(text: '849201');
  final _studentIdNumberController = TextEditingController();

  int _currentStep = 0;
  final String _selectedFileName = 'student_id_card_scan.jpg';
  bool _isFileUploaded = false;

  @override
  void dispose() {
    _otpController.dispose();
    _studentIdNumberController.dispose();
    super.dispose();
  }

  void _verifyOtp() async {
    final authProvider = AppStateProvider.of(context).authProvider;
    final success = await authProvider.verifyCollegeEmailOtp(_otpController.text.trim());
    if (success) {
      setState(() => _currentStep = 1);
    } else if (mounted && authProvider.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.errorMessage!), backgroundColor: Colors.red),
      );
    }
  }

  void _submitIdVerification() async {
    if (_studentIdNumberController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your Student ID Number')),
      );
      return;
    }

    final authProvider = AppStateProvider.of(context).authProvider;
    final success = await authProvider.submitCollegeIdVerification(
      studentIdNumber: _studentIdNumberController.text.trim(),
      documentFileName: _selectedFileName,
    );

    if (success && mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.verificationSuccess);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authProvider = AppStateProvider.of(context).authProvider;
    final user = authProvider.user ?? UserModel.mockUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('College Student Verification'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Security & Privacy Guarantee Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.verifiedBadge.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.verifiedBadge.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lock_outline_rounded, color: AppColors.verifiedBadge),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Privacy Assured: Your verification documents are encrypted and never exposed publicly.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.verifiedBadge,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Step Indicator
            Row(
              children: [
                _buildStepBadge(0, '1. College Email', _currentStep == 0),
                const Expanded(child: Divider(thickness: 1.5, indent: 8, endIndent: 8)),
                _buildStepBadge(1, '2. Student ID', _currentStep == 1),
              ],
            ),
            const SizedBox(height: 28),

            if (_currentStep == 0) ...[
              Text(
                'Step 1: Verify .edu Email',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'We sent a 6-digit verification code to ${user.email}. Enter it below:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: _otpController,
                label: 'Verification Code (OTP)',
                hint: '6-digit code',
                prefixIcon: Icons.pin_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: 'Verify Email Code',
                onPressed: _verifyOtp,
                isLoading: authProvider.isLoading,
                icon: Icons.check_circle_outline_rounded,
              ),
            ] else ...[
              Text(
                'Step 2: Campus ID Card Verification',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                'Provide your Student ID details to confirm enrolment at ${user.university}.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),

              CustomTextField(
                controller: _studentIdNumberController,
                label: 'Student ID Number',
                hint: 'e.g. 06482019',
                prefixIcon: Icons.badge_outlined,
              ),
              const SizedBox(height: 20),

              Text(
                'Upload Student ID Card Photo',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              InkWell(
                onTap: () {
                  setState(() => _isFileUploaded = true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('ID Card scan selected successfully!')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isFileUploaded
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outline,
                      width: _isFileUploaded ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _isFileUploaded ? Icons.task_alt_rounded : Icons.cloud_upload_outlined,
                        size: 40,
                        color: _isFileUploaded
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _isFileUploaded
                            ? 'Selected: $_selectedFileName'
                            : 'Tap to select Student ID Card image/pdf',
                        style: TextStyle(
                          fontWeight: _isFileUploaded ? FontWeight.bold : FontWeight.normal,
                          color: _isFileUploaded
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              CustomButton(
                text: 'Submit Verification',
                onPressed: _submitIdVerification,
                isLoading: authProvider.isLoading,
                icon: Icons.verified_user_rounded,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStepBadge(int stepIndex, String title, bool isActive) {
    final theme = Theme.of(context);
    final isDone = _currentStep > stepIndex;

    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: isDone || isActive
              ? theme.colorScheme.primary
              : theme.colorScheme.surfaceContainerHighest,
          child: isDone
              ? const Icon(Icons.check, size: 16, color: Colors.white)
              : Text(
                  '${stepIndex + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive ? Colors.white : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive || isDone ? FontWeight.bold : FontWeight.normal,
            color: isActive || isDone
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
