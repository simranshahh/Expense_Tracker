// // ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, unused_import

// import 'package:flutter/material.dart';
// import 'package:myfinance/SQLite/sqlite.dart';
// import 'package:myfinance/view/JsonModels/transactionmodel.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/sparkcharts.dart';

// class Chart extends StatefulWidget {
//   // ignore: prefer_const_constructors_in_immutables
//   Chart({Key? key}) : super(key: key);

//   @override
//   ChartState createState() => ChartState();
// }

// class ChartState extends State<Chart> {
//   late DatabaseHelper handler;
//   Future<List<TransactionModel>>? tData;
//   Future<Object>? totalExpenses;
//   List<_SalesData> data = [];

//   @override
//   void initState() {
//     super.initState();
//     handler = DatabaseHelper();

//     handler.initDB().whenComplete(() async {
//       tData = gettData();
//       totalExpenses = handler.getTotalExpenses();

//       List<TransactionModel> transactions = await tData!;
//       data = transactions
//           .map((trans) => _SalesData(trans.createdAt, trans.amount.toString().length))
//           .toList();

//       setState(() {});
//     });
//   }

//   Future<List<TransactionModel>> gettData() {
//     return handler.gettransaction();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(children: [
//           FutureBuilder<Object>(
//             future: totalExpenses,
//             builder: (context, snapshot) {
//               return SfCartesianChart(
//                 primaryXAxis: CategoryAxis(),
//                 title: ChartTitle(text: 'Half yearly sales analysis'),
//                 legend: Legend(isVisible: true),
//                 tooltipBehavior: TooltipBehavior(enable: true),
//                 series: <CartesianSeries<_SalesData, String>>[
//                   LineSeries<_SalesData, String>(
//                     dataSource: data,
//                     xValueMapper: (_SalesData sales, _) => sales.year,
//                     yValueMapper: (_SalesData sales, _) => sales.sales,
//                     name: 'Sales',
//                     dataLabelSettings: DataLabelSettings(isVisible: true),
//                   )
//                 ],
//               );
//             },
//           ),
//         ]),
//       ),
//     );
//   }
// }

// class _SalesData {
//   _SalesData(this.year, this.sales);

//   final String year;
//   final double sales;
// }
