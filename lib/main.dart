import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import './widgets/transaction_list.dart';
import '../models/transaction.dart';
import './widgets/new_transaction.dart';
import './widgets/chart.dart';
import './widgets/empty_state.dart';

void main() {
  // restrict UI in portrait mode
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              titleMedium: const TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
      ),
      home: const HomePage(title: 'Expense Tracker'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Transaction> _transactions = [];

  _addTranaction(String title, double amount, date) {
    final newTranx = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: date,
    );

    setState(() {
      _transactions.insert(0, newTranx);
    });
    // Hide ModalBottomSheet
    Navigator.pop(context);
  }

  _deleteTransaction(id) {
    setState(() {
      // _transactions.removeAt(index);
      _transactions.removeWhere((tx) => tx.id == id);
    });
  }

  void showAddNewTransactionModal(context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return NewTransaction(_addTranaction);
      },
    );
  }

  double get _totalExpense {
    return _transactions.fold(0.0, (sum, item) => sum + item.amount);
  }

  List<Transaction> get _recentTransactions {
    return _transactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          const Duration(days: 7),
        ),
      );
    }).toList();
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    double appbarHeight = MediaQuery.of(context).padding.top +
        kToolbarHeight; //kToolbarHeight is same as appBar.preferredSize.height

    double appBodyHeight = MediaQuery.of(context).size.height - appbarHeight;

    final appBar = AppBar(
      title: Text(widget.title),
      actions: [
        IconButton(
          onPressed: () => showAddNewTransactionModal(context),
          icon: const Icon(Icons.add),
        ),
      ],
    );

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(255, 244, 244, 244),
          child: Column(
            children: <Widget>[
              Switch(
                value: _showChart,
                onChanged: (val) {
                  setState(
                    () {
                      _showChart = val;
                    },
                  );
                },
              ),
              _showChart
                  ? Container(
                      padding:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      height: appBodyHeight * 0.3,
                      child: Chart(_recentTransactions, _totalExpense),
                    )
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10),
                      height: appBodyHeight * 0.7,
                      child: _transactions.isEmpty
                          ? const EmptyState()
                          : TransactionList(
                              _transactions,
                              _deleteTransaction,
                            ),
                    ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: IconButton(
          onPressed: () => showAddNewTransactionModal(context),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
