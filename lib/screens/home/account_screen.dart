import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  SharedPreferences? sharedPreferences;

  String? username;
  String? userImage;

  @override
  void initState() {
    super.initState();

    getUserData();
  }

  void getUserData() async {
    sharedPreferences = await SharedPreferences.getInstance();

    username = sharedPreferences!.getString('username');
    userImage = sharedPreferences!.getString('userImage');
  }

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
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(userImage ?? ""),
              ),
              title: const Text("View your profile"),
              subtitle: Text(
                username ?? "",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
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
