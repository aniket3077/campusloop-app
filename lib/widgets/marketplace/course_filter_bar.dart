import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/navigation/app_routes.dart';

class CourseFilterBar extends StatelessWidget {
  final String selectedCourse;
  final ValueChanged<String> onCourseSelected;

  const CourseFilterBar({
    super.key,
    required this.selectedCourse,
    required this.onCourseSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      size: 16,
                      color: Color(0xFF4F46E5),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Find by Course',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, AppRoutes.digitalMarketplace);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Course Hub',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4F46E5),
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: Color(0xFF4F46E5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),

        // Horizontal List of Course Chips
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            itemCount: AppConstants.courses.length,
            itemBuilder: (context, index) {
              final course = AppConstants.courses[index];
              final isSelected = selectedCourse == course;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: InkWell(
                  onTap: () => onCourseSelected(isSelected ? 'All Courses' : course),
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF4F46E5) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? const Color(0xFF4F46E5) : const Color(0xFFE2E8F0),
                        width: isSelected ? 1.5 : 1.0,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF4F46E5).withValues(alpha: 0.28),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (course == 'All Courses')
                          Icon(
                            Icons.auto_awesome_rounded,
                            size: 14,
                            color: isSelected ? Colors.white : const Color(0xFF64748B),
                          )
                        else
                          Icon(
                            Icons.menu_book_rounded,
                            size: 13,
                            color: isSelected ? Colors.white : const Color(0xFF4F46E5),
                          ),
                        const SizedBox(width: 5),
                        Text(
                          course,
                          style: TextStyle(
                            color: isSelected ? Colors.white : const Color(0xFF334155),
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
