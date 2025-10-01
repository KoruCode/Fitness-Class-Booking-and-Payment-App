import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>(); // ACTIVITY #4
  final _usernameController = TextEditingController(); // Username input
  final _passwordController = TextEditingController();

  // Validate username (not empty)
  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter username';
    }
    return null;
  }

  // Validate password (not empty)
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    return null;
  }

  // Submit login with fixed credentials check
  void _submitLogin() {
    if (_formKey.currentState!.validate()) {
      if (_usernameController.text == 'john' &&
          _passwordController.text == 'john') {
        Navigator.pushReplacementNamed(context, '/booking');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid username or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey, // ACTIVITY #4
          child: Column(
            children: [
              // ACTIVITY #1: username field
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: _validateUsername,
              ),
              SizedBox(height: 16),
              // ACTIVITY #2: password field
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: _validatePassword,
              ),
              SizedBox(height: 24),
              // Submit button for login
              ElevatedButton(
                onPressed: _submitLogin,
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
