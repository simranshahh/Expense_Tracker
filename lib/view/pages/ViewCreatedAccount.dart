// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, unused_field

// import 'package:flutter/material.dart';
// import 'package:myfinance/SQLite/sqlite.dart';
// import 'package:myfinance/utils/size_config.dart';
// import 'package:myfinance/view/JsonModels/createaccount.dart';
// import 'package:myfinance/view/pages/datatable/individualdata.dart';
// import 'package:myfinance/view/pages/profilepage.dart';

// class ViewCreatedAccount extends StatefulWidget {
//   const ViewCreatedAccount({super.key});

//   @override
//   State<ViewCreatedAccount> createState() => _ViewCreatedAccountState();
// }

// List<String> dropdown = <String>['Debitor', 'Creditor', 'Income', 'Expense'];

// class _ViewCreatedAccountState extends State<ViewCreatedAccount> {
//   // List<String> _categories = [];
//   String? _selectedCategory;

//   Future<void> _fetchCategories() async {
//     final dbHelper = DatabaseHelper();
//     // final data = await dbHelper.getSortedCategories();
//     final data = dropdown;
//     setState(() {
//       dropdown = data;
//       if (dropdown.isNotEmpty) {
//         _selectedCategory = dropdown.first;
//       }
//     });
//   }

//   late DatabaseHelper handler;
//   late Future<List<CreateAccountModel>> adata;

//   @override
//   void initState() {
//     handler = DatabaseHelper();
//     adata = handler.getaccount();

//     handler.initDB().whenComplete(() {
//       adata = getadata();
//     });
//     _fetchCategories();

//     super.initState();
//   }

//   Future<List<CreateAccountModel>> getadata() {
//     return handler.getaccount();
//   }

//   String dropdownValue = dropdown.first;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (BuildContext context) => ProfilePage()));
//           },
//         ),
//         backgroundColor: Colors.deepPurple,
//         title: Text(
//           'Created Accounts',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         actions: [],
//       ),
//       body: Column(
//         children: [
//           SizedBox(
//             height: 50,
//             child: Padding(
//               padding: const EdgeInsets.only(right: 8.0, bottom: 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   Container(
//                     height: 30,
//                     width: 90,
//                     decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: Colors.black)),
//                     child: Center(
//                       child: DropdownButton<String>(
//                         value: dropdownValue,

//                         icon: const Icon(
//                           Icons.sort,
//                           color: Colors.deepPurple,
//                         ),
//                         elevation: 16,
//                         style: const TextStyle(color: Colors.white),
//                         // underline: Container(
//                         //   height: 2,
//                         //   color: Colors.white,
//                         // ),
//                         onChanged: (String? value) {
//                           setState(() {
//                             dropdownValue = value!;
//                           });
//                         },
//                         items: dropdown
//                             .map<DropdownMenuItem<String>>((String value) {
//                           return DropdownMenuItem<String>(
//                             value: value,
//                             child: Text(
//                               value,
//                               style: TextStyle(color: Colors.deepPurple),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12.0),
//               child: Expanded(
//                 child: FutureBuilder<List<CreateAccountModel>>(
//                     future: adata,
//                     builder: (BuildContext context,
//                         AsyncSnapshot<List<CreateAccountModel>> snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const CircularProgressIndicator();
//                       } else if (snapshot.hasData && snapshot.data!.isEmpty) {
//                         return const Center(child: Text("No data"));
//                       } else if (snapshot.hasError) {
//                         return Text(snapshot.error.toString());
//                       } else {
//                         final items = snapshot.data ?? <CreateAccountModel>[];

//                         return ListView.builder(
//                           itemCount: items.length,
//                           itemBuilder: (BuildContext context, index) {
//                             return Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(vertical: 5.0),
//                               child: InkWell(
//                                 child: Container(
//                                   height: displayHeight(context) * 0.15,
//                                   width: displayWidth(context),
//                                   decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(12),
//                                       boxShadow: [
//                                         BoxShadow(
//                                             color: Colors.grey, blurRadius: 0.1)
//                                       ]),
//                                   child: Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                     children: [
//                                       CircleAvatar(
//                                         radius: 25,
//                                         backgroundImage: NetworkImage(
//                                           'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
//                                         ),
//                                       ),
//                                       Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(dropdown[index].toString()),
//                                           Text(items[index]
//                                               .accountPhone
//                                               .toString())
//                                         ],
//                                       ),
//                                       Text(
//                                         items[index].accountCategory.toString(),
//                                         style:
//                                             TextStyle(color: Colors.deepPurple),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                                 onTap: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (BuildContext context) =>
//                                               IndividualDataPage()));
//                                 },
//                               ),
//                             );
//                           },
//                         );
//                       }
//                     }),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, constant_identifier_names, file_names

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

List<String> dropdown = <String>['Debitor', 'Creditor', 'Income', 'Expense'];

class _ViewCreatedAccountState extends State<ViewCreatedAccount> {
  String? _selectedCategory;

  Future<void> _fetchCategories() async {
    final dbHelper = DatabaseHelper();
    final data = await dbHelper.getSortedCategories();
    setState(() {
      dropdown = data;
      if (dropdown.isNotEmpty) {
        _selectedCategory = dropdown.first;
      }
    });
  }

  late DatabaseHelper handler;
  late Future<List<CreateAccountModel>> adata;

  @override
  void initState() {
    handler = DatabaseHelper();
    adata = handler.getaccount();

    handler.initDB().whenComplete(() {
      adata = getadata();
    });
    _fetchCategories();

    super.initState();
  }

  Future<List<CreateAccountModel>> getadata() {
    return handler.getaccount();
  }

  Widget _buildContainerForCategory(String category) {
    switch (category) {
      case 'Debitor':
        return Container(
          color: Colors.blue,
          child: Center(child: Text('Debitor')),
        );
      case 'Creditor':
        return Container(
          color: Colors.green,
          child: Center(child: Text('Creditor')),
        );
      case 'Income':
        return Container(
          color: Colors.yellow,
          child: Center(child: Text('Income')),
        );
      case 'Expense':
        return Container(
          color: Colors.red,
          child: Center(child: Text('Expense')),
        );
      default:
        return Container(
          color: Colors.grey,
          child: Center(child: Text('Select a category')),
        );
    }
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
                        items: dropdown
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
                  future: adata,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<CreateAccountModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                      return const Center(child: Text("No data"));
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      final items = snapshot.data ?? <CreateAccountModel>[];

                      return Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (BuildContext context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: InkWell(
                                    child: Container(
                                      height: displayHeight(context) * 0.15,
                                      width: displayWidth(context),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 0.1)
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
                                              Text(items[index].accountName),
                                              Text(items[index]
                                                  .accountPhone
                                                  .toString())
                                            ],
                                          ),
                                          Text(
                                            items[index]
                                                .accountCategory
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.deepPurple),
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  DataTables()));
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                          if (_selectedCategory != null)
                            _buildContainerForCategory(_selectedCategory!),
                        ],
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class Constants {
  static const String FirstItem = 'First Item';
  static const String SecondItem = 'Second Item';
  static const String ThirdItem = 'Third Item';

  static const List<String> choices = <String>[
    FirstItem,
    SecondItem,
    ThirdItem,
  ];
}

void choiceAction(String choice) {
  if (choice == Constants.FirstItem) {
    print('I First Item');
  } else if (choice == Constants.SecondItem) {
    print('I Second Item');
  } else if (choice == Constants.ThirdItem) {
    print('I Third Item');
  }
}
