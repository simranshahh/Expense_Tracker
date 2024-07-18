// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, avoid_types_as_parameter_names, sized_box_for_whitespace, unused_import, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:myfinance/SQLite/sqlite.dart';
import 'package:myfinance/utils/size_config.dart';
import 'package:myfinance/view/JsonModels/createaccount.dart';
import 'package:myfinance/view/JsonModels/transactionmodel.dart';
import 'package:myfinance/view/pages/ViewCreatedAccount.dart';
import 'package:myfinance/view/pages/bottomnavbar.dart';
import 'package:myfinance/view/pages/inout.dart';

class CashIn extends StatefulWidget {
  CashIn({super.key});

  @override
  State<CashIn> createState() => _CashInState();
}

List<String> fromdropdown = <String>[];
List<String> todropdown = <String>[];
String? fromselectedcategory;

late final CreateAccountModel user;

final from = TextEditingController();
final to = TextEditingController();
final amount = TextEditingController();
final db = DatabaseHelper();
final remarks = TextEditingController();

class _CashInState extends State<CashIn> {
  final formKey = GlobalKey<FormState>();
  late DatabaseHelper handler;
  late Future<List<CreateAccountModel>> adata;

  @override
  void initState() {
    _fetchAccountNames();
    _fetchAccountName();
    handler = DatabaseHelper();
    adata = handler.getaccount();

    handler.initDB().whenComplete(() {
      adata = getadata();
    });

    super.initState();
  }

  Future<List<CreateAccountModel>> getadata() {
    return handler.getaccount();
  }

  Future<void> _fetchAccountNames() async {
    final dbHelper = DatabaseHelper();
    List<CreateAccountModel> accounts = await dbHelper.getaccount();
    setState(() {
      fromdropdown.clear();
      fromdropdown.addAll(accounts.map((account) => account.accountName));
    });
  }

  Future<void> _fetchAccountName() async {
    final dbHelper = DatabaseHelper();
    List<CreateAccountModel> accounts = await dbHelper.getaccount();
    setState(() {
      todropdown.clear();
      todropdown.addAll(accounts.map((account) => account.accountName));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(children: [
        Container(
          height: displayHeight(context) * 0.35,
          width: displayWidth(context),
          decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50),
                  bottomRight: Radius.circular(50))),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 18),
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext) => INOUT()));
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 30),
                child: Text(
                  'CASH IN',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 95.0),
            child: Container(
              height: displayHeight(context),
              width: displayWidth(context),
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(color: Colors.grey, blurRadius: 1, spreadRadius: 0.1)
              ], borderRadius: BorderRadius.circular(30), color: Colors.white),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Text(
                              'From',
                              style: TextStyle(fontSize: 18),
                            ),
                            Container(
                              height: displayHeight(context) * 0.08,
                              width: displayWidth(context) * 0.6,
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.deepPurple.withOpacity(.2)),
                              child: TextFormField(
                                readOnly: true,
                                controller: from,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Name is required";
                                  }
                                },
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.person),
                                  border: InputBorder.none,
                                  hintText: "From",
                                ),
                                onTap: () {
                                  _showOptions(context);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'To    ',
                              style: TextStyle(fontSize: 18),
                            ),
                            Container(
                              height: displayHeight(context) * 0.09,
                              width: displayWidth(context) * 0.6,
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.deepPurple.withOpacity(.2)),
                              child: TextFormField(
                                readOnly: true,
                                controller: to,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Name is required";
                                  } else {
                                    if (to.text == from.text) {
                                      return "Value is not accepted";
                                    }
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.person),
                                  border: InputBorder.none,
                                  hintText: "Name",
                                ),
                                onTap: () {
                                  to_options(context);
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'Rs.   ',
                              style: TextStyle(fontSize: 18),
                            ),
                            Container(
                              height: displayHeight(context) * 0.08,
                              width: displayWidth(context) * 0.6,
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.deepPurple.withOpacity(.2)),
                              child: TextFormField(
                                controller: amount,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "amount is required";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.person),
                                  border: InputBorder.none,
                                  hintText: "Amount",
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'Not   ',
                              style: TextStyle(fontSize: 18),
                            ),
                            Container(
                              height: displayHeight(context) * 0.08,
                              width: displayWidth(context) * 0.6,
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.deepPurple.withOpacity(.2)),
                              child: TextFormField(
                                controller: remarks,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Name is required";
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  icon: Icon(Icons.person),
                                  border: InputBorder.none,
                                  hintText: "Remarks",
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                db
                                    .transactioncreate(TransactionModel(
                                        fromid: from.text.toString().length,
                                        toid: to.text,
                                        amount: amount.toString().length,
                                        remarks: remarks.text,
                                        createdAt:
                                            DateTime.now().toIso8601String()))
                                    .whenComplete(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              Bottomnavbar()));
                                });
                              }
                            },
                            child: Text('SUBMIT')),
                        SizedBox(
                          height: 200,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ]),
    ));
  }

  void _showOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select an Option'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: fromdropdown.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(fromdropdown[index]),
                  onTap: () {
                    setState(() {
                      from.text = fromdropdown[index];
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void to_options(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select an Option'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: todropdown.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(todropdown[index]),
                  onTap: () {
                    setState(() {
                      to.text = todropdown[index];
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
