import 'package:flutter/material.dart';

class ImagePickerWidget extends StatelessWidget {
  final List<String> images;
  final ValueChanged<List<String>> onImagesChanged;

  const ImagePickerWidget({
    super.key,
    required this.images,
    required this.onImagesChanged,
  });

  void _addImage() {
    final sampleImages = [
      'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c',
      'https://images.unsplash.com/photo-1594980596870-8aa52a78d8cd',
      'https://images.unsplash.com/photo-1513542789411-b6a5d4f31634',
      'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b',
    ];
    final nextImage = sampleImages[images.length % sampleImages.length];
    final updated = List<String>.from(images)..add(nextImage);
    onImagesChanged(updated);
  }

  void _removeImage(int index) {
    final updated = List<String>.from(images)..removeAt(index);
    onImagesChanged(updated);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Resource Photos',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'At least 1 photo recommended',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: images.length + 1,
            itemBuilder: (context, index) {
              if (index == images.length) {
                return InkWell(
                  onTap: _addImage,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          color: theme.colorScheme.primary,
                          size: 28,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Add Photo',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Stack(
                children: [
                  Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.image_rounded,
                        size: 36,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 16,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
