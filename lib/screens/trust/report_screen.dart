import 'package:flutter/material.dart';
import '../../models/report_model.dart';
import '../../models/user_model.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class ReportScreen extends StatefulWidget {
  final ReportType type;
  final String targetId;
  final String targetTitle;

  const ReportScreen({
    super.key,
    required this.type,
    required this.targetId,
    required this.targetTitle,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _detailsController = TextEditingController();

  String _selectedReason = 'Spam or Misleading Content';
  bool _isSubmitting = false;

  final userReasons = [
    'Spam or Misleading Content',
    'Inappropriate Messages or Harassment',
    'Unresponsive or No-Show for Campus Pickup',
    'Attempting Off-Platform Contact Request',
    'Other Policy Violation',
  ];

  final listingReasons = [
    'Prohibited Item / Account Password',
    'Misleading Description or Fake Image',
    'Inappropriate Price or Counterfeit Item',
    'Duplicate Listing',
    'Other Policy Violation',
  ];

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  void _onSubmitReport() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);

      final user = AppStateProvider.of(context).authProvider.user ?? UserModel.mockUser;
      final newReport = ReportModel(
        id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
        type: widget.type,
        targetId: widget.targetId,
        targetTitle: widget.targetTitle,
        reporterId: user.id,
        reporterName: user.name,
        reason: _selectedReason,
        details: _detailsController.text.trim().isNotEmpty ? _detailsController.text.trim() : null,
        createdAt: DateTime.now(),
      );

      final trustProvider = AppStateProvider.of(context).trustProvider;
      final success = await trustProvider.submitReport(newReport);
      setState(() => _isSubmitting = false);

      if (success && mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF16A34A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.shield_outlined, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Report Submitted',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your report regarding "${widget.targetTitle}" has been forwarded to Campus Moderation. Thank you for maintaining campus safety.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('Return'),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reasonsList = widget.type == ReportType.user ? userReasons : listingReasons;

    return Scaffold(
      appBar: AppBar(
        title: Text('Report ${widget.type == ReportType.user ? "Student" : "Listing"}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.flag_outlined, color: Colors.orange.shade900),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Campus Moderation Notice: All reports are confidentially reviewed by student safety officers.',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.orange.shade900),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Reporting Target:',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                widget.targetTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Select Reason',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedReason,
                decoration: const InputDecoration(),
                items: reasonsList
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedReason = val);
                },
              ),
              const SizedBox(height: 16),

              CustomTextField(
                controller: _detailsController,
                label: 'Additional Details (Optional)',
                hint: 'Provide specifics to assist campus moderators...',
                maxLines: 4,
              ),
              const SizedBox(height: 28),

              CustomButton(
                text: 'Submit Moderation Report',
                onPressed: _onSubmitReport,
                isLoading: _isSubmitting,
                icon: Icons.flag_rounded,
                backgroundColor: Colors.orange.shade900,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
