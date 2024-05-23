import 'package:flutter/material.dart';
import 'package:mobile_payement_app/models/transaction.dart';
import 'package:mobile_payement_app/services/transactions_service.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        margin: const EdgeInsets.all(20),
        child: FutureBuilder<dynamic>(
          future: getTransactions(),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text("Échec du chargement des transactions"));
            } else {
              List<Transaction> transactions = (snapshot.data as List<dynamic>)
                  .map((transactionJson) =>
                      Transaction.fromJson(transactionJson))
                  .toList();

              if (transactions.isEmpty) {
                return const Center(
                  child: Text(
                    "Aucune transaction trouvée",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return TransactionCard(
                      accountNumber: transaction.accountNumber,
                      accountName: transaction.title,
                      amount: transaction.amount,
                      date: transaction.date,
                    );
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final String accountNumber;
  final String accountName;
  final double amount;
  final DateTime date;

  const TransactionCard({
    super.key,
    required this.accountNumber,
    required this.accountName,
    required this.amount,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
         leading: const Icon(
              Icons.account_circle,
              
        ),
        title: Text(accountName),
        subtitle:
            Text('Numéro de compte: $accountNumber\nDate: ${date.toLocal()}'),
        trailing: Text('$amount FCFA'),
      ),
    );
  }
}
