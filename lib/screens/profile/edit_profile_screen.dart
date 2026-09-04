import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../models/user_model.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/common/logout_dialog.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _departmentController;

  late String _selectedUniversity;
  late String _selectedAcademicYear;
  String? _selectedAvatarUrl;

  bool _initialized = false;
  bool _isSaving = false;

  final List<String> _demoAvatars = [
    'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=200',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200',
    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=200',
    'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=200',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200',
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final authProvider = AppStateProvider.of(context).authProvider;
      final user = authProvider.user ?? UserModel.mockUser;

      _nameController = TextEditingController(text: user.name);
      _emailController = TextEditingController(text: user.email);
      _departmentController = TextEditingController(text: user.department);

      _selectedUniversity = AppConstants.universities.contains(user.university)
          ? user.university
          : AppConstants.universities.first;

      _selectedAcademicYear = AppConstants.academicYears.contains(user.academicYear)
          ? user.academicYear
          : AppConstants.academicYears[2]; // Junior

      _selectedAvatarUrl = user.avatarUrl ?? _demoAvatars.first;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    if (_initialized) {
      _nameController.dispose();
      _emailController.dispose();
      _departmentController.dispose();
    }
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final authProvider = AppStateProvider.of(context).authProvider;

    final success = await authProvider.updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      university: _selectedUniversity,
      department: _departmentController.text.trim(),
      academicYear: _selectedAcademicYear,
      avatarUrl: _selectedAvatarUrl,
    );

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully! ✨'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Failed to update profile'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student Profile'),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _handleSave,
            child: _isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xFF4F46E5),
                    ),
                  ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Avatar Preview & Picker
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF4F46E5), width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            image: _selectedAvatarUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(_selectedAvatarUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: _selectedAvatarUrl == null
                              ? const Icon(Icons.person, size: 50, color: Colors.grey)
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF4F46E5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Choose Demo Student Avatar',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Demo Avatars Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _demoAvatars.map((url) {
                        final isSelected = _selectedAvatarUrl == url;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedAvatarUrl = url),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? const Color(0xFF4F46E5) : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundImage: NetworkImage(url),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Verification Note Badge
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.verified_user_rounded, color: Color(0xFF059669), size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Verified Student status is preserved. Updates sync across all listings and transactions.',
                        style: TextStyle(
                          color: Color(0xFF065F46),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 2. Full Name
              CustomTextField(
                controller: _nameController,
                label: 'Student Name',
                hint: 'e.g. Aniket Kumar',
                prefixIcon: Icons.person_rounded,
                validator: (v) => v == null || v.trim().isEmpty ? 'Please enter your name' : null,
              ),

              const SizedBox(height: 16),

              // 3. College Email
              CustomTextField(
                controller: _emailController,
                label: 'College Email (.edu)',
                hint: 'aniket@university.edu',
                prefixIcon: Icons.email_rounded,
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v == null || !v.contains('@') ? 'Enter a valid college email' : null,
              ),

              const SizedBox(height: 16),

              // 4. University
              Text(
                'University / College',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedUniversity,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_balance_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: AppConstants.universities
                    .map((u) => DropdownMenuItem(value: u, child: Text(u, overflow: TextOverflow.ellipsis)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedUniversity = val);
                },
              ),

              const SizedBox(height: 16),

              // 5. Department / Major
              CustomTextField(
                controller: _departmentController,
                label: 'Department / Major',
                hint: 'e.g. Computer Science & Engineering',
                prefixIcon: Icons.domain_rounded,
                validator: (v) => v == null || v.trim().isEmpty ? 'Please enter your department' : null,
              ),

              const SizedBox(height: 16),

              // 6. Academic Year
              Text(
                'Academic Year',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedAcademicYear,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.school_rounded),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: AppConstants.academicYears
                    .map((y) => DropdownMenuItem(value: y, child: Text(y)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedAcademicYear = val);
                },
              ),

              const SizedBox(height: 30),

              // 7. Save Changes Button
              CustomButton(
                text: 'Save Changes',
                icon: Icons.check_circle_rounded,
                isLoading: _isSaving,
                onPressed: _handleSave,
              ),

              const SizedBox(height: 24),

              // 8. Account & Session Danger Zone
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.shield_outlined, color: Color(0xFFDC2626), size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Account & Session',
                          style: TextStyle(
                            color: Color(0xFF991B1B),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Log out of your session on this device. You will need to sign in with your college credentials to access your account again.',
                      style: TextStyle(
                        color: Color(0xFF7F1D1D),
                        fontSize: 12,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFFDC2626),
                          side: const BorderSide(color: Color(0xFFDC2626)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => LogoutDialog.show(context),
                        icon: const Icon(Icons.logout_rounded, size: 18),
                        label: const Text(
                          'Log Out of CampusLoop',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
