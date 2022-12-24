import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;
  final Color color;
  const ChartBar(
      this.label, this.spendingAmount, this.spendingPctOfTotal, this.color,
      {super.key});

  @override
  Widget build(BuildContext context) {
    String displayAmount =
        '₹ ${spendingAmount > 1000 ? '${(spendingAmount / 1000).toStringAsFixed(1)}K' : spendingAmount.toStringAsFixed(0)}';
    return Column(children: [
      Text(
        displayAmount,
        style: const TextStyle(fontSize: 16),
      ),
      const SizedBox(height: 10),
      Container(
        height: 60,
        width: 10,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                color: const Color.fromRGBO(220, 220, 220, 1),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            FractionallySizedBox(
              heightFactor: spendingPctOfTotal,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      Text(label,
          style: TextStyle(
            fontSize: 16,
            color: color,
            fontWeight: FontWeight.bold,
          )),
    ]);
  }
}
