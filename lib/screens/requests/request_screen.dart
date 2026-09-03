import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../models/academic_resource_model.dart';
import '../../models/request_model.dart';
import '../../models/user_model.dart';
import '../../providers/app_state_provider.dart';
import '../../repositories/request_repository.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class RequestScreen extends StatefulWidget {
  final AcademicResourceModel? resource;

  const RequestScreen({
    super.key,
    this.resource,
  });

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _itemNameController;
  final _messageController = TextEditingController();

  String _selectedType = AppConstants.typeBuy;
  DateTime _requiredDate = DateTime.now().add(const Duration(days: 3));
  bool _isSubmitting = false;

  final RequestRepository _requestRepository = RequestRepository();

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController(
      text: widget.resource?.title ?? '',
    );
    if (widget.resource != null) {
      _selectedType = widget.resource!.resourceType;
    }
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _requiredDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 120)),
    );
    if (picked != null && picked != _requiredDate) {
      setState(() => _requiredDate = picked);
    }
  }

  void _onSubmitRequest() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);

      final user = AppStateProvider.of(context).authProvider.user ?? UserModel.mockUser;

      final newRequest = RequestModel(
        id: 'req_${DateTime.now().millisecondsSinceEpoch}',
        resourceId: widget.resource?.id,
        resourceTitle: _itemNameController.text.trim(),
        transactionType: _selectedType,
        requiredDate: _requiredDate,
        optionalMessage: _messageController.text.trim().isNotEmpty ? _messageController.text.trim() : null,
        requesterId: user.id,
        requesterName: user.name,
        createdAt: DateTime.now(),
      );

      await _requestRepository.createRequest(newRequest);
      setState(() => _isSubmitting = false);

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
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
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 40),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Campus Request Broadcasted!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your request for "${newRequest.resourceTitle}" is now visible to enrolled students on your campus.',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Navigate back
                    },
                    child: const Text('Back to Marketplace'),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Academic Resource'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Request Academic Item',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Cannot find what you need? Post a request for campus students to fulfill.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // 1. Item Name
              CustomTextField(
                controller: _itemNameController,
                label: 'Item Name',
                hint: 'e.g. TI-84 Plus CE Calculator or Chem 31 Lab Coat',
                prefixIcon: Icons.menu_book_rounded,
                validator: (v) => v == null || v.trim().isEmpty ? 'Please enter item name' : null,
              ),
              const SizedBox(height: 16),

              // 2. Preferred Transaction Type
              Text(
                'Preferred Transaction Type',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                showSelectedIcon: false,
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                segments: const [
                  ButtonSegment(
                    value: 'BUY',
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Buy', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  ButtonSegment(
                    value: 'BORROW',
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Borrow', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  ButtonSegment(
                    value: 'EXCHANGE',
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Exchange', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                  ButtonSegment(
                    value: 'DONATE',
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Donate', style: TextStyle(fontSize: 12)),
                    ),
                  ),
                ],
                selected: {_selectedType},
                onSelectionChanged: (set) {
                  setState(() => _selectedType = set.first);
                },
              ),
              const SizedBox(height: 20),

              // 3. Required Date Picker
              Text(
                'Required By Date',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              InkWell(
                onTap: () => _selectDate(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 20, color: theme.colorScheme.primary),
                      const SizedBox(width: 12),
                      Text(
                        '${_requiredDate.month}/${_requiredDate.day}/${_requiredDate.year}',
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                      const Spacer(),
                      const Icon(Icons.arrow_drop_down_rounded),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 4. Optional Message
              CustomTextField(
                controller: _messageController,
                label: 'Optional Note / Details',
                hint: 'Specify course code, exam dates, or budget limits...',
                maxLines: 4,
              ),
              const SizedBox(height: 28),

              CustomButton(
                text: 'Broadcast Campus Request',
                onPressed: _onSubmitRequest,
                isLoading: _isSubmitting,
                icon: Icons.send_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
