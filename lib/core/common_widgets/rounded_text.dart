import 'package:flutter/material.dart';
import 'package:prudential_tems/core/utils/app_utils.dart';

class RoundedTextWidget extends StatelessWidget {
  final String status;

  const RoundedTextWidget({
    Key? key,
    this.status = '', // Default color
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Status statusEnum = StatusUtils.stringToStatus(status);
    return Align(
      alignment: Alignment.center,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: StatusUtils.getStatusColor(status),
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          child: SelectableText(
            status,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
