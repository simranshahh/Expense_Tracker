// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance/SQLite/sqlite.dart';
import 'package:myfinance/utils/size_config.dart';
import 'package:myfinance/view/JsonModels/transactionmodel.dart';
import 'package:myfinance/view/JsonModels/users.dart';
import 'package:myfinance/view/pages/ViewCreatedAccount.dart';
import 'package:myfinance/view/pages/createaccount.dart';
import 'package:myfinance/view/pages/yourprofile.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late DatabaseHelper handler;
  late Future<List<TransactionModel>> tData;
  late Future<Object> totalExpenses;
  Users? currentUser;

  late Future<List<Users>> udata;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHelper();
    tData = handler.gettransaction();
    totalExpenses = handler.getTotalExpenses();

    handler.initDB().whenComplete(() {
      setState(() {
        fetchCurrentUser();
        udata = getusertData();

        tData = gettData();
        totalExpenses = handler.getTotalExpenses();
      });
    });
  }

  Future<void> fetchCurrentUser() async {
    currentUser = (await handler.getCurrentUser());
  }

  Future<List<TransactionModel>> gettData() {
    return handler.gettransaction();
  }

  Future<List<Users>> getusertData() {
    return handler.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            title: Center(
              child: Text(
                'DASHBOARD',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.manage_accounts,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => YourProfile()));
                },
              )
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                  ),
                  child: Center(
                    child: Row(
                      children: [
                        Text(
                          '       My Finance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                        Image.asset(
                          'assets/logo.png',
                          scale: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Create Account'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                CreateAccount()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.view_array),
                  title: Text('View Created Account'),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ViewCreatedAccount()));
                  },
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: FutureBuilder<Object>(
                  future: totalExpenses,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        height: 100,
                        width: displayWidth(context),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Container(
                        height: 100,
                        width: displayWidth(context),
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Total Expenses',
                              style:
                                  TextStyle(fontSize: 22, color: Colors.white),
                            ),
                            Text(
                              '\$${snapshot.data}',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              // Container(height: 280, child: Chart()),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All Expenses',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  // Text(
                  //   'View All',
                  //   style: TextStyle(decoration: TextDecoration.underline),
                  // ),
                ],
              ),
              Expanded(
                child: FutureBuilder<List<TransactionModel>>(
                    future: tData,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<TransactionModel>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                        return const Center(child: Text("No data"));
                      } else if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      } else {
                        final items = snapshot.data ?? <TransactionModel>[];
                        final userTransactions = items
                            .where((transaction) =>
                                transaction.fromid == currentUser?.usrId)
                            .toList();

                        if (userTransactions.isEmpty) {
                          return Center(
                              child: Text("No transactions for current user."));
                        }

                        return ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (BuildContext context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 10),
                                child: Container(
                                  height: displayHeight(context) * 0.12,
                                  width: displayWidth(context),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey, blurRadius: 0.2)
                                      ]),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      CircleAvatar(
                                          radius: 25,
                                          backgroundImage:
                                              AssetImage('assets/profile.png')),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            userTransactions[index]
                                                .toid
                                                .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(userTransactions[index].remarks),
                                          Text(DateFormat("yMd").format(
                                              DateTime.parse(
                                                  items[index].createdAt))),
                                        ],
                                      ),
                                      Text(
                                        userTransactions[index]
                                            .amount
                                            .toString(),
                                        style:
                                            TextStyle(color: Colors.deepPurple),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }
                            // },
                            );
                      }
                    }),
              ),
            ]),
          )),
    );
  }
}
