import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/app_provider.dart';
import '../../../../test_data.dart';
import '../../../dashboard/data/model/user.dart';

class TopBarWidget extends ConsumerStatefulWidget {
  final VoidCallback onPressed;
  final String title;
  final List<UserModel> userList;

  const TopBarWidget({super.key, required this.onPressed, required this.title,
    required this.userList});

  @override
  ConsumerState<TopBarWidget> createState() => _TopBarWidgetState();
}

class _TopBarWidgetState extends ConsumerState<TopBarWidget> {
  late UserModel? selectedUser;

  @override
  void initState() {
    super.initState();

    // set default value
    selectedUser = widget.userList.isNotEmpty ?  widget.userList[0] : null;
    // 🔹 Delay setting the user provider to avoid modifying state during widget build
    Future.microtask(() {
      ref.read(userProvider.notifier).state = selectedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: Row(
        children: [
          Image.asset(width: 160, height: 60, 'assets/icons/app_icon.png'),
          SizedBox(width: 20),
          GestureDetector(
            onTap: widget.onPressed,
            child: const Icon(Icons.menu, color: Colors.black),
          ),
          SizedBox(width: 20),
          SelectableText(widget.title, style: TextStyle(color: Colors.black)),
        ],
      ),
      actions: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Icon(Icons.notifications_none, color: Colors.black),
            const SizedBox(width: 16),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                SizedBox(width: 8),
                DropdownButton<UserModel>(
                  value: selectedUser,
                  onChanged: (UserModel? newValue) {
                    // Set user globally
                    ref.read(userProvider.notifier).state = newValue;
                    setState(() {
                      selectedUser = newValue;
                    });
                  },
                  items:
                  widget.userList.map((UserModel user) {
                        return DropdownMenuItem<UserModel>(
                          value: user,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.userName,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                user.userRole,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
            const SizedBox(width: 16),
            const Icon(Icons.settings, color: Colors.black),
            const SizedBox(width: 16),
          ],
        ),
      ],
    );
  }
}
