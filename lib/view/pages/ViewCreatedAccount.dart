// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:myfinance/SQLite/sqlite.dart';
import 'package:myfinance/utils/size_config.dart';
import 'package:myfinance/view/JsonModels/createaccount.dart';
import 'package:myfinance/view/pages/datatable/datatable.dart';
import 'package:myfinance/view/pages/profilepage.dart';

class ViewCreatedAccount extends StatefulWidget {
  const ViewCreatedAccount({super.key});

  @override
  State<ViewCreatedAccount> createState() => _ViewCreatedAccountState();
}

class _ViewCreatedAccountState extends State<ViewCreatedAccount> {
  String? _selectedCategory;
  late DatabaseHelper handler;

  @override
  void initState() {
    handler = DatabaseHelper();
    _fetchCategories();
    super.initState();
  }

  Future<void> _fetchCategories() async {
    final data = <String>['Debitor', 'Creditor', 'Income', 'Expense'];
    setState(() {
      if (data.isNotEmpty) {
        _selectedCategory = data.first;
      }
    });
  }

  Future<List<CreateAccountModel>> _fetchAccounts() async {
    if (_selectedCategory != null) {
      return handler.getAccountsByCategory(_selectedCategory!);
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ProfilePage()));
          },
        ),
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Created Accounts',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 30,
                    width: 90,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black)),
                    child: Center(
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        icon: const Icon(
                          Icons.sort,
                          color: Colors.deepPurple,
                        ),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        onChanged: (String? value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                        items: ['Debitor', 'Creditor', 'Income', 'Expense']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: FutureBuilder<List<CreateAccountModel>>(
                future: _fetchAccounts(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<CreateAccountModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return const Center(child: Text("No Data"));
                  } else if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else {
                    final items = snapshot.data ?? <CreateAccountModel>[];
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: InkWell(
                            child: Container(
                              height: displayHeight(context) * 0.15,
                              width: displayWidth(context),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  // ignore: prefer_const_literals_to_create_immutables
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(items[index].accountName),
                                      Text(items[index].accountPhone.toString())
                                    ],
                                  ),
                                  Text(
                                    items[index].accountCategory.toString(),
                                    style: TextStyle(color: Colors.deepPurple),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DataTables(
                                            category: '',
                                          )));
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
