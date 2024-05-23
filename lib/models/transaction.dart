class Transaction {
  final int id;
  final String title;
  final double amount;
  final DateTime date;
  final String userName;
  final String accountNumber;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.userName,
    required this.accountNumber,

  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      userName: json['user']['name'],
      accountNumber:json['user']['account_number'],
    );
  }
}
