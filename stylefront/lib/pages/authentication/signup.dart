import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../home.dart';
import 'signin.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Controllers for text fields
  final TextEditingController _usernameController = TextEditingController(); // Added controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to sign up with email and password
  Future<void> _signUpWithEmailAndPassword() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match.')),
      );
      return;
    }
    try {
      final UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Update the user's display name with the username
      await userCredential.user!.updateDisplayName(_usernameController.text.trim());

      // Reload the user to ensure the display name is updated
      await userCredential.user!.reload();

      // Navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred. Please try again.';
      if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      } else if (e.code == 'weak-password') {
        message = 'The password is too weak.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  // Method to sign in with Google
  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      // Navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double spacing = 16.0;

    return Scaffold(
      // Background gradient
      body: Container(
        width: double.infinity,
        height: double.infinity, // Ensure the container fills the screen
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1A1A1A), Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: spacing),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Minimize the column's height
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 50), // Adjusted spacing
                // Header
                Text(
                  'Welcome to StyleMe',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing / 2),
                Text(
                  'Create an account to continue',
                  style: TextStyle(
                    color: Color(0xFFB0B0B0),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing * 2),
                // Social Buttons
                _buildSocialButton(
                  label: 'Continue with Google',
                  icon: Icons.login,
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  onPressed: _signInWithGoogle,
                ),
                SizedBox(height: spacing),
                _buildSocialButton(
                  label: 'Continue with Facebook',
                  icon: Icons.facebook,
                  backgroundColor: Color(0xFF1877F2),
                  textColor: Colors.white,
                  onPressed: () {
                    // Placeholder for Facebook sign-in
                  },
                ),
                SizedBox(height: spacing * 2),
                // Divider with OR
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('OR', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider(color: Colors.grey)),
                  ],
                ),
                SizedBox(height: spacing * 2),
                // Username Field
                _buildTextField(
                  controller: _usernameController,
                  labelText: 'Username',
                  prefixIcon: Icons.person,
                ),
                SizedBox(height: spacing),
                // Email Field
                _buildTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  prefixIcon: Icons.email,
                ),
                SizedBox(height: spacing),
                // Password Field
                _buildTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  prefixIcon: Icons.lock,
                  obscureText: true,
                ),
                SizedBox(height: spacing),
                // Confirm Password Field
                _buildTextField(
                  controller: _confirmPasswordController,
                  labelText: 'Confirm Password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                ),
                SizedBox(height: spacing),
                // Sign Up Button
                ElevatedButton(
                  onPressed: _signUpWithEmailAndPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1D9BF0),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child: Text('Sign Up'),
                ),
                SizedBox(height: spacing * 2),
                // Sign In Text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(color: Color(0xFFB0B0B0)),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to Sign In Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInScreen()),
                        );
                      },
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Color(0xFF1D9BF0)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget for social buttons
  Widget _buildSocialButton({
    required String label,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: textColor),
        label: Text(label, style: TextStyle(color: textColor)),
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
      ),
    );
  }

  // Widget for text fields
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Color(0xFFB0B0B0)),
        prefixIcon: Icon(prefixIcon, color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF1D9BF0)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}