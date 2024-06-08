class Account {
  int? id;
  String? name;
  String? surname;
  String? email;
  String? phoneNumber;
  double? balance;
  String? token;

  Account({
    this.id,
    this.name,
    this.surname,
    this.email,
    this.phoneNumber,
    this.balance,
    this.token,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['user']['id'],
      name: json['user']['name'] ?? '',
      surname: json['user']['surname'] ?? '',
      email: json['user']['email'] ?? '',
      phoneNumber: json['user']['phoneNumber'] ?? '',
      balance: double.parse(json['user']['balance'] ?? '0.00'), // Convertir en double
      token: json['token'] ?? '',
    );
  }
}
