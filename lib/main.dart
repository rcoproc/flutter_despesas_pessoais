import 'package:expenses/components/transaction_form.dart';
import 'package:expenses/db/databasehelper.dart';
import 'package:expenses/db/dbfunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter/services.dart';

import 'dart:io';
import 'package:intl/intl.dart';
import 'components/transaction_form.dart';
import 'components/transaction_list.dart';
import 'components/chart.dart';
import 'components/chart_month.dart';
import 'components/chart_pie.dart';
import 'models/expense.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    SystemChrome.setPreferredOrientations(([
//      DeviceOrientation.portraitUp
//    ]));
    return MaterialApp(
        home: MyHomePage(),
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.amber,
            fontFamily: 'Quicksand',
            textTheme: ThemeData.light().textTheme.copyWith(
                // ignore: deprecated_member_use
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                button: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
            appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                      // ignore: deprecated_member_use
                      title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  )),
            )));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  List<Expense> _transactions = [];
  bool _showChart = false;
  final oCcy = new NumberFormat("#,##0.00", "pt_BR");

  var db = new DatabaseHelper();
  var dbFunctions = DbFunctions();

  @override
  void initState() {
    super.initState();

    dbFunctions.getAllExpenses().then((data) { 
      dbFunctions.expenses.forEach((element) {
        var parsedDate = DateTime.parse(element.row[3]);
        Expense ex = Expense(id: element.row[0], 
                             title: element.row[1], 
                             value: element.row[2].toDouble(), 
                             date: parsedDate, 
                             color: element.row[4], 
                             category: element.row[5]);

        setState(() {
          _transactions.add(ex);
        });
      });

    }).catchError((e) {
      Fluttertoast.showToast(msg:"Erro ao buscar Despesas: ${e}!", backgroundColor: Colors.red);
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    print('didChangeAppLifecycleState MyHomePageState');
  }

  List<Expense> get _recentTransactions {
    return _transactions.where((tr) {
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  double _getWeekTotalValue()  {
    return _recentTransactions.fold(0.0, (sum,tr) {
      return sum + tr.value;
    });
  }

  double _getMonthTotalValue()  {
    var _actualMonth = _transactions.where((tr){
      return tr.date.month == DateTime.now().month;
    });

    return _actualMonth.fold(0.0, (sum,tr) {
      return sum + tr.value;
    });
  }


  _addTransaction(String title, double value, DateTime date, String color, String category) {
    // get the biggest id in the table
    DatabaseHelper().getNextId().then((int id) { 
      int _id = id;

      if (_id > 0) {
        final newTransaction = Expense(
          id: _id,
          title: title,
          value: value,
          date: date,
          color: color,
          category: category,
        );

        setState(() {
          dbFunctions.createExpense(_id, title, date, value, color, category);
          _transactions.add(newTransaction);
        });
      }

      Navigator.of(context).pop();
    }).catchError((e) {
      Fluttertoast.showToast(msg:"Erro ao incluir registro: ${e}!", backgroundColor: Colors.red);
    });
  }

  _removeTransaction(int id) {
    setState(() {
      _transactions.removeWhere((tr) => tr.id == id);
      dbFunctions.delete(id);
    });
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  Widget _getIconButton(IconData icon, Function fn) {
    return Platform.isIOS
        ? GestureDetector(onTap: fn, child: Icon(icon))
        : IconButton(icon: Icon(icon), onPressed: fn);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final iconList = Platform.isIOS ? CupertinoIcons.refresh : Icons.list;
    final chartList = Platform.isIOS ? CupertinoIcons.refresh : Icons.show_chart;

    final actions = <Widget>[
      if (isLandscape)
        _getIconButton(
          _showChart ? iconList : chartList,
          () {
            setState(() {
              _showChart = !_showChart;
            });
          },
        ),
      _getIconButton(
        Platform.isIOS ? CupertinoIcons.add :Icons.add,
        () => _openTransactionFormModal(context),
      ),
    ];

    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Despesas Pessoais'),
            trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: actions
            ),
          )
        : AppBar(
            title: Text(
              'Despesas Pessoais',
              style: TextStyle(
                fontFamily: 'OpenSans',
              ),
            ),
            actions: actions,
          );

    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    final bodyPage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
//                Text('Exibir Gráfico'),
//                Switch.adaptive(
//                    activeColor: Theme.of(context).accentColor,
//                    value: _showChart,
//                    onChanged: (value) {
//                  setState(() {
//                    _showChart = value;
//                  });
//                }),
                ],
              ),
            if (_showChart || !isLandscape)
              Container(
                height: availableHeight * (isLandscape ? 0.8 : 0.3),
                child: ListView( 
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    Container(
                      width:  360,
                      child: Chart(_recentTransactions)
                    ),
                    Container(
                      width: 360,
                      child: ChartMonth(_transactions)
                    ),
                    Container(
                      width: 360,
                      child: ChartPie(_transactions)
                    ),
                  ]
                  ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                  Row(
                      children: <Widget>[
                    Text('T. Semana: R\$ ${oCcy.format(_getWeekTotalValue())}')
                    ]
                  ),
                  Row(children: <Widget>[
                    Text('T. Mes: R\$ ${oCcy.format(_getMonthTotalValue())}')
                    ]
                  ),
                  ]
                )
              ),
            if (!_showChart || !isLandscape)
              Container(
                height: availableHeight * (isLandscape ? 1 : 0.7),
                child: TransactionList(_transactions, _removeTransaction),
              ),
          ],
        ),
      )
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar,
            child: bodyPage,
          )
        : Scaffold(
            appBar: appBar,
            body: bodyPage,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _openTransactionFormModal(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
