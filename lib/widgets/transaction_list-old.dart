import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTransaction;
  const TransactionList(this.transactions, this.deleteTransaction, {super.key});

  showAlertDialog(BuildContext context, index) {
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
            deleteTransaction(index);
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
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      color: const Color.fromARGB(255, 208, 237, 245),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      height: 500,
      child: ListView.builder(
        itemBuilder: (ctx, index) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            color: const Color.fromARGB(255, 241, 247, 255),
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: const Color.fromARGB(255, 116, 150, 43),
                    ),
                  ),
                  child: Text(
                    '₹ ${transactions[index].amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 116, 150, 43),
                      fontSize: 12,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(transactions[index].title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 52, 139, 168),
                          )),
                      Text(
                        DateFormat.yMMMd()
                            .add_jm()
                            .format(transactions[index].date),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => showAlertDialog(context, index),
                  color: const Color.fromARGB(255, 163, 77, 74),
                  tooltip: 'Delete',
                )
              ],
            ),
          );
        },
        itemCount: transactions.length,
      ),
    );
  }
}
