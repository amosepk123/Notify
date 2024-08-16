import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import '../Notification/FirebaseNotification.dart';
import 'login.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  String? _selectedCountryCode;
  String? _phoneNumber;
  //String? withoutCoutryCodePhoneNumber;


  bool _isLoading = false;
  bool _hasError = false;
  bool _success = false;
  String _errorMessage = "";

  Future<void> createUser(String? token) async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _success = false;
      _errorMessage = "";
    });

    try {
      var response = await http.post(
        Uri.parse("http://node.amoseraja.tech/api/create"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=utf-8',
        },
        body: jsonEncode({
          'name': _nameController.text,
          'phone': _phoneNumber != null ? int.tryParse(_phoneNumber!) : null,
          'emailId': _emailController.text,
          'password': _passwordController.text,
          'token': token,
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          _success = true;
          EasyLoading.showSuccess('Account Created!');
          EasyLoading.dismiss();
        });
      } else {
        setState(() {
          _hasError = true;
          EasyLoading.dismiss();
          _errorMessage = "Failed to create user: ${response.body}";
          EasyLoading.showError('Error in creating Account');
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseController dataController = Get.put(FirebaseController());
    final FirebaseController firebaseController = Get.find();

    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Spacer(),
                const Text(
                  "Signup",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  onChanged: (value){
                    dataController.putName.value=_nameController.toString();
                  },
                  decoration: InputDecoration(
                    labelText: "Name",
                    hintText: "Enter Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                IntlPhoneField(
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    hintText: 'Enter Phone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  initialCountryCode: 'IN',
                  onChanged: (phone) {
                    setState(() {
                      _selectedCountryCode = phone.countryCode;
                      //dataController.withoutCoutryCodePhoneNumber.value=_phoneNumber!;
                      _phoneNumber = phone.completeNumber;
                      //print(dataController.withoutCoutryCodePhoneNumber);
                    });
                  },
                  validator: (value) {
                    if (_phoneNumber == null || _phoneNumber!.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
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
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                _isLoading
                    ? CircularProgressIndicator()
                    : Obx(() {
                  String? token = firebaseController.FCM.value;
                  return ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (token != null) {
                          createUser(token);
                          EasyLoading.showSuccess('Account Created!');
                          EasyLoading.dismiss();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginScreen()),
                          );
                          EasyLoading.dismiss();
                        } else {
                          EasyLoading.showError('Failed to get token');
                        }
                      }
                    },
                    child: const Text("Signup"),
                  );
                }),
                const SizedBox(height: 10),
                if (_success) const Text("User added successfully!"),
                if (_hasError) Text(_errorMessage, style: const TextStyle(color: Colors.red)),
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
        ),
      )
    );
  }

  void goToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}
