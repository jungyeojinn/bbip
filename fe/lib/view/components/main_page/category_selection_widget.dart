import 'package:flutter/material.dart';

class CategorySelectionWidget extends StatefulWidget {
  final String blurMode;
  final Function(String) onBlurModeChanged;

  const CategorySelectionWidget({
    super.key,
    required this.blurMode,
    required this.onBlurModeChanged,
  });

  @override
  State<CategorySelectionWidget> createState() =>
      _CategorySelectionWidgetState();
}

class _CategorySelectionWidgetState extends State<CategorySelectionWidget> {
  String blurMode = '얼굴';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCategory('얼굴', ['assets/face-detection.png'],
            ['assets/face-detection-onclick.png']),
        SizedBox(width: 16),
        _buildCategory(
            '상표/차번호',
            ['assets/license-plate.png', 'assets/brand.png'],
            ['assets/license-plate-onclick.png', 'assets/brand-onclick.png']),
        SizedBox(width: 16),
        _buildCategory(
            '흉기', ['assets/knife.png'], ['assets/knife-onclick.png']),
      ],
    );
  }

  Widget _buildCategory(
      String label, List<String> defaultImages, List<String> selectedImages) {
    final isSelected = blurMode == label;
    final images = isSelected ? selectedImages : defaultImages;

    return GestureDetector(
      onTap: () {
        widget.onBlurModeChanged(label);
        setState(() {
          blurMode = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: images
              .map((imagePath) => Image.asset(
                    imagePath,
                    width: 36,
                    height: 36,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
