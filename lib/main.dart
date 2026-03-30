import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'dashboard.dart';
import 'screens/login_screen.dart';
import 'screens/email_verification_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Only load .env on non-web platforms (mobile, desktop, linux, windows, macos)
  if (!kIsWeb) {
    try {
      await dotenv.load(fileName: ".env");
    } catch (e) {
      debugPrint('Could not load .env file: $e');
    }
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fobixy Sports',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        primaryColor: const Color(0xFF00FF87),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00FF87),
          secondary: Color(0xFF00FF87),
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthService _authService = AuthService();
  bool _isInitializing = true;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    // Check if user is already signed in
    _currentUser = _authService.currentUser;

    // If user exists, reload to get latest data (including email verification status)
    if (_currentUser != null) {
      try {
        await _authService.reloadUser();
        _currentUser = _authService.currentUser; // Get updated user data
      } catch (e) {
        debugPrint('Error reloading user: $e');
      }
    }

    // Small delay to ensure smooth transition and prevent flashing
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading screen during initialization
    if (_isInitializing) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D0D0D),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF00FF87)),
              SizedBox(height: 20),
              Text(
                'Fobixy Sports',
                style: TextStyle(
                  color: Color(0xFF00FF87),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text('Loading...', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    // Use StreamBuilder for real-time auth state changes
    return StreamBuilder<User?>(
      stream: _authService.userChanges, // More detailed than authStateChanges
      initialData: _currentUser,
      builder: (context, snapshot) {
        // Handle different connection states
        if (snapshot.connectionState == ConnectionState.waiting &&
            _currentUser == null) {
          return const Scaffold(
            backgroundColor: Color(0xFF0D0D0D),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF00FF87)),
            ),
          );
        }

        // Check for authentication state
        final user = snapshot.data;

        if (user != null) {
          // User is signed in
          if (user.emailVerified) {
            // Email is verified, show main app
            return const Dashboard();
          } else {
            // Email not verified, show verification screen
            return const EmailVerificationScreen();
          }
        } else {
          // User is not signed in, show login
          return const LoginScreen();
        }
      },
    );
  }
}
