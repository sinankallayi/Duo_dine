import 'package:flutter/material.dart';

class RefreshButton extends StatelessWidget {
  const RefreshButton({
    super.key,
    required this.onTap,
  });

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        onTap();
      },
      icon: Icon(Icons.refresh),
      label: Text('Refresh'),
      style: ButtonStyle(
        iconColor: WidgetStateProperty.all(Colors.blue),
        foregroundColor: WidgetStateProperty.all(Colors.blue),
      ),
    );
  }
}
