import 'package:hive/hive.dart';
part  'hive_model.g.dart';

@HiveType(typeId: 0)
class Transaction extends HiveObject{
  @HiveField(0)
   String name;

  @HiveField(1)
   DateTime createdDate;

  @HiveField(2)
   bool isExpense = true;

  @HiveField(3)
   double amount;


  Transaction({this.amount, this.createdDate, this.isExpense, this.name});

}