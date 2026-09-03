import 'package:flutter/material.dart';
import '../../models/digital_product_model.dart';
import '../../models/user_model.dart';
import '../../providers/app_state_provider.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class CreateDigitalListingScreen extends StatefulWidget {
  const CreateDigitalListingScreen({super.key});

  @override
  State<CreateDigitalListingScreen> createState() => _CreateDigitalListingScreenState();
}

class _CreateDigitalListingScreenState extends State<CreateDigitalListingScreen> {
  final _formKey = GlobalKey<FormState>();

  final _courseNameController = TextEditingController();
  final _expiryController = TextEditingController(text: 'Valid through Dec 31, 2026');
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _accessCodeController = TextEditingController();

  String _selectedProvider = 'Pearson MyLab';
  DigitalProductType _selectedType = DigitalProductType.accessCode;
  bool _confirmedLegitimate = true;
  bool _isSubmitting = false;

  final providers = [
    'Pearson MyLab',
    'McGraw-Hill Connect',
    'WileyPLUS',
    'Canvas / Campus Store',
    'Coursera / EdX',
    'Publisher Store',
    'Other Official Provider',
  ];

  @override
  void dispose() {
    _courseNameController.dispose();
    _expiryController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _accessCodeController.dispose();
    super.dispose();
  }

  void _onPublish() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_confirmedLegitimate) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please confirm legitimate product ownership compliance.')),
        );
        return;
      }

      setState(() => _isSubmitting = true);

      final user = AppStateProvider.of(context).authProvider.user ?? UserModel.mockUser;
      final newProduct = DigitalProductModel(
        id: 'dig_${DateTime.now().millisecondsSinceEpoch}',
        courseName: _courseNameController.text.trim(),
        providerPlatform: _selectedProvider,
        productType: _selectedType,
        validityExpiry: _expiryController.text.trim(),
        price: double.tryParse(_priceController.text) ?? 0.0,
        description: _descriptionController.text.trim(),
        isOwnershipVerified: true,
        sellerId: user.id,
        sellerName: user.name,
        sellerRating: user.trustRating,
        isVerifiedSeller: user.isVerifiedStudent,
        university: user.university,
        createdAt: DateTime.now(),
        secureAccessCode: _accessCodeController.text.trim().isNotEmpty
            ? _accessCodeController.text.trim()
            : 'CAMPUSLOOP-VERIFIED-CODE-8820',
      );

      final provider = AppStateProvider.of(context).digitalProductProvider;
      final success = await provider.addDigitalProduct(newProduct);
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
                  child: const Icon(Icons.check_rounded, color: Colors.white, size: 44),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Digital Course Product Listed!',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your transferable access code/material is now listed. Access codes remain securely encrypted until transaction confirmation.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
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
        title: const Text('List Digital Course Product'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Policy Notice Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.shield_outlined, color: Colors.blue.shade900),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Policy Compliance: Passwords and account credentials are strictly prohibited. Store only transferable codes, vouchers, or study notes.',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Course Name
              CustomTextField(
                controller: _courseNameController,
                label: 'Course Name / Code',
                hint: 'e.g. CS 106B: Programming Abstractions',
                prefixIcon: Icons.menu_book_rounded,
                validator: (v) => v == null || v.trim().isEmpty ? 'Please enter course name' : null,
              ),
              const SizedBox(height: 16),

              // Provider / Platform Dropdown
              Text(
                'Provider / Platform',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedProvider,
                decoration: const InputDecoration(),
                items: providers
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedProvider = val);
                },
              ),
              const SizedBox(height: 16),

              // Product Type Dropdown
              Text(
                'Product Type',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<DigitalProductType>(
                initialValue: _selectedType,
                decoration: const InputDecoration(),
                items: DigitalProductType.values
                    .map((t) => DropdownMenuItem(value: t, child: Text(t.displayName)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedType = val);
                },
              ),
              const SizedBox(height: 16),

              // Validity / Expiry
              CustomTextField(
                controller: _expiryController,
                label: 'Validity / Expiry Date',
                hint: 'e.g. Valid through Dec 31, 2026',
                prefixIcon: Icons.event_available_rounded,
              ),
              const SizedBox(height: 16),

              // Price
              CustomTextField(
                controller: _priceController,
                label: 'Price (\$)',
                hint: 'e.g. 25.00',
                prefixIcon: Icons.attach_money_rounded,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => v == null || v.trim().isEmpty ? 'Please enter price' : null,
              ),
              const SizedBox(height: 16),

              // Secure Access Code (Encrypted delivery field)
              CustomTextField(
                controller: _accessCodeController,
                label: 'Transferable Access Code (Secure & Encrypted)',
                hint: 'e.g. PEARSON-CS106B-84920-X82',
                prefixIcon: Icons.key_rounded,
                obscureText: true,
              ),
              const SizedBox(height: 16),

              // Description
              CustomTextField(
                controller: _descriptionController,
                label: 'Description & Features',
                hint: 'Detail course edition, lab access portal link, or study guide contents...',
                maxLines: 3,
                validator: (v) => v == null || v.trim().isEmpty ? 'Please enter description' : null,
              ),
              const SizedBox(height: 16),

              // Legitimate Compliance Checkbox
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _confirmedLegitimate,
                title: const Text(
                  'Legitimate Ownership Confirmation',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                subtitle: const Text(
                  'I confirm this product is an official, transferable code or material and contains NO personal passwords.',
                  style: TextStyle(fontSize: 11),
                ),
                onChanged: (val) => setState(() => _confirmedLegitimate = val ?? false),
              ),
              const SizedBox(height: 24),

              CustomButton(
                text: 'Publish Legitimate Digital Product',
                onPressed: _onPublish,
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
