import 'package:flutter/material.dart';
import '../../../models/category_model.dart';

class CategoryItemWidget extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItemWidget({
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: isSelected
                    ? scheme.primary.withOpacity(0.12)
                    : scheme.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? scheme.primary
                      : scheme.outline.withOpacity(0.35),
                  width: 2,
                ),
              ),
              child: Center(
                child: ClipOval(
                  child: Image.asset(
                    category.iconUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.restaurant,
                        color: scheme.onSurface,
                        size: 30,
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 70,
              child: Text(
                category.name,
                style: TextStyle(
                  color: scheme.onSurface,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
