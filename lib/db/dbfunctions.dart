import 'dart:typed_data';

import 'package:expenses/models/expense.dart';
import 'package:expenses/db/databasehelper.dart';
import 'package:fluttertoast/fluttertoast.dart';
class DbFunctions{

  List expenses;
  var db = DatabaseHelper();

  Future createExpense(int id, String title,DateTime date, double value) async {
    var expense = Expense(id: id, title: title,value: value, date: date);
    await db.saveExpense(expense);
    Fluttertoast.showToast(msg:"Despesa Lançada!");
  }

  Future getAllExpenses() async{
    expenses = await db.getAllExpenses();
    expenses.forEach((expense) => print(expense));
  }

  Future updateExpense(int id,String title,double value, DateTime date) async{
    Expense updatedExpense =
    Expense.fromMap({'id': id, 'title': title, 'value': value, 'date': date});
    await db.updateExpense(updatedExpense);
  }

  Future delete(int id) async{
    await db.deleteExpense(id);
    expenses = await db.getAllExpenses();
    expenses.forEach((expense) => print(expense));
  }

}