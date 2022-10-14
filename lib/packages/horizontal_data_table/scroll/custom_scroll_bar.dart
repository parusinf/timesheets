import 'package:flutter/material.dart';

import 'scroll_bar_style.dart';

class CustomScrollBar extends StatelessWidget {
  final ScrollController controller;
  final ScrollbarStyle? scrollbarStyle;
  final Widget child;
  final ScrollNotificationPredicate notificationPredicate;

  const CustomScrollBar({
    Key? key,
    required this.controller,
    this.scrollbarStyle,
    required this.child,
    this.notificationPredicate = defaultScrollNotificationPredicate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (scrollbarStyle?.thumbColor != null) {
      return RawScrollbar(
        controller: controller,
        thumbVisibility: scrollbarStyle?.isAlwaysShown ?? false,
        thickness: scrollbarStyle?.thickness,
        radius: scrollbarStyle?.radius,
        thumbColor: scrollbarStyle?.thumbColor,
        notificationPredicate: notificationPredicate,
        child: child,
      );
    }

    return Scrollbar(
      controller: controller,
      thumbVisibility: scrollbarStyle?.isAlwaysShown ?? false,
      thickness: scrollbarStyle?.thickness,
      radius: scrollbarStyle?.radius,
      notificationPredicate: notificationPredicate,
      child: child,
    );
  }
}
