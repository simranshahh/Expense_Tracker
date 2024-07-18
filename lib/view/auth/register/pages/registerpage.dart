// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myfinance/SQLite/sqlite.dart';
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
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const ListTile(
                            // title: Center(
                            //   child: Text(
                            //     "Register In MyFinance",
                            //     style: TextStyle(
                            //         fontSize: 30, fontWeight: FontWeight.bold),
                            //   ),
                            // ),
                            ),
                        Image.asset(
                          'assets/login.png',
                          height: 130,
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.deepPurple.withOpacity(.2)),
                          child: TextFormField(
                            controller: username,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "username is required";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              icon: Icon(Icons.person),
                              border: InputBorder.none,
                              hintText: "Username",
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.deepPurple.withOpacity(.2)),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Phone Number is required";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              icon: Icon(Icons.phone),
                              border: InputBorder.none,
                              hintText: "Phone Number",
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.deepPurple.withOpacity(.2)),
                          child: TextFormField(
                            controller: address,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Address is required";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              icon: Icon(Icons.location_on),
                              border: InputBorder.none,
                              hintText: "Address",
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.deepPurple.withOpacity(.2)),
                          child: TextFormField(
                            controller: password,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "password is required";
                              }
                              return null;
                            },
                            obscureText: !isVisible,
                            decoration: InputDecoration(
                                icon: const Icon(Icons.lock),
                                border: InputBorder.none,
                                hintText: "Password",
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isVisible = !isVisible;
                                      });
                                    },
                                    icon: Icon(isVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off))),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.deepPurple.withOpacity(.2)),
                          child: TextFormField(
                            controller: confirmPassword,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "password is required";
                              } else if (password.text !=
                                  confirmPassword.text) {
                                return "Passwords don't match";
                              }
                              return null;
                            },
                            obscureText: !isVisible,
                            decoration: InputDecoration(
                                icon: const Icon(Icons.lock),
                                border: InputBorder.none,
                                hintText: "Confirm Password",
                                suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isVisible = !isVisible;
                                      });
                                    },
                                    icon: Icon(isVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off))),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 55,
                          width: MediaQuery.of(context).size.width * .9,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.deepPurple),
                          child: TextButton(
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
                            child: const Text(
                              "SIGN UP",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        if (_isLoading) CircularProgressIndicator(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account?"),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: const Text("Login"))
                          ],
                        )
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
