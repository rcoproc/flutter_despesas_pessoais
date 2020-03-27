import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/expense.dart';
import 'chart_bar.dart';

class ChartMonth extends StatelessWidget {
  final List<Expense> anualTransactions;

  ChartMonth(this.anualTransactions);

  double _yearTotalValue()  {
    var _actualMonth = anualTransactions.where((tr){
      return tr.date.year == DateTime.now().year;
    });

    return _actualMonth.fold(0.0, (sum,tr) {
      return sum + tr.value;
    });
  }

  List<Map<String, Object>> get MonthTransactions {
    DateTime now = new DateTime.now();
    List month = List.generate(13, (index) {
      var d = new DateTime(now.year, index, now.day);

      double totalMonth = 0.0;

      for (var i = 0; i < anualTransactions.length; i++) {
        if (index > 0) {
          var date = anualTransactions[i].date;
          bool sameMonth = date.month == d.month;
          bool sameYear = date.year == d.year;

          double value = anualTransactions[i].value;
          if (sameMonth && sameYear) {
            totalMonth += value;
          }
        }
      }

      return {
        'month': index,
        'value': totalMonth
      };
    }).toList();

    month.removeWhere((item) => item['month'] == 0);
    if (now.month <= 6) {
      month.removeWhere((item) => item['month'] > 6);
    } else
    {
      month.removeWhere((item) => item['month'] < 6);
    }

    return month;
  }

  @override
  Widget build(BuildContext context) {

    return Card(
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(11),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: MonthTransactions.map((tr) {
              return Flexible(
                fit: FlexFit.tight,
                child: ChartBar(
                  label: tr['month'].toString(),
                  daymonth: tr['month'].toString(),
                  value: tr['value'],
                  percentage: _yearTotalValue() == 0 ? 0 : (tr['value'] as double) / _yearTotalValue(),
                )
              );
            }).toList()
          ),
        ));
  }
}
