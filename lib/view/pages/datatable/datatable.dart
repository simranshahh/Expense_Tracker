// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:myfinance/SQLite/sqlite.dart';
import 'package:myfinance/view/JsonModels/createaccount.dart';
import 'package:myfinance/view/JsonModels/transactionmodel.dart';
import 'package:myfinance/utils/size_config.dart';

class DataTables extends StatefulWidget {
  const DataTables({Key? key}) : super(key: key);

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
    accountData = handler.getaccount();
    transactionData = handler.gettransaction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Center(
          child: Text(
            'Data Table',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([accountData, transactionData]),
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            final List<CreateAccountModel> accounts = snapshot.data![0];
            final List<TransactionModel> transactions = snapshot.data![1];

            double balance = 0;
            List<DataRow> rows = transactions.map((transaction) {
              final fromAccount = accounts.firstWhere(
                  (account) => account.accountId == transaction.fromid,
                  orElse: () => CreateAccountModel(
                      accountName: "account_name",
                      accountAddress: "account_address"));
              final toAccount = accounts.firstWhere(
                  (account) => account.accountId == transaction.toid,
                  orElse: () => CreateAccountModel(
                      accountName: "account_name",
                      accountAddress: "account_address"));

              balance += transaction.amount;

              return DataRow(
                cells: [
                  DataCell(Text(transaction.createdAt ?? 'N/A')),
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
    );
  }
}
