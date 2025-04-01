import 'package:flutter/material.dart';
import 'package:prudential_tems/core/theme/app_colors.dart';
import 'package:prudential_tems/features/home/data/models/progress_item_model.dart';

class StatusRow extends StatelessWidget {
  final ProgressItem item;

  const StatusRow({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    // debugPrint('item: ${item.label}::${item.progress}');
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: SelectableText(item.label),
            ),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.loose,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: item.progress,
                backgroundColor: AppColors.borderGrey,
                borderRadius: BorderRadius.circular(8),
                color: item.color,
                minHeight: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SelectableText('${(item.progress * 100).toInt()}%'),
        ],
      ),
    );
  }
}
