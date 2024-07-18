//In here first we create the users json model
// To parse this JSON data, do
//

class Users {
  final int? usrId;
  final String usrName;
  final String usrPassword;
  final String? usrPhone;
  final String? usrAddress;

  Users({
    this.usrId,
    required this.usrName,
    required this.usrPassword,
    this.usrPhone,
    this.usrAddress,
  });

  factory Users.fromMap(Map<String, dynamic> json) => Users(
        usrId: json["usrId"],
        usrName: json["usrName"],
        usrPassword: json["usrPassword"],
        usrPhone: json["usrPhone"],
        usrAddress: json["usrAddress"],
        // transaction: json["transaction"] == null ? null : TransactionModel.fromMap(json["transaction"]),
      );

  Map<String, dynamic> toMap() => {
        "usrId": usrId,
        "usrName": usrName,
        "usrPassword": usrPassword,
        "usrPhone": usrPhone,
        "usrAddress": usrAddress,
      };
}
