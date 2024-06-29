
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'auth_service.dart';

import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = AuthService();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
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
              "Signup",
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 50),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: "Name",
                hintText: "Enter Name",
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "Enter Email",
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                hintText: "Enter Password",
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _signup,
              child: const Text("Signup"),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                InkWell(
                  onTap: () => goToLogin(context),
                  child: const Text(
                    "Login",
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

  void goToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // void goToHome(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => const HomeScreen()),
  //   );
  // }

  Future<void> _signup() async {
    try {
      await _auth.createUserWithEmailAndPassword(
         _email.text,
         _password.text,
      );
      Navigator.of(context).pop();
    } catch (e) {
      print(e); // Handle the error appropriately
    }


// if (user != null) {
    //   log("User Created Successfully");
    //   goToHome(context);
    // }
  }
}
