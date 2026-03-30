import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Check if user is signed in
  bool get isSignedIn => _auth.currentUser != null;

  // Check if current user has verified email
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Stream of user changes (more detailed than authStateChanges)
  Stream<User?> get userChanges => _auth.userChanges();

  // Sign up with email and password
  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      // Create Firebase Auth account
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      try {
        // Store additional user data in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'userId': userCredential.user!.uid,
          'name': name,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
          'favoriteTeams': [], // Initialize as empty array
          'profileImage': null, // Initialize as null
          'isEmailVerified': false, // Track email verification status
        });

        // Send email verification
        await userCredential.user!.sendEmailVerification();

        return userCredential;
      } catch (firestoreError) {
        // If Firestore write fails, we should consider deleting the auth account
        // to prevent orphaned accounts, but for now we'll just rethrow
        debugPrint('Firestore error during signup: $firestoreError');
        throw FirebaseException(
          plugin: 'cloud_firestore',
          message: 'Failed to save user profile. Please try again.',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  // Sign in with email and password
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // Reload current user (useful for checking email verification status)
  Future<void> reloadUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.reload();
    }
  }

  // Check if user needs email verification
  bool needsEmailVerification() {
    final user = _auth.currentUser;
    return user != null && !user.emailVerified;
  }

  // Get user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();
      return doc.data() as Map<String, dynamic>?;
    } catch (e) {
      return null;
    }
  }

  // Update user data in Firestore
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(uid).update(data);
    } catch (e) {
      rethrow;
    }
  }

  // Add favorite team to user profile
  Future<void> addFavoriteTeam(String uid, String teamName) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'favoriteTeams': FieldValue.arrayUnion([teamName]),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Remove favorite team from user profile
  Future<void> removeFavoriteTeam(String uid, String teamName) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'favoriteTeams': FieldValue.arrayRemove([teamName]),
      });
    } catch (e) {
      rethrow;
    }
  }

  // Update user profile image
  Future<void> updateProfileImage(String uid, String imageUrl) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'profileImage': imageUrl,
      });
    } catch (e) {
      rethrow;
    }
  }
}
