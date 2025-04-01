import 'package:flutter/material.dart';

import '../../../projects/widgets/dropdown_with_offset.dart';


class CustomDropdown extends StatefulWidget {
  final String label;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({
    required this.label,
    required this.options,
    required this.onChanged,
    super.key,
  });

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  String? currentlyOpenDropdown;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: DropdownWithOffset(
        label: widget.label,
        options: widget.options,
        onChanged: (val) {
          setState(() {
            currentlyOpenDropdown = null; // Close dropdown after selection
            widget.onChanged(val);
          });
        },
        onTap: () {
          setState(() {
            if (currentlyOpenDropdown == widget.label) {
              currentlyOpenDropdown = null; // Close if already open
            } else {
              currentlyOpenDropdown = widget.label; // Open new dropdown
            }
          });
        },
        isOpen: currentlyOpenDropdown == widget.label, // Ensure only one stays open
      ),
    );
  }
}
