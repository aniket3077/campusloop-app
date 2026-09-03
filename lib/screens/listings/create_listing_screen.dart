import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/app_routes.dart';
import '../../models/academic_resource_model.dart';
import '../../models/user_model.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../widgets/listings/image_picker_widget.dart';
import '../../widgets/listings/listing_preview_dialog.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _courseCodeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  String _selectedType = AppConstants.typeSell;
  String _selectedCategory = 'Books';
  String _selectedCondition = AppConstants.itemConditions[0];
  String _selectedPickupSpot = AppConstants.campusPickupSpots[0];
  bool _isAvailable = true;

  List<String> _images = [
    'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c',
  ];

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _courseCodeController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  AcademicResourceModel _buildResourceFromForm(UserModel user) {
    final priceVal = double.tryParse(_priceController.text) ?? 0.0;
    final isFreeMode = _selectedType == AppConstants.typeDonate || _selectedType == AppConstants.typeExchange;

    return AcademicResourceModel(
      id: 'res_${DateTime.now().millisecondsSinceEpoch}',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory,
      resourceType: _selectedType,
      price: isFreeMode ? 0.0 : priceVal,
      condition: _selectedCondition,
      pickupLocation: _selectedPickupSpot,
      sellerId: user.id,
      sellerName: user.name,
      sellerRating: user.trustRating,
      isVerifiedSeller: user.isVerifiedStudent,
      university: user.university,
      imageUrls: _images.isNotEmpty ? _images : ['https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c'],
      createdAt: DateTime.now(),
      isAvailable: _isAvailable,
      courseCode: _courseCodeController.text.trim().isNotEmpty
          ? _courseCodeController.text.trim().toUpperCase()
          : null,
    );
  }

  void _onPreview() {
    if (_formKey.currentState?.validate() ?? false) {
      final user = AppStateProvider.of(context).authProvider.user ?? UserModel.mockUser;
      final resource = _buildResourceFromForm(user);
      ListingPreviewDialog.show(context, resource, _onPublish);
    }
  }

  void _onPublish() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);

      final appState = AppStateProvider.of(context);
      final user = appState.authProvider.user ?? UserModel.mockUser;
      final newResource = _buildResourceFromForm(user);

      final success = await appState.resourceProvider.addResource(newResource);
      setState(() => _isSubmitting = false);

      if (success && mounted) {
        _showSuccessDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
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
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 16),
              const Text(
                'Listing Published!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your academic resource is now visible to verified students on your campus.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    _titleController.clear();
                    _descriptionController.clear();
                    _priceController.clear();
                    Navigator.pushNamed(context, AppRoutes.mainShell);
                  },
                  child: const Text('View Marketplace'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final categoriesList = AppConstants.categories.where((c) => c != 'All').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Resource Listing'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Transaction Type Selector
              Text(
                'Transaction Mode',
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
                    value: 'SELL',
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text('Sell', style: TextStyle(fontSize: 12)),
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

              // 2. Item Name
              CustomTextField(
                controller: _titleController,
                label: 'Item Name',
                hint: 'e.g. Organic Chemistry 6th Ed Textbook',
                prefixIcon: Icons.title_rounded,
                validator: (v) => v == null || v.trim().isEmpty ? 'Please enter item name' : null,
              ),
              const SizedBox(height: 16),

              // 2.1 Course Code (Optional)
              CustomTextField(
                controller: _courseCodeController,
                label: 'Course / Course Code (Optional)',
                hint: 'e.g. ME 101, CS 106B, MATH 51, CHEM 31A',
                prefixIcon: Icons.school_rounded,
              ),
              const SizedBox(height: 16),

              // 3. Category Selector
              Text(
                'Category',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(),
                items: categoriesList
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: 16),

              // 4. Item Condition
              Text(
                'Condition',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedCondition,
                decoration: const InputDecoration(),
                items: AppConstants.itemConditions
                    .map((cond) => DropdownMenuItem(value: cond, child: Text(cond)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCondition = val);
                },
              ),
              const SizedBox(height: 16),

              // 5. Price (Required for Sell / Borrow)
              if (_selectedType == 'SELL' || _selectedType == 'BORROW') ...[
                CustomTextField(
                  controller: _priceController,
                  label: _selectedType == 'BORROW' ? 'Borrow Fee (\$)' : 'Listing Price (\$)',
                  hint: 'e.g. 25.00',
                  prefixIcon: Icons.attach_money_rounded,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Price is required for ${_selectedType.toLowerCase()}ing';
                    }
                    if (double.tryParse(v) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
              ],

              // 6. Campus Pickup Location
              Text(
                'Campus Pickup Location',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedPickupSpot,
                decoration: const InputDecoration(),
                items: AppConstants.campusPickupSpots
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedPickupSpot = val);
                },
              ),
              const SizedBox(height: 16),

              // 7. Description
              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Describe condition, syllabus/course match, included notes...',
                maxLines: 4,
                validator: (v) => v == null || v.trim().isEmpty ? 'Please enter description' : null,
              ),
              const SizedBox(height: 20),

              // 8. Image Picker Widget
              ImagePickerWidget(
                images: _images,
                onImagesChanged: (list) => setState(() => _images = list),
              ),
              const SizedBox(height: 16),

              // 9. Availability Toggle
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Available Immediately', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Item is ready for instant on-campus pickup'),
                value: _isAvailable,
                onChanged: (val) => setState(() => _isAvailable = val),
              ),
              const SizedBox(height: 28),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Preview',
                      onPressed: _onPreview,
                      isOutlined: true,
                      icon: Icons.remove_red_eye_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      text: 'Publish Listing',
                      onPressed: _onPublish,
                      isLoading: _isSubmitting,
                      icon: Icons.publish_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
