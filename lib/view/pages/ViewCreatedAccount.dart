// ignore_for_file: prefer_const_constructors, file_names

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
  } //for account fetching

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
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
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: 40,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.deepPurple, width: 1.5),
                    ),
                    child: Center(
                      child: DropdownButton<String>(
                        value: _selectedCategory,
                        icon: const Icon(Icons.sort, color: Colors.deepPurple),
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: FutureBuilder<List<CreateAccountModel>>(
                future: _fetchAccounts(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<CreateAccountModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        "No Accounts Available",
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Error: ${snapshot.error}",
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    final items = snapshot.data ?? <CreateAccountModel>[];
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          DataTables(
                                            category: _selectedCategory ?? '',
                                          )));
                            },
                            child: Container(
                              height: displayHeight(context) * 0.12,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.4),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            items[index].accountName,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.deepPurple,
                                            ),
                                          ),
                                          Text(
                                            items[index]
                                                .accountPhone
                                                .toString(),
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[700],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      items[index].accountCategory.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
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
            ),
          ),
        ],
      ),
    );
  }
}
