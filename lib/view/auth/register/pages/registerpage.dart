// ignore_for_file: prefer_const_constructors, prefer_final_fields, unused_element, prefer_const_literals_to_create_immutables, unused_import

import 'package:flutter/material.dart';
import 'package:myfinance/SQLite/sqlite.dart';
import 'package:myfinance/utils/size_config.dart';
import 'package:myfinance/view/JsonModels/users.dart';
import 'package:myfinance/view/auth/login/pages/loginpage.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final username = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image.asset(
            'assets/bg.png',
            width: displayWidth(context),
            height: displayHeight(context) * 0.32,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 288.0),
            child: Container(
              color: Colors.white,
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                  child: _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Form(
                          key: formKey,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                _buildTextField(
                                  controller: username,
                                  hintText: "Username",
                                  icon: Icons.person,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Username is required";
                                    }
                                    return null;
                                  },
                                ),
                                _buildTextField(
                                  controller: phone,
                                  hintText: "Phone Number",
                                  icon: Icons.phone,
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Phone Number is required";
                                    }
                                    return null;
                                  },
                                ),
                                _buildTextField(
                                  controller: address,
                                  hintText: "Address",
                                  icon: Icons.location_on,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Address is required";
                                    }
                                    return null;
                                  },
                                ),
                                _buildTextField(
                                  controller: password,
                                  hintText: "Password",
                                  icon: Icons.lock,
                                  obscureText: !isVisible,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isVisible = !isVisible;
                                      });
                                    },
                                    icon: Icon(isVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Password is required";
                                    }
                                    return null;
                                  },
                                ),
                                _buildTextField(
                                  controller: confirmPassword,
                                  hintText: "Confirm Password",
                                  icon: Icons.lock,
                                  obscureText: !isVisible,
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isVisible = !isVisible;
                                      });
                                    },
                                    icon: Icon(isVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Password confirmation is required";
                                    } else if (password.text !=
                                        confirmPassword.text) {
                                      return "Passwords don't match";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                _buildButton(
                                  text: "SIGN UP",
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      setState(() {
                                        _isLoading = true;
                                      });

                                      final db = DatabaseHelper();
                                      db
                                          .signup(Users(
                                        usrName: username.text,
                                        usrPassword: password.text,
                                        usrPhone: phone.text,
                                        usrAddress: address.text,
                                      ))
                                          .whenComplete(() {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        if (!mounted) return;
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Signup Successful"),
                                              content: Text(
                                                  "You have successfully signed up."),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            LoginScreen(),
                                                      ),
                                                    );
                                                  },
                                                  child: Text("OK"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      });
                                    }
                                  },
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("Already have an account?",
                                        style:
                                            TextStyle(color: Colors.black54)),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginScreen(),
                                          ),
                                        );
                                      },
                                      child: const Text("Login",
                                          style: TextStyle(
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Text(
                  'MyFinance',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),
              Image.asset(
                'assets/ic_launcher.png',
                scale: 3,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    FormFieldValidator<String>? validator,
    TextInputType keyboardType = TextInputType.text,
    textInputAction = TextInputAction.next,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        textInputAction: TextInputAction.done,
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.deepPurple),
          hintText: hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 5,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }
}

class DiagonalCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.3); // Start at the top-left
    path.quadraticBezierTo(
      size.width * 0.2, size.height * 0.1, // Top control point
      size.width * 0.5, size.height * 0.2, // Mid control point
    );
    path.quadraticBezierTo(
      size.width * 0.8, size.height * 0.3, // Bottom control point
      size.width, size.height * 0.5, // End of the curve
    );
    path.lineTo(size.width, size.height); // Bottom-right
    path.lineTo(0, size.height); // Bottom-left
    path.close(); // Close the path to finish
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
