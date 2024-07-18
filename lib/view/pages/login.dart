// // ignore_for_file: unused_import

// import 'package:flutter/material.dart';
// import 'package:myfinance/SQLite/sqlite.dart';
// import 'package:myfinance/view/JsonModels/users.dart';
// import 'package:myfinance/view/auth/register/pages/registerpage.dart';
// import 'package:myfinance/view/pages/bottomnavbar.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final username = TextEditingController();
//   final password = TextEditingController();

//   bool isVisible = false;

//   bool isLoginTrue = false;

//   final db = DatabaseHelper();

//   login() async {
//     var response = await db
//         .login(Users(usrName: username.text, usrPassword: password.text));
//     if (response == true) {
//       if (!mounted) return;
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => Bottomnavbar()));
//     } else {
//       setState(() {
//         isLoginTrue = true;
//       });
//     }
//   }

//   final formKey = GlobalKey<FormState>();
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Center(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Form(
//                 key: formKey,
//                 child: Column(
//                   children: [
//                     Image.asset(
//                       "assets/login.png",
//                       width: 210,
//                     ),
//                     const SizedBox(height: 15),
//                     Container(
//                       margin: const EdgeInsets.all(8),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 6),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Colors.deepPurple.withOpacity(.2)),
//                       child: TextFormField(
//                         controller: username,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return "username is required";
//                           }
//                           return null;
//                         },
//                         decoration: const InputDecoration(
//                           icon: Icon(Icons.person),
//                           border: InputBorder.none,
//                           hintText: "Username",
//                         ),
//                       ),
//                     ),

//                     //Password field
//                     Container(
//                       margin: const EdgeInsets.all(8),
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 6),
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Colors.deepPurple.withOpacity(.2)),
//                       child: TextFormField(
//                         controller: password,
//                         validator: (value) {
//                           if (value!.isEmpty) {
//                             return "password is required";
//                           }
//                           return null;
//                         },
//                         obscureText: !isVisible,
//                         decoration: InputDecoration(
//                             icon: const Icon(Icons.lock),
//                             border: InputBorder.none,
//                             hintText: "Password",
//                             suffixIcon: IconButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     isVisible = !isVisible;
//                                   });
//                                 },
//                                 icon: Icon(isVisible
//                                     ? Icons.visibility
//                                     : Icons.visibility_off))),
//                       ),
//                     ),

//                     const SizedBox(height: 10),
//                     Container(
//                       height: 55,
//                       width: MediaQuery.of(context).size.width * .9,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8),
//                           color: Colors.deepPurple),
//                       child: TextButton(
//                           onPressed: () {
//                             if (formKey.currentState!.validate()) {
//                               login();

//                               //Now we have a response from our sqlite method
//                               //We are going to create a user
//                             }
//                           },
//                           child: const Text(
//                             "LOGIN",
//                             style: TextStyle(color: Colors.white),
//                           )),
//                     ),

//                     //Sign up button
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         const Text("Don't have an account?"),
//                         TextButton(
//                             onPressed: () {
//                               //Navigate to sign up
//                               Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => SignUp()));
//                             },
//                             child: const Text("SIGN UP"))
//                       ],
//                     ),

//                     // We will disable this message in default, when user and pass is incorrect we will trigger this message to user
//                     isLoginTrue
//                         ? const Text(
//                             "Username or passowrd is incorrect",
//                             style: TextStyle(color: Colors.red),
//                           )
//                         : const SizedBox(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
