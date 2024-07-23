// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myfinance/SQLite/sqlite.dart';
import 'package:myfinance/view/JsonModels/createaccount.dart';
import 'package:myfinance/view/JsonModels/transactionmodel.dart';

class DataTables extends StatefulWidget {
  final String category;
  const DataTables({Key? key, required this.category}) : super(key: key);

  @override
  State<DataTables> createState() => _DataTablesState();
}

class _DataTablesState extends State<DataTables> {
  late DatabaseHelper handler;
  late Future<List<CreateAccountModel>> accountData;
  late Future<List<TransactionModel>> transactionData;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHelper();
    accountData = handler.getAccountsByCategory(widget.category);
    transactionData = handler.gettransaction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.deepPurple,
        title: Center(
          child: Text(
            'Data Table',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        elevation: 4,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait([accountData, transactionData]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.red)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text('No data available',
                      style: TextStyle(fontSize: 18, color: Colors.grey)));
            } else {
              final List<CreateAccountModel> accounts = snapshot.data![0];
              final List<TransactionModel> transactions = snapshot.data![1];

              double balance = 0;
              List<DataRow> rows = transactions.map((transaction) {
                final fromAccount = accounts.firstWhere(
                    (account) => account.accountId == transaction.fromid,
                    orElse: () => CreateAccountModel(
                        accountName: "Unknown Account",
                        accountAddress: "N/A",
                        accountCategory: widget.category));
                final toAccount = accounts.firstWhere(
                    (account) => account.accountId == transaction.toid,
                    orElse: () => CreateAccountModel(
                        accountName: "Unknown Account",
                        accountAddress: "N/A",
                        accountCategory: widget.category));

                balance += transaction.amount;
                final DateFormat dateFormat = DateFormat('yy/MM/dd');

                return DataRow(
                  cells: [
                    DataCell(Text(dateFormat
                        .format(DateTime.parse(transaction.createdAt)))),
                    DataCell(Text(fromAccount.accountCategory ?? 'Unknown')),
                    DataCell(transaction.amount >= 0
                        ? Text(transaction.amount.toString())
                        : Text('')),
                    DataCell(transaction.amount < 0
                        ? Text((-transaction.amount).toString())
                        : Text('')),
                    DataCell(Text(balance.toStringAsFixed(2))),
                  ],
                );
              }).toList();

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 16,
                  headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.deepPurple.shade100),
                  headingTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade900),
                  dataTextStyle: TextStyle(color: Colors.deepPurple.shade800),
                  border: TableBorder.all(
                    color: Colors.deepPurple.shade200,
                    width: 1,
                  ),
                  columns: [
                    DataColumn(label: Text('DATE')),
                    DataColumn(label: Text('CATEGORY')),
                    DataColumn(label: Text('AMOUNT IN')),
                    DataColumn(label: Text('AMOUNT OUT')),
                    DataColumn(label: Text('BALANCE'), numeric: true),
                  ],
                  rows: rows,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
