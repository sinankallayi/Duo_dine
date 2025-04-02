import 'package:flutter/material.dart';
import 'package:foodly_ui/constants.dart';
import 'package:foodly_ui/data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var profile = restaurant.value;
    return profile == null
        ? const Center(child: Text("Profile screen"))
        : SingleChildScrollView(
            child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (profile.image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      getImageUrl(profile.image!),
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  profile.name,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(profile.address, style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(profile.phone, style: const TextStyle(fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                if (profile.rating != null)
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text('${profile.rating}', style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                const SizedBox(height: 16),
                Text(
                  'Tags: ${profile.tags}',
                  style: const TextStyle(
                      fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Text(
                  profile.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ));
  }
}
