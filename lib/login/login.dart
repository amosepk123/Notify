import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../BottomNavigation.dart';
import '../provider/Name provider.dart';
import 'Phone_Number.dart';
import 'auth_service.dart';
import 'signup.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  final _name = TextEditingController();
  final _password = TextEditingController();
  final phoneController = TextEditingController();

  bool _isLoading = false;
  bool _hasError = false;
  bool _success = false;
  String _errorMessage = "";
  bool _obscurePassword = true;

  Future<void> LoginUser() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _success = false;
      _errorMessage = "";
    });

    try {
      var response = await http.post(Uri.parse("http://node.amoseraja.tech/api/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({
          'name': _name.text,
          'password': _password.text,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          EasyLoading.showSuccess('Great Success!');
          Navigator.push(context, MaterialPageRoute(builder: (context) => bot()));
          EasyLoading.dismiss();
          _success = true;
        });
      } else {
        setState(() {
          _hasError = true;
          _errorMessage = "Failed to login: ${response.body}";
          EasyLoading.showError('Error in login');
          EasyLoading.dismiss();
        });
      }
    } catch (e) {
      setState(() {
        _hasError = true;
        _errorMessage = "An error occurred: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const Spacer(),
            const Text(
              "Login",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 50),
            TextFormField(
              controller: _name,
              decoration: InputDecoration(
                labelText: "Name",
                hintText: "Enter Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _password,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: "Password",
                hintText: "Enter Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 30),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () {
                LoginUser();
                EasyLoading.show();
              },
              child: const Text("Login"),
            ),
            const SizedBox(height: 20),
            if (_success) const Text("User logged in successfully!"),
            if (_hasError)
              Text(
                _errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 5),
            ElevatedButton(
              onPressed: () async {
                await _auth.loginWithGoogle();
                EasyLoading.show();
                EasyLoading.showSuccess('Success!');
                EasyLoading.dismiss();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => bot()),
                );
              },
              child: const Text("Sign in with Google"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PhoneNumber()),
                );
              },
              child: const Text("Login by OTP"),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? "),
                InkWell(
                  onTap: () => goToSignup(context),
                  child: const Text(
                    "Signup",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  void goToSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  }
}
