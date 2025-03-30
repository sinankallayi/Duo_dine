import 'package:flutter/material.dart';

import '../../functions/auth.dart';

class AccountsView extends StatelessWidget {
  const AccountsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: 1,
        separatorBuilder: (BuildContext context, int index) {
          return Divider();
        },
        itemBuilder: (BuildContext context, int index) {
          return OutlinedButton(
            onPressed: () async {
              logout();
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          );
        },
      ),
    );
  }
}
