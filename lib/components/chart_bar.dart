import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final String daymonth;
  final double value;
  final double percentage;

  ChartBar({
    this.label,
    this.daymonth,
    this.value,
    this.percentage,
  });

  String pt_label(String weekDay) {
    int month;
    if (weekDay.length <= 2) {
      month = int.parse(weekDay);
    } else {
      month = 0;
    }

    if (weekDay.length <= 2 && month > 0) {
      switch(month) {
        case 1: return 'jan'; break;
        case 2: return 'fev'; break;
        case 3: return 'mar'; break;
        case 4: return 'abr'; break;
        case 5: return 'mai'; break;
        case 6: return 'jun'; break;
        case 7: return 'jul'; break;
        case 8: return 'ago'; break;
        case 9: return 'set'; break;
        case 10: return 'out'; break;
        case 11: return 'nov'; break;
        case 12: return 'dez'; break;
        default: '';
      }

    } else {
      switch(weekDay) {
        case 'Sunday': return 'dom'; break;
        case 'Monday': return 'seg'; break;
        case 'Tuesday': return 'ter'; break;
        case 'Wednesday': return 'qua'; break;
        case 'Thursday': return 'qui'; break;
        case 'Friday': return 'sex'; break;
        case 'Saturday': return 'sab'; break;
        default: '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: <Widget>[
            Container(
              height: constraints.maxHeight * 0.10,
              child: FittedBox(child: Text('${value.toStringAsFixed(2)}')),
            ),
            SizedBox(height: constraints.maxHeight * 0.02),
            Container(
              height: constraints.maxHeight * 0.6,
              width: 10,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  FractionallySizedBox(
                      heightFactor: percentage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ))
                ],
              ),
            ),
            SizedBox(height: constraints.maxHeight * 0.02),
            Container(
              height: constraints.maxHeight * 0.07,
              child: FittedBox(child: Text(daymonth)),
            ),
            Container(
                height: constraints.maxHeight * 0.15,
                child: FittedBox(child: Text('${ pt_label(label) }'))),
          ],
        );
      },
    );
  }
}
