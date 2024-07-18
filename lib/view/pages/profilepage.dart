// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_import, prefer_const_constructors_in_immutables, deprecated_member_use, must_call_super, non_constant_identifier_names, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myfinance/SQLite/sqlite.dart';
import 'package:myfinance/utils/colorconstant.dart';
import 'package:myfinance/utils/size_config.dart';
import 'package:myfinance/view/JsonModels/users.dart';
import 'package:myfinance/view/auth/login/pages/loginpage.dart';
import 'package:myfinance/view/pages/ViewCreatedAccount.dart';
import 'package:myfinance/view/pages/bottomnavbar.dart';
import 'package:myfinance/view/pages/createaccount.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key, this.users});

  final Users? users;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storage = FlutterSecureStorage();
  late DatabaseHelper handler;
  late Users currentUser;
  late Future<List<Users>> udata;

  @override
  void initState() {
    _loadUserCredentials();
    handler = DatabaseHelper();

    udata = handler.getUsers();

    handler.initDB().whenComplete(() {
      udata = gettData();
    });
    // super.initState();
  }

  Future<List<Users>> gettData() {
    return handler.getUsers();
  }

  String? usrName;
  String? usrPassword;

  Future<void> _loadUserCredentials() async {
    final usrName = await storage.read(key: 'usrName');
    final usrPassword = await storage.read(key: 'usrPassword');

    if (usrName != null && usrPassword != null) {
      final user = await handler.getUserByCredentials(usrName, usrPassword);
      setState(() {
        currentUser = user!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.primary,
        body: Expanded(
          child: FutureBuilder<List<Users>>(
              future: udata,
              builder:
                  (BuildContext context, AsyncSnapshot<List<Users>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(child: Text("No data"));
                } else if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else {
                  final items = snapshot.data ?? <Users>[];

                  return Stack(children: [
                    Container(
                      color: Colors.deepPurple,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Bottomnavbar()));
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: ColorConstant.white,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 118.0),
                      child: Container(
                        height: displayHeight(context),
                        decoration: BoxDecoration(
                            color: ColorConstant.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-_LdfKGBN5WKAj3hJ9ijYvhROSOe5dBms6ffJz7ckNgKVnmYBtlkASIx9gCchnXQaVBo&usqp=CAU'),
                                    radius: 55,
                                  ),
                                  Text(currentUser.usrName.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: ColorConstant.primarydark,
                                            fontWeight: FontWeight.w600,
                                          )),
                                  Text(currentUser.usrAddress.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: ColorConstant.grey,
                                            fontWeight: FontWeight.w600,
                                          )),
                                  SizedBox(
                                    height: displayHeight(context) * 0.02,
                                  ),
                                  SizedBox(
                                    width: 130,
                                    height: 40,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        CreateAccount()));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                        side: BorderSide.none,
                                        shape: const StadiumBorder(),
                                      ),
                                      child: Text('Create Account',
                                          textScaleFactor: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                                color: ColorConstant.white,
                                              )),
                                    ),
                                  ),
                                  SizedBox(
                                    height: displayHeight(context) * 0.02,
                                  ),
                                  SizedBox(
                                    width: 170,
                                    height: 40,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        ViewCreatedAccount()));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                        side: BorderSide.none,
                                        shape: const StadiumBorder(),
                                      ),
                                      child: Center(
                                        child: Text('View Created Account',
                                            textScaleFactor: 1,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                  color: ColorConstant.white,
                                                )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 328.0),
                      child: Container(
                        height: 1,
                        width: displayWidth(context),
                        color: ColorConstant.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 310.0, left: 30, right: 30),
                      child: Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Name'),
                                Text(
                                  currentUser.usrName,
                                ),
                              ],
                            ),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text('Email Address'),
                            //     Text('Simran@gmail.com'),
                            //   ],
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Address'),
                                Text(
                                  currentUser.usrAddress ?? '',
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Phone Number'),
                                Text(currentUser.usrPhone ?? ''),
                              ],
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  await storage.deleteAll();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            LoginScreen()),
                                  );
                                },
                                child: Text('Logout'))
                          ],
                        ),
                      ),
                    ),
                  ]);
                }
              }),
        ),
      ),
    );
  }
}
