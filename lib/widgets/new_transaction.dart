import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTransction;
  const NewTransaction(this.addTransction, {super.key});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  var selectedDate;
  bool showDateError = false;

  void resetFields() {
    titleController.clear();
    amountController.clear();
  }

  void _submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.tryParse(amountController.text) ?? 0.0;
    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }
    if (selectedDate == null) {
      setState(() {
        showDateError = true;
      });
      return;
    }
    widget.addTransction(enteredTitle, enteredAmount, selectedDate);
    resetFields();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime.now(),
    ).then(
      (pickedDate) => {
        if (pickedDate != null)
          {
            setState(() {
              selectedDate = pickedDate;
            })
          }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: Colors.white,
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(labelText: 'Title'),
            onSubmitted: (_) => _submitData(),
          ),
          TextField(
            keyboardType: TextInputType.number,
            controller: amountController,
            decoration: const InputDecoration(labelText: 'Amount'),
            onSubmitted: (_) => _submitData(),
          ),
          Container(
            height: 70,
            child: Row(
              children: [
                Expanded(
                  child: Text(selectedDate == null
                      ? 'No Date Chosen!'
                      : 'Picked Date: ${DateFormat.yMd().format(selectedDate)}'),
                ),
                TextButton(
                  onPressed: _presentDatePicker,
                  child: const Text('Choose Date'),
                ),
              ],
            ),
          ),
          if (showDateError)
            Text(
              'Please choose a date',
              style: TextStyle(color: Theme.of(context).errorColor),
            ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: _submitData,
                  child: const Text('Add Transaction'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
