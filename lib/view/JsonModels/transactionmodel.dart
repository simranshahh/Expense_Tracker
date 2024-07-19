class TransactionModel {
  final int? id;
  final int? fromid;
  final String toid;
  final int amount;
  final String remarks;
  final String createdAt;

  TransactionModel({
    this.id,
    required this.fromid,
    required this.toid,
    required this.amount,
    required this.remarks,
    required this.createdAt,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> json) =>
      TransactionModel(
        id: json["id"],
        fromid: json["fromp_id"],
        toid: json["to_id"],
        amount: json["amount"],
        remarks: json["remarks"],
        createdAt: json["created_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "from_id": fromid,
        "to_id": toid,
        "amount": amount,
        "remarks": remarks,
        "created_at": createdAt,
      };
}
