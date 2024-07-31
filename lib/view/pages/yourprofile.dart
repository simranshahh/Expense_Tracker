// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

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
      _loadProfilePicture();
    });
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
      if (kDebugMode) {
        print('Error picking image: $e');
      }
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
      String name, String address, String phone, String password) async {
    if (currentUser != null) {
      await handler.updateDetails(
          name, address, phone, password, currentUser!.usrId.toString());
      final updatedUser =
          await handler.getUserById(currentUser!.usrId.toString().length);
      setState(() {
        currentUser = updatedUser;
      });
    }
  }

  Future<void> _changePassword() async {
    TextEditingController oldPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Old Password',
                  ),
                ),
                TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                  ),
                ),
              ],
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
              onPressed: () async {
                String oldPassword = oldPasswordController.text;
                String newPassword = newPasswordController.text;

                if (currentUser != null) {
                  final user = await handler.getUserByCredentials(
                      currentUser!.usrName, oldPassword);

                  if (user != null) {
                    await handler.updateDetails(
                      currentUser!.usrName,
                      currentUser!.usrAddress ?? '',
                      currentUser!.usrPhone ?? '',
                      newPassword,
                      currentUser!.usrId.toString(),
                    );

                    await storage.write(key: 'usrPassword', value: newPassword);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password updated successfully')),
                    );

                    setState(() {
                      currentUser = Users(
                        usrId: currentUser!.usrId,
                        usrName: currentUser!.usrName,
                        usrPassword: newPassword,
                        usrAddress: currentUser!.usrAddress,
                        usrPhone: currentUser!.usrPhone,
                      );
                    });

                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Old password is incorrect')),
                    );
                    Navigator.of(context).pop();
                  }
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                            topLeft: Radius.circular(45),
                            topRight: Radius.circular(45),
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
                                      ? ClipOval(
                                          child: Image.memory(
                                            _imageBytes!,
                                            fit: BoxFit.cover,
                                            width: 100,
                                            height: 100,
                                          ),
                                        )
                                      : Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                ),
                                SizedBox(height: 8),
                                TextButton(
                                  onPressed: _pickAndInsertImage,
                                  child: Text(
                                    'Change Photo',
                                    style: TextStyle(color: Colors.deepPurple),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text('Username'),
                                subtitle: Text(currentUser?.usrName ?? ''),
                                trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _showEditDialog(
                                      'Username',
                                      currentUser?.usrName ?? '',
                                      (value) async {
                                        await _updateUserInfo(
                                          value,
                                          currentUser?.usrAddress ?? '',
                                          currentUser?.usrPhone ?? '',
                                          currentUser?.usrPassword ?? '',
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text('Address'),
                                subtitle: Text(currentUser?.usrAddress ?? ''),
                                trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _showEditDialog(
                                      'Address',
                                      currentUser?.usrAddress ?? '',
                                      (value) async {
                                        await _updateUserInfo(
                                          currentUser?.usrName ?? '',
                                          value,
                                          currentUser?.usrPhone ?? '',
                                          currentUser?.usrPassword ?? '',
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text('Phone'),
                                subtitle: Text(currentUser?.usrPhone ?? ''),
                                trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _showEditDialog(
                                      'Phone',
                                      currentUser?.usrPhone ?? '',
                                      (value) async {
                                        await _updateUserInfo(
                                          currentUser?.usrName ?? '',
                                          currentUser?.usrAddress ?? '',
                                          value,
                                          currentUser?.usrPassword ?? '',
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              ListTile(
                                title: Text('Password'),
                                subtitle: Text('******'),
                                trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: _changePassword,
                                ),
                              ),
                            ],
                          ),
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
