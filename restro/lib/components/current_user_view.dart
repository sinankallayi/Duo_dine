import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodly_ui/data.dart';

class CurrentUserView extends StatelessWidget {
  const CurrentUserView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(children: [
        if (user != null)
          const Icon(
            CupertinoIcons.person,
            color: Colors.black,
          ),
        Text(
          user?.name ?? "Guest",
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ]),
    );
  }
}
