import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'adaptative_button.dart';
import 'adaptative_text_field.dart';
import 'adaptative_date_picker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import '../utils/extensions/string_extension.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime, String, String) onSubmit;

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
  final colorController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

// Métodos de ciclos de vida
//  _TransactionFormState() {
//    print('Constructor _TranasactionFormState');
//  }
//

static const colors = [
  Colors.blue,
  Colors.purple,
  Colors.red,
  Colors.yellowAccent,
  Colors.orange,
];

Color _selectedColor;
String _selectedCategory;

@override
  void initState() {
    super.initState();
    //print('InitState do _TransactionFormState');

  int i = Random().nextInt(5);
  _selectedColor = colors[i];
}

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
    final title = new StringExtension().capitalize(titleController.text);
    final value = double.tryParse(valueController.text) ?? 0.0;
    // final color = colorController.text;

    if (title.isEmpty || value <= 0 || _selectedDate == null || _selectedCategory == null) {

      Fluttertoast.showToast(msg:"Por favor informe os dados obrigatórios corretamente!", backgroundColor: Colors.red, textColor: Colors.white, toastLength: Toast.LENGTH_LONG, fontSize: 18);
      return;
    }

    widget.onSubmit(title, value, _selectedDate,_selectedColor.value.toRadixString(16),_selectedCategory);
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
                  label: 'Título(*)',
                ),
                AdaptativeTextField(
                  controller: valueController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onSubmitted: (_) => _submitForm(),
                  label: 'Valor(*) R\$',
                ),
                Container(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text("Informe uma categoria(*)"),
                      new Container(
                        padding: new EdgeInsets.all(2.5),
                      ),
                      new DropdownButton<String> (
                          hint: Text("Categoria"),
                          value: _selectedCategory,
                          items: <String>['Alimentação', 'Aluguel', 'Beleza', 'Carro', 'Cursos/Estudo', 'Finanças', 'Internet/Telecomunicação', 'Lazer', 'Mercado', 'Saúde', 'Transporte', 'Outros'].map((String value) {
                            return new DropdownMenuItem<String>( 
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String val) {
                            setState((){
                              _selectedCategory = val;
                            });
                          },
                        ),
                    ],
                  ),
                ),
                AdaptativeDatePicker(
                  selectedDate: _selectedDate,
                  onDateChanged: (newDate) {
                    setState(() {
                      _selectedDate = newDate;
                    });
                  },
                ),
                Container(
                  height: 120,
                  child: MaterialColorPicker(
                    onColorChange: (Color color) {
                      setState((){
                        _selectedColor = color;
                      });
                    },
                    selectedColor: _selectedColor,
                  ),
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
