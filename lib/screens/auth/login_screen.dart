import 'package:flutter/material.dart';
import 'package:gnb_task/screens/photo_list/photo_list_screen.dart';
import 'package:gnb_task/services/fcm_service.dart';
import '../../services/auth_service.dart';
import '../profile/profile_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService authService = AuthService(); // Auth service instance
  final FCMService _fcmService = FCMService(); // FCM service instance
  bool _isLoading = false; // Loading state for UI

  @override
  void initState() {
    _fcmService.setupFCM(); // Setup FCM on init
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.tealAccent], // Background gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0), // Padding for content
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Login to continue',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),
                _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Loading indicator
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black, 
                          backgroundColor: Colors.white, 
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8), // Rounded corners
                          ),
                          elevation: 5, 
                        ),
                        onPressed: _handleLogin, // Login button action
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.g_mobiledata_outlined,
                              size: 40, 
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Login with Google',
                              style: TextStyle(fontSize: 18), // Button text style
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Handle Google login process
  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true; // Set loading state
    });

    final user = await authService.signInWithGoogle(); // Sign in with Google
    if (user != null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const PhotoListScreen(), // Navigate to PhotoListScreen on success
      ));
    } else {
      setState(() {
        _isLoading = false; // Reset loading state on failure
      });
    }
  }
}
