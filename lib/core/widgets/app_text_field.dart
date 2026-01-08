import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final bool isRequired;
  final bool showRequiredMark;
  final bool obscure;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final int maxLines;

  const AppTextField({
    super.key,
    required this.label,
    this.isRequired = false,
    this.showRequiredMark = false,
    this.obscure = false,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        label: _buildLabel(context), // ✅ pass context
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context) {
    if (!showRequiredMark) {
      return Text(label);
    }

    final textColor =
        Theme.of(context).inputDecorationTheme.labelStyle?.color ??
            Theme.of(context).textTheme.bodyMedium?.color;

    return RichText(
      text: TextSpan(
        text: label,
        style: TextStyle(color: textColor),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
