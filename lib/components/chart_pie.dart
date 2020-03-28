import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:expenses/models/expense.dart';
import 'package:expenses/utils/extensions/contants.dart';

class ChartPie extends StatelessWidget {
  final List<Expense> anualTransactions;

  ChartPie(this.anualTransactions);

  List<Map<String, Object>> get CategoryTransactions {
    final List<Expense> orderedTransactions = anualTransactions;

    orderedTransactions.sort((a, b) => a.category.compareTo(b.category));

    DateTime now = new DateTime.now();
    var categories_label = new GlobalConstants().CATEGORIES;

    List categories = List.generate(categories_label.length, (index) {
      var d = new DateTime.now();

      double totalCategory = 0.0;
      String category = '';

      category = categories_label[index];
      var filtered = orderedTransactions.where((tr) =>
          tr.date.year == d.year &&
          tr.category == category &&
          tr.date.month == d.month);
      totalCategory = filtered.fold(0, (t, tr) => t + tr.value);

      return {'category': category, 'value': totalCategory};
    }).toList();

    categories.removeWhere((item) => item['value'] == 0);

    return categories;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = new Map();
    final List<Color> colorList = [];

    colorList.add(Colors.greenAccent);
    colorList.add(Colors.orangeAccent);
    colorList.add(Colors.blue);
    colorList.add(Colors.red);
    colorList.add(Colors.brown);
    colorList.add(Colors.pink);
    colorList.add(Colors.teal);

    CategoryTransactions.map((cat) {
      dataMap.putIfAbsent(cat['category'], () => cat['value']);
    }).toList();

    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: const EdgeInsets.all(11),
        child: SingleChildScrollView(
          child: PieChart(
            dataMap: dataMap,
            animationDuration: Duration(milliseconds: 800),
            chartLegendSpacing: 32.0,
            chartRadius: MediaQuery.of(context).size.width / 2.7,
            showChartValuesInPercentage: false,
            showChartValues: true,
            showChartValuesOutside: true,
            chartValueBackgroundColor: Colors.grey[200],
            colorList: colorList,
            showLegends: true,
            legendPosition: LegendPosition.right,
            decimalPlaces: 1,
            showChartValueLabel: true,
            initialAngle: 0,
            chartValueStyle: defaultChartValueStyle.copyWith(
              color: Colors.blueGrey[900].withOpacity(0.9),
            ),
            chartType: ChartType.disc,
          ),
        ),
      ),
    );
  }
}
