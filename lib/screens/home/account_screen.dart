import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Text(
              "Account",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ListTile(
              onTap: () {},
              leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/user_image.jpg'),
              ),
              title: const Text("View your profile"),
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Profile settings"),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {},
            title: const Text("ID verification"),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {},
            title: const Text("Notifications"),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {},
            title: const Text("Help"),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const SizedBox(height: 20),
          ListTile(
            onTap: () {},
            title: const Text("Passenger payments"),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {},
            title: const Text("Driver payouts"),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const SizedBox(height: 20),
          ListTile(
            onTap: () {},
            title: const Text("Student discount"),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {},
            title: const Text("Refer a friend"),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {},
            title: const Text("Share your story"),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {},
            title: const Text("Free promo items"),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {},
            title: const Text("Spotify playlists"),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {},
            title: const Text("Profile settings"),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const SizedBox(height: 20),
          ListTile(
            onTap: () {},
            title: const Text("Follow us on Instagram"),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {},
            title: const Text("Follow us on TikTok"),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const SizedBox(height: 20),
          ListTile(
            onTap: () {},
            title: const Text("About Top"),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {},
            title: const Text("Our impact"),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {},
            title: const Text("Terms of service"),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const SizedBox(height: 20),
          ListTile(
            onTap: () {},
            title: const Text("Log out"),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            onTap: () {},
            title: const Text("Close your account"),
            trailing: const Icon(Icons.chevron_right_rounded),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
