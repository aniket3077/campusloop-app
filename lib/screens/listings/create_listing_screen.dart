import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../models/academic_resource_model.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import '../../providers/app_state_provider.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  String _selectedType = AppConstants.typeSell;
  String _selectedCategory = AppConstants.categories[1];
  String _selectedCondition = AppConstants.itemConditions[0];
  String _selectedPickupSpot = AppConstants.campusPickupSpots[0];

  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _onSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isSubmitting = true);

      final resourceProvider = AppStateProvider.of(context).resourceProvider;
      final newResource = AcademicResourceModel(
        id: 'res_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _selectedCategory,
        resourceType: _selectedType,
        price: double.tryParse(_priceController.text) ?? 0.0,
        condition: _selectedCondition,
        pickupLocation: _selectedPickupSpot,
        sellerId: 'user_101',
        sellerName: 'Alex Rivera',
        sellerRating: 4.9,
        isVerifiedSeller: true,
        university: 'Stanford University',
        imageUrls: ['https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c'],
        createdAt: DateTime.now(),
      );

      final success = await resourceProvider.addResource(newResource);
      setState(() => _isSubmitting = false);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing posted to campus marketplace!')),
        );
        _titleController.clear();
        _descriptionController.clear();
        _priceController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Academic Resource'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resource Type',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'SELL', label: Text('Sell')),
                  ButtonSegment(value: 'BORROW', label: Text('Borrow')),
                  ButtonSegment(value: 'EXCHANGE', label: Text('Exchange')),
                  ButtonSegment(value: 'DONATE', label: Text('Donate')),
                ],
                selected: {_selectedType},
                onSelectionChanged: (set) {
                  setState(() => _selectedType = set.first);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _titleController,
                label: 'Item Title',
                hint: 'e.g. Organic Chemistry Textbook & Notes',
                validator: (v) => v == null || v.isEmpty ? 'Title required' : null,
              ),
              const SizedBox(height: 16),
              Text(
                'Category',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: AppConstants.categories
                    .where((c) => c != 'All Categories')
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCategory = val);
                },
              ),
              const SizedBox(height: 16),
              if (_selectedType != 'DONATE' && _selectedType != 'EXCHANGE') ...[
                CustomTextField(
                  controller: _priceController,
                  label: _selectedType == 'BORROW' ? 'Borrow Fee (\$)' : 'Price (\$)',
                  hint: '0.00',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
              ],
              Text(
                'Campus Pickup Location',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedPickupSpot,
                items: AppConstants.campusPickupSpots
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedPickupSpot = val);
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: 'Description',
                hint: 'Condition, course details, syllabus match, notes highlights...',
                maxLines: 4,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Publish Resource',
                onPressed: _onSubmit,
                isLoading: _isSubmitting,
                icon: Icons.publish_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
