import 'package:flutter/material.dart';
import 'adaptative_button.dart';
import 'adaptative_text_field.dart';
import 'adaptative_date_picker.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  TransactionForm(this.onSubmit){
    // print('Constructor TransactionForm');
  }

  @override
  _TransactionFormState createState() {
    // print('createState TransactionForm');
    return _TransactionFormState();
  }
}

class _TransactionFormState extends State<TransactionForm> {
  final titleController = TextEditingController();
  final valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

// Métodos de ciclos de vida
//  _TransactionFormState() {
//    print('Constructor _TranasactionFormState');
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    print('InitState do _TransactionFormState');
//  }
//
//  @override
//  void didUpdateWidget(Widget oldWidget) {
//    widget -> novo Widget a ser atualizado;
//    super.didUpdateWidget(oldWidget);
//    print('didUpdateWidget do _TransactionFormState');
//  }
//
//  @override
//  void dispose() {
//    super.dispose();
//    print('dispose do _TransactionFormState');
//  }

  _submitForm() {
    final title = titleController.text;
    final value = double.tryParse(valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0 || _selectedDate == null) {
      return;
    }

    widget.onSubmit(title, value, _selectedDate);
  }

  _showDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
              bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Column(
              children: <Widget>[
                AdaptativeTextField(
                  controller: titleController,
                  onSubmitted: (_) => _submitForm(),
                  label: 'Título',
                ),
                AdaptativeTextField(
                  controller: valueController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (_) => _submitForm(),
                  label: 'Valor (R\$)',
                ),
                AdaptativeDatePicker(
                  selectedDate: _selectedDate,
                  onDateChanged: (newDate) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    AdaptativeButton(
                      label: 'Nova Transação',
                      onPressed: _submitForm,
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
