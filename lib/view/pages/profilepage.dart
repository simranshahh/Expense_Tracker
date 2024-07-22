// ignore_for_file: prefer_const_constructors, unused_element

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfinance/SQLite/sqlite.dart';
import 'package:myfinance/utils/colorconstant.dart';
import 'package:myfinance/utils/size_config.dart';
import 'package:myfinance/view/JsonModels/profilepicturemodel.dart';
import 'package:myfinance/view/JsonModels/users.dart';
import 'package:myfinance/view/auth/login/pages/loginpage.dart';
import 'package:myfinance/view/pages/ViewCreatedAccount.dart';
import 'package:myfinance/view/pages/bottomnavbar.dart';
import 'package:myfinance/view/pages/createaccount.dart';
import 'package:myfinance/view/pages/yourprofile.dart';

class ProfilePage extends StatefulWidget {
  final Users? users;
  ProfilePage({super.key, this.users});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfilepictureModel? profilePicture;

  final storage = FlutterSecureStorage();
  late DatabaseHelper handler;
  Users? currentUser;
  late Future<List<Users>> udata;

  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    _loadUserCredentials();
    handler = DatabaseHelper();

    udata = handler.getUsers();

    handler.initDB().whenComplete(() {
      udata = gettData();
      _loadProfilePicture();
    });
  }

  Future<List<Users>> gettData() {
    return handler.getUsers();
  }

  Future<void> _loadUserCredentials() async {
    final usrName = await storage.read(key: 'usrName');
    final usrPassword = await storage.read(key: 'usrPassword');

    if (usrName != null && usrPassword != null) {
      final user = await handler.getUserByCredentials(usrName, usrPassword);
      setState(() {
        currentUser = user;
      });
    }
  }

  Future<void> _loadProfilePicture() async {
    if (currentUser != null) {
      var picture =
          await handler.getProfilePicture(currentUser!.usrId.toString());
      setState(() {
        profilePicture = picture;
        if (profilePicture != null) {
          _imageBytes = profilePicture!.PImage;
        }
      });
    }
  }

  Future<void> _pickAndInsertImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        Uint8List imageBytes = await File(image.path).readAsBytes();
        setState(() {
          _imageBytes = imageBytes;
        });

        // Insert image into database
        ProfilepictureModel profilePicture = ProfilepictureModel(
            photoId: currentUser!.usrId.toString(), PImage: imageBytes);
        await handler.insertProfilePicture(profilePicture);
      }
    } catch (e) {
      // ignore: avoid_print
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.primary,
        body: FutureBuilder<List<Users>>(
          future: udata,
          builder: (BuildContext context, AsyncSnapshot<List<Users>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Center(child: Text("No data"));
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              final items = snapshot.data ?? <Users>[];

              return Stack(
                children: [
                  Container(
                    color: Colors.deepPurple,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      Bottomnavbar()),
                            );
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: ColorConstant.white,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Confirm Exit'),
                                  content: Text('Do you want to exit?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('No'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await storage.deleteAll();
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  LoginScreen()),
                                        );
                                      },
                                      child: Text('Yes'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          icon: Icon(
                            Icons.exit_to_app,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
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
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  child: Center(
                                    child: _imageBytes != null
                                        ? Image.memory(
                                            _imageBytes!,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            scale: 2,
                                            'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                if (currentUser != null) ...[
                                  Text(currentUser!.usrName.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: ColorConstant.primarydark,
                                            fontWeight: FontWeight.w600,
                                          )),
                                  Text(currentUser!.usrAddress.toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            color: ColorConstant.grey,
                                            fontWeight: FontWeight.w600,
                                          )),
                                ],
                                SizedBox(
                                  height: displayHeight(context) * 0.06,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 0.0),
                                  child: SizedBox(
                                    width: displayWidth(context) * 0.9,
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
                                ),
                                SizedBox(
                                  height: displayHeight(context) * 0.02,
                                ),
                                SizedBox(
                                  width: displayWidth(context) * 0.9,
                                  height: 40,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
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
                                SizedBox(
                                  height: displayHeight(context) * 0.02,
                                ),
                                SizedBox(
                                  width: displayWidth(context) *  0.9,
                                  height: 40,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  YourProfile()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                      side: BorderSide.none,
                                      shape: const StadiumBorder(),
                                    ),
                                    child: Center(
                                      child: Text('Your Profile',
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
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
