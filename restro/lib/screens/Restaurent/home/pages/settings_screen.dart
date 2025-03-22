import 'package:flutter/material.dart';
import 'package:foodly_ui/constants.dart';
import 'package:get/get.dart';
import 'package:restart_app/restart_app.dart';

class SettingsScreen extends GetView {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.switch_left),
            title: const Text('Switch to Customer'),
            onTap: () async {
              await localStorage.write('isCustomer', true);
              // restart application
              Restart.restartApp();
            },
          ),
          const ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notifications'),
          ),
          const ListTile(
            leading: Icon(Icons.lock),
            title: Text('Privacy'),
          ),
          const ListTile(
            leading: Icon(Icons.help),
            title: Text('Help'),
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
          ),
        ],
      ),
    );
  }
}
