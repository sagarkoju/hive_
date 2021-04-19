import 'package:flutter/material.dart';
import 'package:flutter_app_movie/widgets/boxes.dart';
import 'package:flutter_app_movie/widgets/transaction_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
class HiveScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, watch) {

    final transaction = watch(boxProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Hive Database'),
      ),
      body: transaction.isEmpty ? Center(child: Text('Loading....'),) :  Column(
        children: [
          SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: transaction.length,
              itemBuilder: ( context,  index) {
                final color = transaction[index].isExpense ? Colors.red : Colors
                    .green;
                final date = DateFormat.yMMMd().format(
                    transaction[index].createdDate);
                final amount = '\$' +
                    transaction[index].amount.toStringAsFixed(2);
                return Card(
                  color: Colors.white,
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.symmetric(
                        horizontal: 24, vertical: 8),
                    title: Text(
                      transaction[index].name,
                      maxLines: 2,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text('$date'),
                    trailing: Text(
                      amount,
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextButton.icon(
                              label: Text('Edit'),
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => TransactionDialog(transaction: transaction[index], index: index,),
                                );
                              }
                              ),
                            ),

                          Expanded(
                            child: TextButton.icon(
                              label: Text('Delete'),
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  context.read(boxProvider.notifier)
                                      .deleteTransaction(transaction[index], index),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () =>
            showDialog(
              context: context,
              builder: (context) =>
                  TransactionDialog(),
            ),
      ),
    );
  }
}
