import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../model/user/user_model.dart';

class AuthService {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null; // Return null if sign-in was canceled

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Retrieve FCM token
      final token = await _firebaseMessaging.getToken();
      print("FCM Token: $token");

      // Create user model from Google account info
      final user = UserModel(
        id: googleUser.id,
        name: googleUser.displayName ?? '',
        email: googleUser.email,
        avatarUrl: googleUser.photoUrl ?? '',
      );

      // Store user data in Hive
      final box = await Hive.openBox<UserModel>('userBox');
      await box.put('user', user);

      return user; // Return the created user model
    } catch (e) {
      print(e);
      return null; // Return null in case of an error
    }
  }

  Future<void> signOut() async {
    await googleSignIn.signOut(); // Sign out from Google
    final box = await Hive.openBox<UserModel>('userBox');
    await box.delete('user'); // Delete user data from Hive
  }
}
