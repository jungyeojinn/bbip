import 'package:flutter/material.dart';

class BlurModeSelectionWidget extends StatefulWidget {
  final String blurMode;
  final Function(String) onBlurModeChanged;

  const BlurModeSelectionWidget({
    super.key,
    required this.blurMode,
    required this.onBlurModeChanged,
  });

  @override
  State<BlurModeSelectionWidget> createState() => _BlurModeSelectionWidgetState();
}

class _BlurModeSelectionWidgetState extends State<BlurModeSelectionWidget> {
  String blurMode = '얼굴';

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCategory('얼굴'),
        SizedBox(width: 16),
        _buildCategory('상표/차번호'),
        SizedBox(width: 16),
        _buildCategory('흉기'),
      ],
    );
  }

  Widget _buildCategory(String label) {
    final isSelected = blurMode == label;

    return GestureDetector(
      onTap: () {
        widget.onBlurModeChanged(label);
        setState(() {
          blurMode = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            color: isSelected ? Colors.blue : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
