import 'package:flutter/material.dart';

// A reusable widget that represents a dropdown with a label and options.
class CustomTableHeader extends StatelessWidget {
  final String title;
  final int flex;
  final VoidCallback onSortAscending;
  final VoidCallback onSortDescending;
  final bool isAction;

  const CustomTableHeader({
    super.key,
    required this.title,
    this.flex = 1,
    required this.onSortAscending,
    required this.onSortDescending,
    this.isAction = false,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      fit: FlexFit.tight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible (
            flex: 1,
            child: SelectableText(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (!isAction)
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Transform.translate(
                  offset: const Offset(0, 4),
                  child: IconButton(
                    onPressed: onSortAscending,
                    icon: const Icon(Icons.arrow_drop_up_sharp, color: Colors.white),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -4),
                  child: IconButton(
                    onPressed: onSortDescending,
                    icon: const Icon(Icons.arrow_drop_down_sharp, color: Colors.white),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
