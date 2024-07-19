// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:myfinance/utils/size_config.dart';
import 'package:myfinance/view/pages/bottomnavbar.dart';
import 'package:myfinance/view/pages/cashinpage.dart';
import 'package:myfinance/view/pages/cashoutpage.dart';

class INOUT extends StatefulWidget {
  const INOUT({super.key});

  @override
  State<INOUT> createState() => _INOUTState();
}

class _INOUTState extends State<INOUT> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Bottomnavbar()));
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: Text(
          'CASH IN/OUT',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12),
        child: Column(
          children: [
            Container(
              width: displayWidth(context),
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.deepPurple.withOpacity(.2)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CASH IN',
                    style: TextStyle(fontSize: 18),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CashInOrOut(isCashIn: true)));
                      },
                      icon: Icon(Icons.arrow_forward))
                ],
              ),
            ),
            Container(
              width: displayWidth(context),
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.deepPurple.withOpacity(.2)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CASH OUT',
                    style: TextStyle(fontSize: 18),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    CashInOrOut(isCashIn: false)));
                      },
                      icon: Icon(Icons.arrow_forward))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}












// // ignore_for_file: prefer_const_constructors, non_constant_identifier_names

// import 'package:flutter/material.dart';
// import 'package:myfinance/utils/size_config.dart';
// import 'package:myfinance/view/pages/bottomnavbar.dart';
// import 'package:myfinance/view/pages/cashinpage.dart';

// class INOUT extends StatefulWidget {
//   const INOUT({super.key});

//   @override
//   State<INOUT> createState() => _INOUTState();
// }

// class _INOUTState extends State<INOUT> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.deepPurple,
//         leading: IconButton(
//             onPressed: () {
//               Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (BuildContext context) => Bottomnavbar()));
//             },
//             icon: Icon(
//               Icons.arrow_back,
//               color: Colors.white,
//             )),
//         title: Text(
//           'CASH IN/OUT ',
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12),
//         child: Column(
//           children: [
//             Container(
//               width: displayWidth(context),
//               margin: const EdgeInsets.all(8),
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.deepPurple.withOpacity(.2)),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'CASH IN',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   IconButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (BuildContext context) => CashIn()));
//                       },
//                       icon: Icon(Icons.arrow_forward))
//                 ],
//               ),
//             ),
//             Container(
//               width: displayWidth(context),
//               margin: const EdgeInsets.all(8),
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   color: Colors.deepPurple.withOpacity(.2)),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'CASH OUT',
//                     style: TextStyle(fontSize: 18),
//                   ),
//                   IconButton(
//                       onPressed: () {
//                         Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                                 builder: (BuildContext context) => CashIn()));
//                       },
//                       icon: Icon(Icons.arrow_forward))
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
