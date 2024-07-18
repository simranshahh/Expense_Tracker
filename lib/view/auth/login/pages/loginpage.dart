// ignore_for_file: unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myfinance/SQLite/sqlite.dart';
import 'package:myfinance/view/JsonModels/users.dart';
import 'package:myfinance/view/auth/register/pages/registerpage.dart';
import 'package:myfinance/view/pages/bottomnavbar.dart';
import 'package:myfinance/view/pages/dashboard.dart';

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

  // login() async {

  //   var response = await db
  //       .login(Users(usrName: username.text, usrPassword: password.text));
  //   setState(() {
  //     isLoading = false;
  //   });
  //   if (response == true) {
  //     if (!mounted) return;
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //             builder: (BuildContext context) => const Bottomnavbar()));
  //   } else {

  //   }
  // }

  login() async {
    setState(() {
      isLoading = true;
      isLoginTrue = false;
    });

    bool response = await db
        .login(Users(usrName: username.text, usrPassword: password.text));

    setState(() {
      isLoading = false;
    });

    if (response) {
      Users? currentUser =
          await db.getUserByCredentials(username.text, password.text);
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
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: isLoading
                  ? CircularProgressIndicator()
                  : Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/login.png",
                            width: 210,
                          ),
                          const SizedBox(height: 15),
                          Container(
                            margin: const EdgeInsets.all(8),
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
                                      isLoading = true;
                                    });

                                    login();
                                  }
                                },
                                child: const Text(
                                  "LOGIN",
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                          isLoginTrue
                              ? Text(
                                  '',
                                  style: TextStyle(color: Colors.red),
                                )
                              : SizedBox(),

                          //Sign up button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Don't have an account?"),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SignUp()));
                                  },
                                  child: const Text("SIGN UP"))
                            ],
                          ),

                          isLoginTrue
                              ? const Text(
                                  "Username or passowrd is incorrect",
                                  style: TextStyle(color: Colors.red),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
