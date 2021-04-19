import 'package:flutter_app_movie/main.dart';
import 'package:flutter_app_movie/models/hive_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';


class Boxes {
  static Box<Transaction> getTransactions() =>
      Hive.box<Transaction>('transactions');

}

final boxProvider = StateNotifierProvider<HiveBox, List<Transaction>>((ref) => HiveBox(ref.read));


class HiveBox extends StateNotifier<List<Transaction>>{

  HiveBox(this.read) : super(read(boxA));
  final Reader read;

  Future addTransaction(String name, double amount, bool isExpense) async {
    Transaction transaction = Transaction(
        name: name,
        createdDate: DateTime.now(),
        amount: amount,
        isExpense: isExpense
    );

    final box = Boxes.getTransactions();
     box.add(transaction);
state = [...state, transaction];
  }


  void editTransaction(Transaction transaction, String name, double amount, bool isExpense, int index) {
    final editTrans = state[index];
    transaction.name = name;
    transaction.amount = amount;
    transaction.isExpense = isExpense;
    state = [
      for(final element in state)
        if(element == editTrans) transaction else element
    ];
    transaction.save();
  }

  void deleteTransaction(Transaction transaction, int index) {
    final remTrans = state[index];
state = state.where((element) => element != remTrans).toList();
    transaction.delete();

  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }


}


