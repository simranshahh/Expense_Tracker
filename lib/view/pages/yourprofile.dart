// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myfinance/SQLite/sqlite.dart';
import 'package:myfinance/utils/colorconstant.dart';
import 'package:myfinance/utils/size_config.dart';
import 'package:myfinance/view/JsonModels/profilepicturemodel.dart';
import 'package:myfinance/view/JsonModels/users.dart';
import 'package:myfinance/view/auth/login/pages/loginpage.dart';
import 'package:myfinance/view/pages/bottomnavbar.dart';

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
    handler = DatabaseHelper();
    _loadUserCredentials();
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

        ProfilepictureModel profilePicture = ProfilepictureModel(
            photoId: currentUser!.usrId.toString(), PImage: imageBytes);
        await handler.insertProfilePicture(profilePicture);
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _showEditDialog(
      String label, String initialValue, Function(String) onSave) async {
    TextEditingController controller =
        TextEditingController(text: initialValue);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $label'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUserInfo(
      String name, String address, String phone) async {
    if (currentUser != null) {
      await handler.updateDetails(currentUser!.usrId, name, address, phone);
      final updatedUser =
          await handler.getUserById(currentUser!.usrId.toString().length);
      setState(() {
        currentUser = updatedUser;
      });
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
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return Center(child: Text("No data"));
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
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
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                  child: _imageBytes != null
                                      ? CircleAvatar(
                                          radius: 50,
                                          backgroundImage:
                                              MemoryImage(_imageBytes!),
                                        )
                                      : CircleAvatar(
                                          radius: 50,
                                          backgroundImage: NetworkImage(
                                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnIaNyYUpGuv8dBcJLV5CQlVhd1twQpewSIQ&s',
                                          ),
                                          backgroundColor: Colors.grey,
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
                      padding: EdgeInsets.only(top: 220, left: 30, right: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildProfileInfo(
                            'Name',
                            currentUser!.usrName,
                            (newValue) {
                              _updateUserInfo(
                                newValue,
                                currentUser!.usrAddress ?? '',
                                currentUser!.usrPhone ?? '',
                              );
                            },
                          ),
                          _buildProfileInfo(
                            'Address',
                            currentUser!.usrAddress ?? '',
                            (newValue) {
                              _updateUserInfo(
                                currentUser!.usrName,
                                newValue,
                                currentUser!.usrPhone ?? '',
                              );
                            },
                          ),
                          _buildProfileInfo(
                            'Phone Number',
                            currentUser!.usrPhone ?? '',
                            (newValue) {
                              _updateUserInfo(
                                currentUser!.usrName,
                                currentUser!.usrAddress ?? '',
                                newValue,
                              );
                            },
                          ),
                          // ElevatedButton(
                          //   onPressed: () async {
                          //     await storage.deleteAll();
                          //     Navigator.pushReplacement(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (BuildContext context) =>
                          //             LoginScreen(),
                          //       ),
                          //     );
                          //   },
                          //   child: Text('Save'),
                          // ),
                          Container(
                            height: 100,
                          ),
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildProfileInfo(
      String label, String value, Function(String) onSave) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _showEditDialog(label, value, onSave);
                  },
                  icon: Icon(Icons.verified_user),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
