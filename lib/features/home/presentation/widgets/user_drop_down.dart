import 'package:flutter/material.dart';

import '../../../dashboard/data/model/user.dart';

class UserDropdown extends StatelessWidget {
  final String label;
  final List<UserModel> users;
  final UserModel? selectedUser;
  final Function(UserModel?)? onChanged;

  const UserDropdown({
    Key? key,
    required this.label,
    required this.users,
    this.selectedUser,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<UserModel>(
          value: users.contains(selectedUser) ? selectedUser : null,
          items: users.map((UserModel user) {
            return DropdownMenuItem<UserModel>(
              value: user,
              child: Text(user.userName), // Displaying user name in dropdown
            );
          }).toList(),
          onChanged: onChanged,
          // decoration: InputDecoration(
          //   border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          //   contentPadding: const EdgeInsets.symmetric(
          //     horizontal: 12,
          //     vertical: 8,
          //   ),
          // ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
