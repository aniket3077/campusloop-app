import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../models/user_model.dart';
import '../../providers/app_state_provider.dart';
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
  final TextEditingController _customUrlController = TextEditingController();

  late String _selectedUniversity;
  late String _selectedAcademicYear;
  String? _selectedAvatarUrl;

  bool _initialized = false;
  bool _isSaving = false;

  static const List<Map<String, String>> _curatedAvatars = [
    {
      'name': 'Tech Student',
      'url': 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=250',
    },
    {
      'name': 'Electrical Eng',
      'url': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=250',
    },
    {
      'name': 'Science & Med',
      'url': 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=250',
    },
    {
      'name': 'Design & Arts',
      'url': 'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=250',
    },
    {
      'name': 'Scholar',
      'url': 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=250',
    },
    {
      'name': 'Eco Leader',
      'url': 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=250',
    },
    {
      'name': 'Senior Graduate',
      'url': 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?w=250',
    },
    {
      'name': 'Researcher',
      'url': 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=250',
    },
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

      _selectedAvatarUrl = user.avatarUrl ?? _curatedAvatars.first['url'];
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
    _customUrlController.dispose();
    super.dispose();
  }

  void _showAvatarBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(modalContext).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 44,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Update Profile Photo',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(modalContext),
                        ),
                      ],
                    ),
                    const Text(
                      'Choose a verified campus avatar, paste an image URL, or reset to initials.',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 18),

                    // 1. Grid of Campus Avatars
                    const Text(
                      'Campus Personas',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _curatedAvatars.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (context, index) {
                        final avatar = _curatedAvatars[index];
                        final url = avatar['url']!;
                        final isSelected = _selectedAvatarUrl == url;

                        return GestureDetector(
                          onTap: () {
                            setState(() => _selectedAvatarUrl = url);
                            setModalState(() {});
                            Navigator.pop(modalContext);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Selected ${avatar['name']} avatar! ✨'),
                                duration: const Duration(seconds: 1),
                                backgroundColor: const Color(0xFF10B981),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected ? const Color(0xFF10B981) : Colors.transparent,
                                        width: 3,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 28,
                                      backgroundImage: NetworkImage(url),
                                    ),
                                  ),
                                  if (isSelected)
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF10B981),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.check, size: 12, color: Colors.white),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                avatar['name']!,
                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),

                    // 2. Custom Photo URL Input
                    const Text(
                      'Or Paste Custom Photo Link',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _customUrlController,
                            decoration: InputDecoration(
                              hintText: 'https://example.com/my-photo.jpg',
                              hintStyle: const TextStyle(fontSize: 12),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              prefixIcon: const Icon(Icons.link_rounded, size: 18),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            final link = _customUrlController.text.trim();
                            if (link.isNotEmpty && (link.startsWith('http://') || link.startsWith('https://'))) {
                              setState(() => _selectedAvatarUrl = link);
                              Navigator.pop(modalContext);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Custom photo link applied! ✨'),
                                  backgroundColor: Color(0xFF10B981),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a valid http/https image URL'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF10B981),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          child: const Text('Apply'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // 3. Reset to Initials Option
                    OutlinedButton.icon(
                      onPressed: () {
                        setState(() => _selectedAvatarUrl = null);
                        Navigator.pop(modalContext);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Avatar reset to default name initials'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.person_outline_rounded, size: 18),
                      label: const Text('Remove Photo & Use Initials'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
          content: Text('Profile & photo updated successfully! ✨'),
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
    final userName = _nameController.text.trim();
    final initials = userName.isNotEmpty ? userName[0].toUpperCase() : 'U';

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
                      color: Color(0xFF10B981),
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
              // 1. Upgraded Interactive Avatar Preview & Picker
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _showAvatarBottomSheet,
                      child: Stack(
                        children: [
                          Container(
                            width: 104,
                            height: 104,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF10B981), Color(0xFF0284C7)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF10B981).withValues(alpha: 0.25),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(3.5),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.colorScheme.primary,
                                image: _selectedAvatarUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(_selectedAvatarUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: _selectedAvatarUrl == null
                                  ? Center(
                                      child: Text(
                                        initials,
                                        style: const TextStyle(
                                          fontSize: 38,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton.icon(
                      onPressed: _showAvatarBottomSheet,
                      icon: const Icon(Icons.edit_outlined, size: 16, color: Color(0xFF10B981)),
                      label: const Text(
                        'Change Profile Photo',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Horizontal Quick-Picks Row
                    SizedBox(
                      height: 52,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: _curatedAvatars.length,
                        itemBuilder: (context, index) {
                          final avatar = _curatedAvatars[index];
                          final url = avatar['url']!;
                          final isSelected = _selectedAvatarUrl == url;

                          return GestureDetector(
                            onTap: () {
                              setState(() => _selectedAvatarUrl = url);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Selected ${avatar['name']}! ✨'),
                                  duration: const Duration(seconds: 1),
                                  backgroundColor: const Color(0xFF10B981),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? const Color(0xFF10B981) : Colors.transparent,
                                  width: 2.5,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 22,
                                backgroundImage: NetworkImage(url),
                              ),
                            ),
                          );
                        },
                      ),
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
                        'Your profile details are verified with your official university credentials.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF065F46),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 2. Full Name
              CustomTextField(
                controller: _nameController,
                label: 'Full Name',
                hint: 'e.g. Aniket Sharma',
                prefixIcon: Icons.person_outline,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. College Email
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Campus Email',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailController,
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      helperText: 'Email is locked to your verified institutional identity.',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 4. University Dropdown
              Text(
                'University / College',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedUniversity,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_balance_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                items: AppConstants.universities.map((u) {
                  return DropdownMenuItem(value: u, child: Text(u, style: const TextStyle(fontSize: 14)));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedUniversity = val);
                },
              ),
              const SizedBox(height: 16),

              // 5. Department
              CustomTextField(
                controller: _departmentController,
                label: 'Department / Major',
                hint: 'e.g. Computer Science & Engineering',
                prefixIcon: Icons.school_outlined,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Department is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 6. Academic Year Dropdown
              Text(
                'Academic Year',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedAcademicYear,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                items: AppConstants.academicYears.map((yr) {
                  return DropdownMenuItem(value: yr, child: Text(yr, style: const TextStyle(fontSize: 14)));
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedAcademicYear = val);
                },
              ),

              const SizedBox(height: 32),

              // Save Changes Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _handleSave,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.check_circle_outline, color: Colors.white),
                  label: Text(
                    _isSaving ? 'Saving Changes...' : 'Save Profile Changes',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Sign Out Option
              Center(
                child: TextButton.icon(
                  onPressed: () => LogoutDialog.show(context),
                  icon: const Icon(Icons.logout_rounded, color: Color(0xFFEF4444), size: 18),
                  label: const Text(
                    'Log Out of Student Account',
                    style: TextStyle(
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
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
