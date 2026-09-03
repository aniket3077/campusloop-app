import 'package:flutter/material.dart';
import '../../core/navigation/app_routes.dart';
import '../../models/academic_resource_model.dart';
import '../common/section_header.dart';
import 'horizontal_resource_card.dart';

class HorizontalResourceSection extends StatelessWidget {
  final String title;
  final IconData? icon;
  final List<AcademicResourceModel> items;
  final VoidCallback? onSeeAll;

  const HorizontalResourceSection({
    super.key,
    required this.title,
    this.icon,
    required this.items,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          icon: icon,
          onActionPressed: onSeeAll,
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 195,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return HorizontalResourceCard(
                resource: item,
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.resourceDetail,
                    arguments: item,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
