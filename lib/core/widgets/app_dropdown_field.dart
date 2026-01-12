import 'package:flutter/material.dart';

class AppDropdownField<T> extends StatelessWidget {
  final String label;
  final bool showRequiredMark;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const AppDropdownField({
    super.key,
    required this.label,
    required this.items,
    required this.onChanged,
    this.value,
    this.showRequiredMark = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      decoration: InputDecoration(
        label: _buildLabel(context),
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
