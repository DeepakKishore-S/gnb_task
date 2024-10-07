import 'package:flutter/material.dart';
import '../../model/user/user_model.dart';
import 'package:hive/hive.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

class UserProfileScreen extends StatelessWidget {
  final AuthService authService = AuthService(); // Initialize AuthService

  UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('User Profile'),
      ),
      body: FutureBuilder<UserModel?>(
        future: _getUserFromHive(), // Fetch user data from Hive
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Loading indicator
          } else if (snapshot.hasData && snapshot.data != null) {
            final user = snapshot.data!;
            print("User profile screen ${user.avatarUrl}");
            return Container(
              width: double.maxFinite,
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                      ? CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(user.avatarUrl ?? ""),
                        )
                      : const Icon(
                          Icons.person,
                          size: 50,
                        ),
                  const SizedBox(height: 20),
                  Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      await authService.signOut(); // Sign out the user
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(), // Navigate to login screen
                        ),
                        (route) => true,
                      );
                    },
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No user logged in.')); // No user data found
          }
        },
      ),
    );
  }

  Future<UserModel?> _getUserFromHive() async {
    final box = await Hive.openBox<UserModel>('userBox');
    return box.get('user'); // Retrieve user data from Hive
  }
}
