// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myfinance/SQLite/sqlite.dart';
import 'package:myfinance/view/JsonModels/users.dart';
import 'package:myfinance/view/auth/register/pages/registerpage.dart';
import 'package:myfinance/view/pages/bottomnavbar.dart';
import '../../../../utils/size_config.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final username = TextEditingController();
  final password = TextEditingController();

  bool isVisible = false;
  bool isLoginTrue = false;
  bool isLoading = false;

  final db = DatabaseHelper();
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loadCredentials() async {
    final storedUsername = await storage.read(key: 'usrName');
    final storedPassword = await storage.read(key: 'usrPassword');
    if (storedUsername != null) {
      setState(() {
        username.text = storedUsername;
      });
    }
    if (storedPassword != null) {
      setState(() {
        password.text = storedPassword;
      });
    }
  }

  login() async {
    setState(() {
      isLoading = true;
      isLoginTrue = false;
    });

    bool response = await db.login(
      Users(usrName: username.text, usrPassword: password.text),
    );

    setState(() {
      isLoading = false;
    });

    if (response) {
      Users? currentUser = await db.getUserByCredentials(
        username.text,
        password.text,
      );
      if (currentUser != null) {
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Bottomnavbar(),
          ),
        );
      }
    } else {
      setState(() {
        isLoginTrue = true;
      });
    }
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: displayHeight(context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: Offset(0, 20),
                  ),
                ],
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/bg.png",
                      width: displayWidth(context),
                      height: displayHeight(context) * 0.32,
                    ),
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
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 15),
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
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 20),
                    isLoading
                        ? CircularProgressIndicator(
                            value: 3.0,
                            color: Colors.deepPurple,
                          )
                        : _buildButton(
                            text: "LOGIN",
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                login();
                              }
                            },
                          ),
                    if (isLoginTrue)
                      AnimatedOpacity(
                        opacity: isLoginTrue ? 1.0 : 0.0,
                        duration: Duration(milliseconds: 300),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Username or password is incorrect",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignUp(),
                              ),
                            );
                          },
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
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
    TextInputAction textInputAction = TextInputAction.next,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          icon: Icon(icon, color: Colors.deepPurple),
          hintText: hintText,
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            padding: EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
