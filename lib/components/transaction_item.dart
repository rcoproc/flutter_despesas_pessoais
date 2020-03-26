import 'dart:math';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../models/expense.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.tr,
    @required this.onRemove,
  }) : super(key: key);

  final Expense tr;
  final void Function(int p1) onRemove;

  @override
  _TransactionItemState createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {

  static const colors = [
    Colors.blue,
    Colors.purple,
    Colors.red,
    Colors.yellowAccent,
    Colors.orange,
  ];

  Color _backgroundColor;

  /// Construct a color from a hex code string, of the format RRGGBBB
  Color hexToColor(String code) {
   return new Color(int.parse(code.substring(0, 8), radix: 16) + 0xFF000000);
  }

  @override
  void initState() {
    super.initState();

    int i = Random().nextInt(5);
    _backgroundColor = colors[i];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: widget.tr.color.toString() == "null" ? _backgroundColor : hexToColor(widget.tr.color.trim()),
          radius: 30,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: FittedBox(
              child: Text(
                'R\$${widget.tr.value}',
                style: Theme.of(context).textTheme.title,
                ),
            ),
          ),
        ),
        title: Text(
          widget.tr.title,
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Row(
          children: <Widget>[
            Text(
              DateFormat('d MMM y').format(widget.tr.date),
            ),
            if(MediaQuery.of(context).size.width > 400)
              Row(
                children: <Widget>[
                  SizedBox(width: 100),
                  Text(
                    widget.tr.category,
                    style: TextStyle(
                      color: hexToColor(widget.tr.color),
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                  ),
                ],
              ),
          ],
        ),
        trailing: MediaQuery.of(context).size.width > 400
            ? FlatButton.icon(
          onPressed: () => widget.onRemove(widget.tr.id),
          icon: Icon(Icons.delete),
          label: Text('Excluir'),
          textColor: Theme.of(context).errorColor,
        )
            : IconButton(
          icon: Icon(Icons.delete),
          color: Theme.of(context).errorColor,
          onPressed: () => widget.onRemove(widget.tr.id),
        ),
      ),
    );
  }
}
