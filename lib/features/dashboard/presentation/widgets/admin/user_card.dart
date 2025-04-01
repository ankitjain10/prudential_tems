import 'package:flutter/material.dart';

import '../../../data/model/user.dart';

class UserCard extends StatelessWidget {
  final String title;
  final List<UserModel> data;

  const UserCard({super.key, required this.title, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max, // Allows shrink-wrap
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: SelectableText(title, style: TextStyle(fontWeight: FontWeight.bold))),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
                  child: SelectableText('Add User'),
                ),
              ],
            ),
            SizedBox(height: 8),
            Column(
              children:
              data.map((item) {
                return Container(
                  width: double.infinity,
                  // Ensures the container takes full width
                  padding: EdgeInsets.all(8),
                  // Adds spacing inside the container
                  margin: EdgeInsets.symmetric(vertical: 4),
                  // Spacing between rows
                  decoration: BoxDecoration(
                    color: Colors.grey[300], // Background color
                    borderRadius: BorderRadius.circular(
                      4,
                    ), // Rounded corners
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        item.userName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SelectableText(
                        item.userRole,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}