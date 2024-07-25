// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, unnecessary_string_interpolations, unused_import

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance/SQLite/sqlite.dart';
import 'package:myfinance/utils/size_config.dart';
import 'package:myfinance/view/JsonModels/transactionmodel.dart';
import 'package:myfinance/view/JsonModels/users.dart';
import 'package:myfinance/view/pages/ViewCreatedAccount.dart';
import 'package:myfinance/view/pages/chart.dart';
import 'package:myfinance/view/pages/createaccount.dart';
import 'package:myfinance/view/pages/profilepage.dart';
import 'package:myfinance/view/pages/yourprofile.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  late DatabaseHelper handler;
  Future<List<TransactionModel>>? tData;
  Future<Object>? totalExpenses;
  Users? currentUser;
  late Future<List<Users>> udata;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHelper();

    handler.initDB().whenComplete(() async {
      await fetchCurrentUser();
      tData = gettData();
      totalExpenses = handler.getTotalExpenses();
      udata = getusertData();
      setState(() {});
    });
  }

  Future<void> fetchCurrentUser() async {
    currentUser = await handler.getCurrentUser();
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
          toolbarHeight: 80,
          backgroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
          ),
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
                fontSize: 25,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => YourProfile(),
                  ),
                );
              },
            ),
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
                        'assets/ic_launcher.png',
                        scale: 3,
                      )
                    ],
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.add_box),
                title: Text('Create Account'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => CreateAccount()));
                },
              ),
              ListTile(
                leading: Icon(Icons.view_agenda),
                title: Text('View Report'),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              'Total Expenses',
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${snapshot.data}',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
              Container(height: 280, child: Chart()),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'All Expenses',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the detailed expenses page
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<TransactionModel>>(
                  future: tData,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<TransactionModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return Center(child: Text("No data"));
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
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
                        itemCount: userTransactions.length,
                        itemBuilder: (BuildContext context, index) {
                          final transaction = userTransactions[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 12.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 8,
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor:
                                          Colors.deepPurple.withOpacity(0.2),
                                      child: Icon(
                                        Icons.monetization_on,
                                        size: 30,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            transaction.toid,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.deepPurple,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            transaction.remarks,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            DateFormat("yMd").format(
                                              DateTime.parse(transaction
                                                  .createdAt
                                                  .toString()),
                                            ),
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '${transaction.amount.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
