import 'package:flutter/foundation.dart';

class Expense {
  int id;
  String title;
  double value;
  DateTime date;
  String color;

  Expense({
    this.id,
    @required this.title,
    @required this.value,
    @required this.date,
    this.color,
  });

  Expense.map(dynamic obj) {
    this.id = obj['id'];
    this.title = obj['title'];
    this.value = obj['value'];
    this.date = obj['date'];
    this.color = obj['color'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    if (id!= null) {
      map['id'] = id;
    }
    map['title'] = title;
    map['value'] = value;
    map['date'] = date.toString();
    map['color'] = color;

    return map;
  }

  Expense.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.value = map['value'];
    this.date = map['date'];
    this.color = map['color'];
  }
}