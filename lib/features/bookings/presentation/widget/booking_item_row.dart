import 'package:flutter/material.dart';
import 'package:prudential_tems/core/common_widgets/rounded_text.dart';

import '../../../../core/utils/utils.dart';
import '../../data/models/booking_api_response.dart';

class BookingItemRow extends StatelessWidget{
  final Booking bookingModel;
  const BookingItemRow({super.key, required this.bookingModel });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: SelectableText(
              bookingModel.environmentName ?? '',
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 2,
            child: SelectableText(
              bookingModel.projectName ?? '',
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 2,
            child: SelectableText(
              formatDate(bookingModel.startDate ?? ''),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 2,
            child: SelectableText(
              formatDate(bookingModel.endDate ?? ''),
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: RoundedTextWidget(status: bookingModel.status ?? ''),
            ),
          ),
        ],
      ),
    );
  }


}