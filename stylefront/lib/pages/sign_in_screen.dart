import 'package:flutter/material.dart';
import 'home.dart';
class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Controllers for text fields
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  // Spacing constants
  final double _spacing = 16.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background gradient
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF1A1A1A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: _spacing),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: _spacing * 2),
              // Header
              Text(
                'Welcome',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: _spacing / 2),
              Text(
                'Please log in to continue shopping',
                style: TextStyle(
                  color: Color(0xFFB0B0B0),
                  fontSize: 16,
                ),
              ),
              SizedBox(height: _spacing * 2),
              // Social Buttons
              _buildSocialButton(
                label: 'Continue with Google',
                icon: Icons.login, // Replace with Google logo
                backgroundColor: Colors.white,
                textColor: Colors.black,
                onPressed: () {
                  // Handle Google Sign-In
                },
              ),
              SizedBox(height: _spacing),
              _buildSocialButton(
                label: 'Continue with Facebook',
                icon: Icons.facebook,
                backgroundColor: Color(0xFF1877F2),
                textColor: Colors.white,
                onPressed: () {
                  // Handle Facebook Sign-In
                },
              ),
              SizedBox(height: _spacing * 2),
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
              SizedBox(height: _spacing * 2),
              // Email Field
              _buildTextField(
                controller: _emailController,
                labelText: 'Email',
                prefixIcon: Icons.email,
              ),
              SizedBox(height: _spacing),
              // Password Field
              _buildTextField(
                controller: _passwordController,
                labelText: 'Password',
                prefixIcon: Icons.lock,
                obscureText: true,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Handle Forgot Password
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Color(0xFF1D9BF0)),
                  ),
                ),
              ),
              SizedBox(height: _spacing),
              // Sign In Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Home Screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1D9BF0),
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Sign In',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: _spacing),
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Color(0xFFB0B0B0)),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to Sign-Up Screen
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Color(0xFF1D9BF0)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: _spacing),
            ],
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
        label: Text(
          label,
          style: TextStyle(color: textColor),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
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