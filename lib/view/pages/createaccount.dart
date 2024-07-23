// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

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
  TextEditingController accountname = TextEditingController();
  TextEditingController accountaddress = TextEditingController();
  TextEditingController accountphone = TextEditingController();
  TextEditingController accountcategory = TextEditingController();

  int? expenseId;
  String? account;
  int? expenseNumber;

  final items = ["Debitor", "Creditor", "Income", "Expenses", "Cash Back"];
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
                  builder: (BuildContext context) => ProfilePage(),
                ),
              );
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    label: 'NAME',
                    hintText: 'Full Name',
                    icon: Icons.person,
                    controller: accountname,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Username is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    label: 'ADDRESS',
                    hintText: 'Address',
                    icon: Icons.location_on,
                    controller: accountaddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Address is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    label: 'CONTACT',
                    hintText: 'Contact',
                    icon: Icons.phone,
                    controller: accountphone,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Contact is required";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  _buildCategoryDropdown(),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          db.accountcreate(
                            CreateAccountModel(
                              userId: 1, // Replace with actual userId if available
                              accountName: accountname.text,
                              accountAddress: accountaddress.text,
                              accountPhone: accountphone.text,
                              accountCategory: accountcategory.text,
                            ),
                          ).whenComplete(() {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Created'),
                                  content: Text('Account Created Successfully'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) => Bottomnavbar(),
                                          ),
                                        );
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          });
                        }
                      },
                      child: Text('Save'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.deepPurple.withOpacity(.2),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
              icon: Icon(icon),
              border: InputBorder.none,
              hintText: hintText,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CATEGORY',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 5),
        Container(
          height: 65,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.deepPurple.withOpacity(.2),
          ),
          child: TextFormField(
            readOnly: true,
            controller: accountcategory,
            decoration: InputDecoration(
              icon: Icon(Icons.category),
              suffixIcon: PopupMenuButton<String>(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: ColorConstant.grey,
                ),
                onSelected: (String value) {
                  setState(() {
                    accountcategory.text = value;
                    expenseNumber = items.indexOf(value) + 1;
                  });
                },
                itemBuilder: (BuildContext context) {
                  return items
                      .map<PopupMenuItem<String>>((String value) {
                    return PopupMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList();
                },
              ),
              fillColor: Colors.grey.shade300,
              labelText: 'Category',
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) return 'Category is required';
              return null;
            },
          ),
        ),
      ],
    );
  }
}
