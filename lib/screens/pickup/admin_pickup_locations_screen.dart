import 'package:flutter/material.dart';
import '../../models/pickup_location_model.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class AdminPickupLocationsScreen extends StatefulWidget {
  const AdminPickupLocationsScreen({super.key});

  @override
  State<AdminPickupLocationsScreen> createState() => _AdminPickupLocationsScreenState();
}

class _AdminPickupLocationsScreenState extends State<AdminPickupLocationsScreen> {
  late List<PickupLocationModel> _locations;

  @override
  void initState() {
    super.initState();
    _locations = List.from(PickupLocationModel.adminConfiguredLocations);
  }

  void _showAddLocationDialog() {
    final nameController = TextEditingController();
    final buildingController = TextEditingController();
    final descController = TextEditingController();
    final hoursController = TextEditingController(text: '8:00 AM - 9:00 PM');
    final safetyController = TextEditingController(text: 'High-foot-traffic area with security cameras.');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Admin Campus Pickup Spot'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(controller: nameController, label: 'Location Name', hint: 'e.g. Main Gate'),
              const SizedBox(height: 12),
              CustomTextField(controller: buildingController, label: 'Building / Area', hint: 'e.g. Campus Entrance'),
              const SizedBox(height: 12),
              CustomTextField(controller: descController, label: 'Meeting Description', hint: 'e.g. Near Security Desk'),
              const SizedBox(height: 12),
              CustomTextField(controller: hoursController, label: 'Operating Hours'),
              const SizedBox(height: 12),
              CustomTextField(controller: safetyController, label: 'Safety Tips'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                final newLoc = PickupLocationModel(
                  id: 'loc_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameController.text.trim(),
                  building: buildingController.text.trim(),
                  description: descController.text.trim(),
                  operatingHours: hoursController.text.trim(),
                  safetyTips: safetyController.text.trim(),
                );
                setState(() => _locations.insert(0, newLoc));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('New campus pickup spot "${newLoc.name}" configured!')),
                );
              }
            },
            child: const Text('Add Location'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Pickup Locations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_location_alt_rounded),
            onPressed: _showAddLocationDialog,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.admin_panel_settings_rounded, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Admin Configured Designated Spots: No physical delivery — all exchanges happen at these verified campus spots.',
                      style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: _locations.length,
                itemBuilder: (context, index) {
                  final loc = _locations[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primary,
                        child: const Icon(Icons.location_on_rounded, color: Colors.white),
                      ),
                      title: Row(
                        children: [
                          Text(loc.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          if (loc.isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text('Default', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('${loc.building} • ${loc.description}', style: const TextStyle(fontSize: 12)),
                          const SizedBox(height: 4),
                          Text('Hours: ${loc.operatingHours}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            CustomButton(
              text: 'Configure New Pickup Location',
              onPressed: _showAddLocationDialog,
              icon: Icons.add_location_rounded,
            ),
          ],
        ),
      ),
    );
  }
}
