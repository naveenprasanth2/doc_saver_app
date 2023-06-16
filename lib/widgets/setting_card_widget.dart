import 'package:flutter/material.dart';

class SettingsCardWidget extends StatelessWidget {
  final String title;
  final IconData leadingIcon;
  final Widget? trailing;

  const SettingsCardWidget(
      {super.key,
      required this.title,
      required this.leadingIcon,
      this.trailing});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade200, blurRadius: 4, spreadRadius: 4),
          ]),
      child: ListTile(
        title: Text(title),
        leading: Icon(leadingIcon),
        trailing: trailing,
      ),
    );
  }
}
