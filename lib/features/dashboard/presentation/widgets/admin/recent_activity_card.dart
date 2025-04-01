import 'package:flutter/material.dart';
class RecentActivityCard extends StatelessWidget {
  final List<Map<String, dynamic>> activities = [
    {
      'icon': Icons.check_circle,
      'iconColor': Colors.green,
      'title': 'Environment Update',
      'time': '2 minutes ago',
    },
    {
      'icon': Icons.person_add,
      'iconColor': Colors.blue,
      'title': 'New User Added',
      'time': '1 hour ago',
    },
    {
      'icon': Icons.warning,
      'iconColor': Colors.red,
      'title': 'System Alert',
      'time': '3 hours ago',
    },
  ];

  RecentActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              'Recent Activity',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 12),
            Column(
              children:
              activities
                  .map((activity) => _buildActivityTile(activity))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTile(Map<String, dynamic> activity) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(activity['icon'], color: activity['iconColor'], size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  activity['title'],
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 2),
                SelectableText(
                  activity['time'],
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}