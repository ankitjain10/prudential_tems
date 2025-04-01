import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prudential_tems/features/environments/data/models/environment_api_response.dart';

class EnvironmentCard extends StatelessWidget {
  final String title;
  final String status;
  final Environment item;
  final Color statusColor;

  const EnvironmentCard({
    super.key,
    required this.title,
    required this.status,
    required this.item,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 300, // Ensures the card doesn't stretch infinitely
        minWidth: 280, // Minimum size for better UI
      ),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Prevents infinite height issues
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: SelectableText(title, style: TextStyle(fontWeight: FontWeight.bold))),
                    Chip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0.0,
                      label: SelectableText(status, style: GoogleFonts.roboto( // Use GoogleFonts.roboto explicitly
                        color: Colors.white,
                      ),),
                      backgroundColor: statusColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.link, size: 16, color: Colors.blue),
                  SizedBox(width: 4),
                  SelectableText('${item.projectCount} Linked Projects'),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey),
                  SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'Last Updated: 2h ago',
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              // Row(
              //   children: [
              //     ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: Colors.red,
              //         foregroundColor: Colors.white,
              //         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //       ),
              //       onPressed: () {},
              //       child: SelectableText('Edit'),
              //     ),
              //     SizedBox(width: 10),
              //     ElevatedButton(
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: Colors.grey[700],
              //         foregroundColor: Colors.white,
              //         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //       ),
              //       onPressed: () {},
              //       child: SelectableText('History'),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
