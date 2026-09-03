import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/formatters.dart';
import '../../providers/resource_provider.dart';

class FilterBottomSheet extends StatefulWidget {
  final ResourceProvider resourceProvider;

  const FilterBottomSheet({
    super.key,
    required this.resourceProvider,
  });

  static Future<void> show(BuildContext context, ResourceProvider provider) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => FilterBottomSheet(resourceProvider: provider),
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _selectedType;
  late String _selectedCourse;
  late RangeValues _priceRange;
  late String _selectedCondition;
  late String _selectedLocation;
  late bool _availableOnly;

  @override
  void initState() {
    super.initState();
    _selectedType = widget.resourceProvider.selectedType;
    _selectedCourse = widget.resourceProvider.selectedCourse;
    _priceRange = widget.resourceProvider.priceRange;
    _selectedCondition = widget.resourceProvider.selectedCondition;
    _selectedLocation = widget.resourceProvider.selectedLocation;
    _availableOnly = widget.resourceProvider.availableOnly;
  }

  void _applyFilters() {
    widget.resourceProvider.setCourse(_selectedCourse);
    widget.resourceProvider.applyFilterOptions(
      resourceType: _selectedType,
      priceRange: _priceRange,
      condition: _selectedCondition,
      location: _selectedLocation,
      availableOnly: _availableOnly,
    );
    Navigator.pop(context);
  }

  void _resetFilters() {
    setState(() {
      _selectedType = 'All Types';
      _selectedCourse = 'All Courses';
      _priceRange = const RangeValues(0, 150);
      _selectedCondition = 'All';
      _selectedLocation = 'All Locations';
      _availableOnly = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bottom sheet handle & title
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Filter Marketplace',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: _resetFilters,
                    child: const Text('Reset All'),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),

              // Filter 1: Transaction Type
              Text(
                'Transaction Type',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTypeChip('All Types'),
                  _buildTypeChip(AppConstants.typeBuy),
                  _buildTypeChip(AppConstants.typeSell),
                  _buildTypeChip(AppConstants.typeBorrow),
                  _buildTypeChip(AppConstants.typeExchange),
                  _buildTypeChip(AppConstants.typeDonate),
                  _buildTypeChip(AppConstants.typeRequest),
                ],
              ),
              const SizedBox(height: 20),

              // Filter: Academic Course
              Text(
                'Academic Course',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: AppConstants.courses.map((course) {
                  final isSelected = _selectedCourse == course;
                  return ChoiceChip(
                    label: Text(course),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedCourse = selected ? course : 'All Courses');
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Filter 2: Price Range
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price Range',
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${_priceRange.start.round()} - \$${_priceRange.end.round()}',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              RangeSlider(
                values: _priceRange,
                min: 0,
                max: 200,
                divisions: 20,
                labels: RangeLabels(
                  '\$${_priceRange.start.round()}',
                  '\$${_priceRange.end.round()}',
                ),
                onChanged: (values) => setState(() => _priceRange = values),
              ),
              const SizedBox(height: 16),

              // Filter 3: Condition
              Text(
                'Item Condition',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['All', ...AppConstants.itemConditions].map((cond) {
                  final isSelected = _selectedCondition == cond;
                  return ChoiceChip(
                    label: Text(cond),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCondition = cond),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Filter 4: Pickup Location
              Text(
                'Campus Pickup Spot',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _selectedLocation,
                items: ['All Locations', ...AppConstants.campusPickupSpots]
                    .map((loc) => DropdownMenuItem(value: loc, child: Text(loc)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedLocation = val);
                },
              ),
              const SizedBox(height: 16),

              // Filter 5: Availability Toggle
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Available Now Only', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: const Text('Hide items that are currently on loan or reserved'),
                value: _availableOnly,
                onChanged: (val) => setState(() => _availableOnly = val),
              ),
              const SizedBox(height: 20),

              // Apply Button
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _applyFilters,
                  child: const Text('Apply Filters'),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type) {
    final isSelected = _selectedType == type;
    final color = type == 'All Types'
        ? Theme.of(context).colorScheme.primary
        : Formatters.getResourceTypeColor(type);

    return FilterChip(
      label: Text(type),
      selected: isSelected,
      selectedColor: color,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : color,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      onSelected: (_) => setState(() => _selectedType = type),
    );
  }
}
