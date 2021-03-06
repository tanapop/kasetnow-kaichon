import 'package:flutter/material.dart';
import '../imports.dart';

class Appbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final List<Widget> actions;
  final String titleStr;
  final Color titleColor;
  final bool centerTitle;
  final Widget leading;
  final Color backgroundColor;

  const Appbar({
    Key key,
    this.title,
    this.titleStr,
    this.titleColor,
    this.actions,
    this.centerTitle = true,
    this.leading,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0.0,
      leading: leading,
      centerTitle: centerTitle,
      title: title ??
          Text(
            titleStr ?? '',
            style: const TextStyle(
                fontSize: 22, color: AppStyles.primaryColorTextField),
          ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
