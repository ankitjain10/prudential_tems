import 'package:flutter/material.dart';

class CustomTableCell extends StatelessWidget {
  final String text;
  final int flex;
  final bool isStatus;
  final bool isAction;
  final GlobalKey? actionKey;
  final GlobalKey? action2Key;
  final VoidCallback? onActionClick;
  final VoidCallback? onAction2Click;
  final Color? color;
  final IconData? actionIcon;
  final IconData? action2Icon;

  const CustomTableCell({
    super.key,
    required this.text,
    this.flex = 1,
    this.isStatus = false,
    this.isAction = false,
    this.actionKey,
    this.action2Key,
    this.color,
    this.actionIcon,
    this.action2Icon,
    this.onActionClick,
    this.onAction2Click,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child:
          isAction
              ? Row(
                children: [
                  GestureDetector(
                    key: actionKey,
                    onTap: onActionClick,
                    child: Icon(actionIcon, size: 24, ),
                  ),
                  SizedBox(width: 12,),
                  GestureDetector(
                    key: action2Key,
                    onTap: onAction2Click,
                    child: Icon(action2Icon, size: 24, ),
                  ),
                ],
              )
              : Container(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                margin: isStatus ? const EdgeInsets.only(right: 20) : null,
                decoration:
                    isStatus
                        ? BoxDecoration(
                          color: color ?? null,
                          borderRadius: BorderRadius.circular(12),
                        )
                        : null,
                child: SelectableText(
                  text,
                  textAlign: isStatus ? TextAlign.center : null,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
              ),
    );
  }
}
