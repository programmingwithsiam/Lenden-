import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../core/constants/app_constants.dart';
import '../models/app_user_model.dart';

/// Handles Google Sign-In + Firebase Authentication and creates/loads
/// the user's profile node in Realtime Database.
class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Signs the user in with Google, creates their profile node in
  /// Realtime Database on first login, and returns the Firebase [User].
  ///
  /// Throws a user-friendly [AuthException] on failure/cancellation.
  Future<User> signInWithGoogle() async {
    try {
      User? user;

      if (kIsWeb) {
        // Chrome/Web: use Firebase's native Google popup.
        final provider = GoogleAuthProvider()
          ..addScope('email')
          ..addScope('profile');

        final userCredential = await _auth.signInWithPopup(provider);
        user = userCredential.user;
      } else {
        // Android/iOS: use the native Google Sign-In flow.
        final googleUser = await _googleSignIn.signIn();
        if (googleUser == null) {
          throw AuthException('লগইন বাতিল করা হয়েছে');
        }

        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final userCredential = await _auth.signInWithCredential(credential);
        user = userCredential.user;
      }

      if (user == null) {
        throw AuthException('লগইন ব্যর্থ হয়েছে, আবার চেষ্টা করুন');
      }

      await _ensureProfileExists(user);
      return user;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_mapFirebaseError(e));
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Google লগইন ব্যর্থ হয়েছে: $e');
    }
  }

  Future<void> _ensureProfileExists(User user) async {
    final ref = FirebaseDatabase.instance.ref('users/${user.uid}/${AppConstants.dbProfile}');
    try {
      final snapshot = await ref.get();
      if (!snapshot.exists) {
        final profile = AppUserModel(
          uid: user.uid,
          name: user.displayName ?? 'ব্যবহারকারী',
          email: user.email ?? '',
          photoUrl: user.photoURL ?? '',
          createdAt: DateTime.now().millisecondsSinceEpoch,
        );
        await ref.set(profile.toMap());
      }
    } catch (_) {
      // If offline on first-ever login, profile will be created lazily
      // the next time we're online (dashboard provider retries this).
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  bool get isFirstTimeUserSession => _auth.currentUser?.metadata.creationTime ==
      _auth.currentUser?.metadata.lastSignInTime;

  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'network-request-failed':
        return 'ইন্টারনেট সংযোগ নেই, আবার চেষ্টা করুন';
      case 'account-exists-with-different-credential':
        return 'এই ইমেইল দিয়ে অন্য পদ্ধতিতে অ্যাকাউন্ট আছে';
      case 'user-disabled':
        return 'এই অ্যাকাউন্ট নিষ্ক্রিয় করা হয়েছে';
      default:
        return 'লগইন করতে সমস্যা হয়েছে, আবার চেষ্টা করুন';
    }
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
  @override
  String toString() => message;
}
