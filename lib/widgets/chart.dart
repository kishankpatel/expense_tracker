import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final double totalExpense;
  const Chart(this.recentTransactions, this.totalExpense, {super.key});

  final List<Transaction> recentTransactions;

  List<Map<String, Object>> get groupedTransaction {
    const List<Color> colors = [
      Colors.teal,
      Colors.purple,
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.pink,
      Colors.brown,
    ];
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;
      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum,
        'color': colors[index],
      };
    });
  }

  double get totalSpending {
    return groupedTransaction.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Card(
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  'Total: ${totalExpense.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: groupedTransaction.map((data) {
                  double spendingPercent = totalSpending == 0.0
                      ? 0.0
                      : (data['amount'] as double) / totalSpending;
                  return Flexible(
                    fit: FlexFit.tight,
                    child: ChartBar(
                      data['day'] as String,
                      data['amount'] as double,
                      spendingPercent,
                      data['color'] as Color,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
