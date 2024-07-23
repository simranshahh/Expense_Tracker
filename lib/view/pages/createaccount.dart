// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, use_build_context_synchronously, unused_import

import 'package:flutter/material.dart';
import 'package:myfinance/SQLite/sqlite.dart';
import 'package:myfinance/utils/colorconstant.dart';
import 'package:myfinance/view/JsonModels/createaccount.dart';
import 'package:myfinance/view/pages/bottomnavbar.dart';
import 'package:myfinance/view/pages/profilepage.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();

  static fromMap(Map<String, Object?> e) {}
}

class _CreateAccountState extends State<CreateAccount> {
  final db = DatabaseHelper();
  TextEditingController Expensectrl = TextEditingController();
  final accountname = TextEditingController();
  final accountaddress = TextEditingController();
  final accountphone = TextEditingController();
  final accountcategory = TextEditingController();

  int? ExpenseId;
  String? account;
  int? Expensenumber;

  var items = ["Debitor", "Creditor", "Income", "Expenses", "Cash Back"];
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: Text(
            "Create Account",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ProfilePage()));
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NAME',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.deepPurple.withOpacity(.2)),
                      child: TextFormField(
                        controller: accountname,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "username is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          border: InputBorder.none,
                          hintText: "Full Name",
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'ADDRESS',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.deepPurple.withOpacity(.2)),
                      child: TextFormField(
                        controller: accountaddress,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Address is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          border: InputBorder.none,
                          hintText: "Address",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'CONTACT',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.deepPurple.withOpacity(.2)),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: accountphone,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Contact is required";
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person),
                          border: InputBorder.none,
                          hintText: "Contact",
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'CATEGORY',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      height: 65,
                      margin: EdgeInsets.all(1),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.deepPurple.withOpacity(.2)),
                      child: TextFormField(
                        readOnly: true,
                        onSaved: (input) => account = input,
                        controller: accountcategory,
                        decoration: InputDecoration(
                          icon: Icon(Icons.category),
                          // border: OutlineInputBorder(),

                          suffixIcon: PopupMenuButton<String>(
                            icon: Icon(
                              Icons.arrow_drop_down,
                              color: ColorConstant.grey,
                            ),
                            onSelected: (String value) {
                              setState(() {
                                accountcategory.text = value;
                                if (value == "Debitor") {
                                  Expensenumber = 1;
                                } else if (value == "Creditor") {
                                  Expensenumber = 2;
                                } else if (value == "Income") {
                                  Expensenumber = 3;
                                } else if (value == "Expenses") {
                                  Expensenumber = 4;
                                } else if (value == "Cash Back") {
                                  Expensenumber = 5;
                                } else {
                                  Expensenumber = 0;
                                }
                              });
                            },
                            itemBuilder: (BuildContext context) {
                              return items
                                  .map<PopupMenuItem<String>>((String value) {
                                return PopupMenuItem(
                                    value: value, child: Text(value));
                              }).toList();
                            },
                          ),
                          fillColor: Colors.grey.shade300,
                          // filled: true,
                          labelText: 'Category',
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty) return 'Category';
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                        child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                db
                                    .accountcreate(
                                  CreateAccountModel(
                                    // accountId: autoincrement,
                                    accountName: accountname.text,
                                    accountAddress: accountaddress.text,
                                    accountPhone: accountphone.text,
                                    accountCategory: accountcategory.text,
                                  ),
                                )
                                    .whenComplete(() {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Created'),
                                          content: Text(
                                              'Account Created Successfully'),
                                          actions: <Widget>[
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              Bottomnavbar()));
                                                },
                                                child: Text('OK'))
                                          ],
                                        );
                                      });
                                });
                              }
                            },
                            child: Text('Save')))
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
