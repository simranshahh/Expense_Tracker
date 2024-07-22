// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unused_import, prefer_const_constructors_in_immutables, deprecated_member_use, must_call_super, non_constant_identifier_names, use_build_context_synchronously, unused_field, unnecessary_null_comparison, unused_element, must_be_immutable

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

class YourProfile extends StatefulWidget {
  final Users? users;
  YourProfile({super.key, this.users});

  @override
  State<YourProfile> createState() => _YourProfileState();
}

class _YourProfileState extends State<YourProfile> {
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
        currentUser = user!;
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
                                if (_imageBytes != null)
                                  Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(35),
                                      image: DecorationImage(
                                        image: MemoryImage(_imageBytes!),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  )
                                else
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(35),
                                    ),
                                    child: Center(
                                      child: Image.network(
                                        scale: 2,
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnIaNyYUpGuv8dBcJLV5CQlVhd1twQpewSIQ&s',
                                        fit: BoxFit.fill,
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
                                ] else ...[
                                  Text("Loading user...",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                            color: ColorConstant.primarydark,
                                            fontWeight: FontWeight.w600,
                                          )),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 208.0),
                    child: Container(
                      height: 1,
                      width: displayWidth(context),
                      color: ColorConstant.grey,
                    ),
                  ),
                  if (currentUser != null)
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 220, left: 30, right: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Name',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Container(
                                height: 55,
                                width: displayWidth(context),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.deepPurple.withOpacity(0.2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        currentUser!.usrName,
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.edit))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Address',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Container(
                                height: 55,
                                width: displayWidth(context),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.deepPurple.withOpacity(0.2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        currentUser!.usrAddress ?? '',
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.edit))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Phone Number',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Container(
                                height: 55,
                                width: displayWidth(context),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.deepPurple.withOpacity(0.2),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        currentUser!.usrPhone ?? '',
                                      ),
                                      IconButton(
                                          onPressed: () {},
                                          icon: Icon(Icons.edit))
                                    ],
                                  ),
                                ),
                              ),
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
                              child: Text('Save'))
                        ],
                      ),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 130.0, left: 75),
                        child: Container(
                            height: 25,
                            width: 25,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(35),
                            ),
                            child: Center(
                              child: IconButton(
                                onPressed: () {
                                  _pickAndInsertImage();
                                },
                                icon: Icon(
                                  Icons.camera,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 80,
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
