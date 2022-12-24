import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;
  const TransactionList(this.transactions, this.deleteTransaction, {super.key});

  showAlertDialog(BuildContext context, id) {
    AlertDialog alert = AlertDialog(
      title: const Text("Delete!"),
      content: const Text("Are you sure want to delete the transaction?"),
      actions: [
        OutlinedButton(
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text("Continue"),
          onPressed: () {
            deleteTransaction(id);
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (ctx, index) {
        double amount = transactions[index].amount;
        String displayAmount =
            '₹ ${amount > 1000 ? '${(amount / 1000).toStringAsFixed(1)}K' : amount.toStringAsFixed(0)}';
        return Card(
          elevation: 5,
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: FittedBox(
                  child: Text(displayAmount),
                ),
              ),
            ),
            title: Text(
              transactions[index].title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              DateFormat.yMMMd().format(transactions[index].date),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              color: const Color.fromARGB(255, 241, 112, 103),
              onPressed: () => showAlertDialog(context, transactions[index].id),
            ),
          ),
        );
      },
      itemCount: transactions.length,
    );
  }
}
