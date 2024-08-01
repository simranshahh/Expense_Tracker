// class TransactionModel {
//   final int? id;
//   final int? fromid;
//   final String toid;
//   final int amount;
//   final String remarks;
//   final String createdAt;

//   TransactionModel({
//     this.id,
//     required this.fromid,
//     required this.toid,
//     required this.amount,
//     required this.remarks,
//     required this.createdAt,
//   });

//   factory TransactionModel.fromMap(Map<String, dynamic> json) =>
//       TransactionModel(
//         id: json["id"],
//         fromid: json["fromp_id"],
//         toid: json["to_id"],
//         amount: json["amount"],
//         remarks: json["remarks"],
//         createdAt: json["created_at"],
//       );

//   Map<String, dynamic> toMap() => {
//         "id": id,
//         "from_id": fromid,
//         "to_id": toid,
//         "amount": amount,
//         "remarks": remarks,
//         "created_at": createdAt,
//       };
// }


class TransactionModel {
  final int? id;
  final int userId;
  final int fromid;
  final String toid;
  final int amount;
  final String remarks;
  final String createdAt;

  TransactionModel({
    this.id,
    required this.userId,
    required this.fromid,
    required this.toid,
    required this.amount,
    required this.remarks,
    required this.createdAt,
  });

  // Method to convert a map to an TransactionModel object
  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] as int?,
      userId: map['user_id'],
      fromid: map['from_id'] ,
      toid: map['to_id'] ,
      amount: map['amount'] ,
      remarks: map['remarks'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  // Method to convert an TransactionModel object to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'from_id': fromid,
      'to_id': toid,
      'amount': amount,
      'remarks': remarks,
      'created_at': createdAt,
    };
  }
}
