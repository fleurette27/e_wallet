
class Account {
  int? id;
  String? name;
  String? email;
  String? phoneNumber;
  double? balance;
  DateTime? dob;
  String? token;

  Account({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.balance,
    this.dob,
    this.token,
  });

 factory Account.fromJson(Map<String, dynamic> json) {
  return Account(
    id: json['user']['id'],
    name: json['user']['name'] ?? '',
    email: json['user']['email'] ?? '',
    phoneNumber: json['user']['phoneNumber'] ?? '', 
    balance: double.parse(json['user']['balance'] ?? '0.00'), // Convertir en double
    dob: json['user']['dob'] != null ? DateTime.parse(json['user']['dob']) : null,
    token: json['token'] ?? '',
  );
}


}
