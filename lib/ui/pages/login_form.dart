// lib/ui/widgets/login_form.dart
import 'package:challenge1_group3/models/user_model.dart';
import 'package:challenge1_group3/provider/board_provider.dart';
import 'package:challenge1_group3/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A reusable login form widget that handles hard-coded authentication
/// for two users and updates the [BoardProvider] with the logged-in user.
class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final u = _usernameController.text.trim();
    final p = _passwordController.text.trim();

    if ((u == 'username1' && p == 'password1') || (u == 'username2' && p == 'password2')) {
      // Persist and notify listeners
      await context.read<UserProvider>().updateUser(UserModel(uid: "uid", fullName: "Zakria khan", email: "contact@zakriakhan.com", profilePic: ""));
      setState(() => _error = null);
    } else {
      setState(() => _error = 'Invalid username or password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              prefixIcon: Icon(Icons.person),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(
              labelText: 'Password',
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: const TextStyle(color: Colors.red),
            ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _login,
              child: const Text('Log In'),
            ),
          ),
        ],
      ),
    );
  }
}
