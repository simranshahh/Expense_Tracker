// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:myfinance/SQLite/sqlite.dart';
import 'package:myfinance/view/JsonModels/createaccount.dart';
import 'package:myfinance/view/JsonModels/transactionmodel.dart';
import 'package:myfinance/view/JsonModels/users.dart';
import 'package:myfinance/view/pages/bottomnavbar.dart';

class CashInOrOut extends StatefulWidget {
  final bool isCashIn;

  const CashInOrOut({Key? key, required this.isCashIn}) : super(key: key);

  @override
  State<CashInOrOut> createState() => _CashInOrOutState();
}

class _CashInOrOutState extends State<CashInOrOut> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  late DatabaseHelper _dbHelper;
  late Future<List<CreateAccountModel>> _accountsFuture;
  Users? currentUser;

  List<String> _fromDropdown = [];
  List<String> _toDropdown = [];

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _accountsFuture = _dbHelper.getaccount();
    _fetchAccountNames();
  }

  Future<void> _fetchAccountNames() async {
    List<CreateAccountModel> accounts = await _accountsFuture;
    setState(() {
      _fromDropdown = accounts.map((account) => account.accountName).toList();
      _toDropdown = accounts.map((account) => account.accountName).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.isCashIn ? 'Add Cash In' : 'Add Cash Out',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildDropdownField(
                  label: 'From       ',
                  controller: _fromController,
                  options: _fromDropdown,
                ),
                _buildDropdownField(
                  label: 'To           ',
                  controller: _toController,
                  options: _toDropdown,
                ),
                _buildTextField(
                  label: 'Amount  ',
                  controller: _amountController,
                  prefixText: widget.isCashIn ? '+' : '-',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Amount is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  label: 'Remarks',
                  controller: _remarksController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Remarks are required';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  prefixText: '',
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _handleSubmit,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required TextEditingController controller,
    required List<String> options,
  }) {
    return Row(
      children: [
        Text(
          '$label:',
          style: TextStyle(fontSize: 18),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.deepPurple.withOpacity(0.2),
            ),
            child: TextFormField(
              readOnly: true,
              controller: controller,
              validator: (value) {
                if (value!.isEmpty) {
                  return '$label is required';
                }
                return null;
              },
              decoration: InputDecoration(
                icon: Icon(Icons.person),
                border: InputBorder.none,
                hintText: label,
              ),
              onTap: () => _showOptions(context, options, controller),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String prefixText,
    required TextInputType keyboardType,
    FormFieldValidator<String>? validator,
  }) {
    return Row(
      children: [
        Text(
          '$label:',
          style: TextStyle(fontSize: 18),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.deepPurple.withOpacity(0.2),
            ),
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              validator: validator,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: label,
                prefixText: prefixText,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showOptions(BuildContext context, List<String> options,
      TextEditingController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select an Option'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(options[index]),
                  onTap: () {
                    setState(() {
                      controller.text = options[index];
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _handleSubmit() {
    if (formKey.currentState!.validate()) {
      if (_fromController.text == _toController.text) {
        // Show an error dialog if 'From' and 'To' are the same
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Validation Error'),
              content: Text('The "From" and "To" accounts cannot be the same.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      final double parsedAmount = double.parse(_amountController.text);

      final int amount =
          widget.isCashIn ? parsedAmount.round() : (-parsedAmount).round();

      final transaction = TransactionModel(
        userId: currentUser!.usrId.toString().length,
        fromid: _fromController.text.toString().length,
        toid: _toController.text,
        amount: amount,
        remarks: _remarksController.text,
        createdAt: DateTime.now().toString(),
      );

      _dbHelper.transactioncreate(transaction).whenComplete(() {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Submit'),
              content: Text('Submitted Successfully'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => Bottomnavbar(),
                      ),
                    );
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      });
    }
  }
}
