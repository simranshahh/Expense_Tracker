//In here first we create the CreateAccountModel json model
// To parse this JSON data, do
//

class CreateAccountModel {
  final int? accountId;
  final String accountName;
  final String accountAddress;
  final String? accountPhone;
  final String? accountCategory;

  CreateAccountModel({
    this.accountId,
    required this.accountName,
    required this.accountAddress,
    this.accountPhone,
    this.accountCategory,
  });

  factory CreateAccountModel.fromMap(Map<String, dynamic> json) =>
      CreateAccountModel(
        accountId: json["account_id"],
        accountName: json["account_name"],
        accountAddress: json["account_address"],
        accountPhone: json["account_phone"],
        accountCategory: json["account_category"],
      );

  Map<String, dynamic> toMap() => {
        "account_id": accountId,
        "account_name": accountName,
        "account_address": accountAddress,
        "account_phone": accountPhone,
        "account_category": accountCategory,
      };
}
