import 'dart:ffi';

class Account {
  int? id;
  String? name;
  String? email;
  String? phoneNumber;
  Double? balance;
  DateTime? dateOfBirth;
  String? password;
  String? token;

  Account({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.balance,
    this.dateOfBirth,
    this.password,
    this.token,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      balance: json['balance'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']), // Correction
      password: json['password'],
      token: json['token'],
    );
  }
}
