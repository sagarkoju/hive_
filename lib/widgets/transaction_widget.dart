import 'package:flutter/material.dart';
import 'package:flutter_app_movie/models/hive_model.dart';
import 'package:flutter_app_movie/widgets/boxes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class TransactionDialog extends StatefulWidget {
  final Transaction transaction;
  final int index;

   TransactionDialog({ this.transaction,this.index});

  @override
  _TransactionDialogState createState() => _TransactionDialogState();
}

class _TransactionDialogState extends State<TransactionDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final amountController = TextEditingController();

  bool isExpense = true;

  @override
  void initState() {
    super.initState();

    if (widget.transaction != null) {
      final transaction = widget.transaction;
      nameController.text = transaction.name;
      amountController.text = transaction.amount.toString();
      isExpense = transaction.isExpense;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.transaction != null;
    final title = isEditing ? 'Edit Transaction' : 'Add Transaction';

    return AlertDialog(
      title: Text(title),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8),
              TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Name',
                  ),
                  validator: (val) {
                    if (val.isEmpty && val != null) {
                      return 'Enter a name';
                    }
                    return null;
                  }
              ),
              SizedBox(height: 8),
              TextFormField(
                  keyboardType: TextInputType.number,
                  controller: amountController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Amount',
                  ),
                  validator: (val) {
                    if (val.isEmpty && val != null) {
                      return 'Enter a valid number';
                    }
                    return null;
                  }
              ),
              SizedBox(height: 8),
              Column(
                children: [
                  RadioListTile<bool>(
                    title: Text('Expense'),
                    value: true,
                    groupValue: isExpense,
                    onChanged: (value) => setState(() => isExpense = value),
                  ),
                  RadioListTile<bool>(
                    title: Text('Income'),
                    value: false,
                    groupValue: isExpense,
                    onChanged: (value) => setState(() => isExpense = value),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop()
        ),
        Consumer(
          builder: (context, watch, child) => TextButton(
            child: Text(isEditing ? 'Edit' : 'Add'),
            onPressed: () async {
              final isValid = formKey.currentState.validate();
              if (isValid) {
                final name = nameController.text;
                final amount = double.tryParse(amountController.text) ?? 0;
                if(isEditing){
                  context.read(boxProvider.notifier).editTransaction(
                      widget.transaction, name,
                      amount, isExpense, widget.index);
                }else{
                  context.read(boxProvider.notifier).addTransaction(
                    name, amount, isExpense
                  );
                  }

                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ],
    );
  }

}