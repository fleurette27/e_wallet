import 'package:flutter/material.dart';
import 'package:mobile_payement_app/constant.dart';
import 'package:mobile_payement_app/models/account.dart';
import 'package:mobile_payement_app/models/api_response.dart';
import 'package:mobile_payement_app/models/transaction.dart';
import 'package:mobile_payement_app/pages/deposit.dart';
import 'package:mobile_payement_app/pages/retrait.dart';
import 'package:mobile_payement_app/pages/sign_up.dart';
import 'package:mobile_payement_app/pages/transaction_history.dart';
import 'package:mobile_payement_app/pages/transfert.dart';
// import 'package:mobile_payement_app/pages/withdraw.dart';
import 'package:mobile_payement_app/services/account_service.dart';
import 'package:mobile_payement_app/services/transactions_service.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  String? balance;
  Account? user;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    ApiResponse response = await getUserDetail();
    if (response.error == null) {
      setState(() {
        user = response.data as Account;
        balance = user!.balance != null ? user!.balance.toString() : '0';
      });
    } else if (response.error == unauthorized) {
      logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const SignUpScreen()),
                (route) => false)
          });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              BalanceContainer(balance: balance),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              const Expanded(
                child: TransactionsContainer(),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25 - 30,
            left: 20,
            right: 20,
            child: const ButtonRow(),
          ),
        ],
      ),
    );
  }
}

class BalanceContainer extends StatelessWidget {
  final String? balance;

  const BalanceContainer({super.key, this.balance});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.blue[900]
          : Colors.green[800],
      child: Center(
        child: Text(
          ' Balance : $balance ',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ButtonRow extends StatelessWidget {
  const ButtonRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ActionButton(
          icon: Icons.add,
          label: 'Dépôt',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const Deposit()),
            );
          },
        ),
        ActionButton(
          icon: Icons.send,
          label: 'Transfert',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const Transfer()),
            );
          },
        ),
        ActionButton(
          icon: Icons.money_off,
          label: 'Retrait',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const RetraitPage()),
            );
          },
        ),
      ],
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: IconButton(
            icon: Icon(icon),
            onPressed: onPressed,
            iconSize: 40,
          ),
        ),
        const SizedBox(height: 5),
        Text(label),
      ],
    );
  }
}

class TransactionsContainer extends StatelessWidget {
  const TransactionsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      //  height: MediaQuery.of(context).size.height * 0.5,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transactions récentes',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const TransactionHistory()),
                  );
                },
                child: const Text('Voir plus'),
              ),
            ],
          ),
          const Expanded(child: TransactionList()),
        ],
      ),
    );
  }
}

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: getRecenteTransactions(),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(
              child: Text("Échec du chargement des transactions ou Aucune transaction trouvée"));
        } else {
          List<Transaction> transactions = (snapshot.data as List<dynamic>)
              .map((transactionJson) => Transaction.fromJson(transactionJson))
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


// class ApiResponse {
//   final dynamic data;
//   final String? error;

//   ApiResponse({this.data, this.error});
// }

// Future<ApiResponse> getUserDetail() async {
//   // Simulated API call
//   await Future.delayed(const Duration(seconds: 1));
//   return ApiResponse(data: Account(balance: 5000.0));
// }

// class Account {
//   final double balance;

//   Account({required this.balance});
// }

// Future<List<Transaction>> getTransactions() async {
 
//   await Future.delayed(const Duration(seconds: 1));
//   return [
//     Transaction(accountNumber: '123456789', title: 'Achat', amount: 150.0, date: DateTime.now()),
//     Transaction(accountNumber: '123456789', title: 'Paiement', amount: 300.0, date: DateTime.now().subtract(const Duration(days: 1))),
//     Transaction(accountNumber: '123456789', title: 'Vente', amount: 450.0, date: DateTime.now().subtract(const Duration(days: 2))),
//   ];
// }

