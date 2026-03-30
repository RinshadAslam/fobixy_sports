import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void initState() {
    super.initState();
    // Automatically send verification email on screen load
    _sendVerificationEmail();
  }

  Future<void> _sendVerificationEmail() async {
    final user = _authService.currentUser;
    if (user != null && !user.emailVerified) {
      setState(() => _isLoading = true);
      try {
        await user.sendEmailVerification();
        setState(() => _emailSent = true);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error sending verification email: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  Future<void> _checkEmailVerified() async {
    final user = _authService.currentUser;
    if (user != null) {
      await user.reload();
      final updatedUser = _authService.currentUser;

      if (updatedUser != null && updatedUser.emailVerified) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Email verified successfully!')),
          );
          // The StreamBuilder in AuthWrapper will automatically navigate to Dashboard
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email not yet verified. Please check your inbox.'),
            ),
          );
        }
      }
    }
  }

  Future<void> _signOut() async {
    try {
      await _authService.signOut();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error signing out: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.email, size: 80, color: Color(0xFF00FF87)),
              const SizedBox(height: 24),
              const Text(
                'Verify Your Email',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'We sent a verification email to:\n${user?.email ?? 'your email'}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              if (_emailSent)
                const Text(
                  'Verification email sent! Please check your inbox and spam folder.',
                  style: TextStyle(fontSize: 14, color: Color(0xFF00FF87)),
                  textAlign: TextAlign.center,
                ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _checkEmailVerified,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00FF87),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.black,
                            ),
                          ),
                        )
                      : const Text(
                          'I\'ve Verified My Email',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _isLoading ? null : _sendVerificationEmail,
                child: Text(
                  'Resend Verification Email',
                  style: TextStyle(
                    color: _isLoading ? Colors.grey : const Color(0xFF00FF87),
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _signOut,
                child: const Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
