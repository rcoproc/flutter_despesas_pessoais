import 'package:flutter/material.dart';
import '../models/expense.dart';
import 'transaction_item.dart';

class TransactionList extends StatelessWidget {
  final List<Expense> transactions;
  final void Function(int) onRemove;

  TransactionList(this.transactions, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  Text(
                    'Nenhuma Transação Cadastrada!',
                    style: Theme.of(context).textTheme.title,
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              );
            },
          )
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              final tr = transactions[index];

              return TransactionItem(
                  key: GlobalObjectKey(tr),
                  tr: tr,
                  onRemove: onRemove
              );
            },
          );
    //   ListView(
    //   children: transactions.map((tr) {
    //     return TransactionItem(
    //       key: ValueKey(tr.id),
    //       tr: tr,
    //       onRemove: onRemove,
    //     );
    //   }).toList(),
    // );
  }
}

