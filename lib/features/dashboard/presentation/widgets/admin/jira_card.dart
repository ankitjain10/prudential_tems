import 'package:flutter/material.dart';
class JiraCard extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> data;

  const JiraCard({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Allows shrink-wrap
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(title, style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Column(
              children:
              data.map((item) {
                return Container(
                  padding: EdgeInsets.all(8),
                  // Adds spacing inside the container
                  margin: EdgeInsets.symmetric(vertical: 4),
                  // Adds spacing between rows
                  decoration: BoxDecoration(
                    color: item['color'], // Background color based on data
                    borderRadius: BorderRadius.circular(
                      4,
                    ), // Rounded corners
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SelectableText(
                        item['label'],
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SelectableText(item['count'], textAlign: TextAlign.center),
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 32,)
          ],
        ),
      ),
    );
  }
}
