// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_types_as_parameter_names, prefer_const_constructors, unnecessary_string_escapes

import 'package:flutter/material.dart';
import 'package:myfinance/SQLite/sqlite.dart';
import 'package:myfinance/utils/size_config.dart';
import 'package:myfinance/view/JsonModels/transactionmodel.dart';
import 'package:myfinance/view/pages/profilepage.dart';

class IndividualDataPage extends StatefulWidget {
  const IndividualDataPage({super.key});

  @override
  State<IndividualDataPage> createState() => _IndividualDataPageState();
}

class _IndividualDataPageState extends State<IndividualDataPage> {
  late DatabaseHelper handler;
  late Future<List<TransactionModel>> tData;

  @override
  void initState() {
    handler = DatabaseHelper();
    tData = handler.gettransaction();

    handler.initDB().whenComplete(() {
      tData = gettData();
    });

    super.initState();
  }

  Future<List<TransactionModel>> gettData() {
    return handler.gettransaction();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            leading: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            title: Center(
              child: Text(
                'Name',
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
                          builder: (BuildContext context) => ProfilePage()));
                },
              )
            ],
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
                child: Container(
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
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                      Text(
                        '\-40 RS.',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('All Expenses'),
                  Text(
                    'View All',
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
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

                        return ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 5),
                              child: Container(
                                height: displayHeight(context) * 0.15,
                                width: displayWidth(context),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey, blurRadius: 0.1)
                                    ]),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage: NetworkImage(
                                        'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(items[index].toid),
                                        Text(items[index].remarks)
                                      ],
                                    ),
                                    Text(
                                      items[index].amount.toString(),
                                      style:
                                          TextStyle(color: Colors.deepPurple),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }
                    }),
              ),
            ]),
          )),
    );
  }
}
