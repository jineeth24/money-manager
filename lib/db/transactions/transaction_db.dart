

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';

const TRANSACTION_DB_NAME="transaction_db";

abstract class TransactionDbFunction{
  Future<void>addTransaction(TransactionModel transaction);
  Future<List<TransactionModel>>getAllTransactions();
  Future<void>deleteTransaction(id);
}

class TransactionDb implements TransactionDbFunction{
  ValueNotifier<List<TransactionModel>>transactionListNotifier=ValueNotifier([]);

TransactionDb._internal();
static TransactionDb instance=TransactionDb._internal();
factory TransactionDb(){
  return instance;
}


  @override
  Future<void> addTransaction(TransactionModel transaction) async{
   final transactionBox=await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
  await transactionBox.put(transaction.id,transaction);
  refresh();
 
  }
  
  @override
  Future<List<TransactionModel>> getAllTransactions()async {
    final transactionBox=await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    return transactionBox.values.toList();
  }

 Future< void> refresh()async{
  final allTransactions= await getAllTransactions();
  allTransactions.sort((first,second)=>second.date.compareTo(first.date));
  transactionListNotifier.value.clear();
   await Future.forEach(allTransactions, (TransactionModel transaction)  {
  transactionListNotifier.value.add(transaction);
  transactionListNotifier.notifyListeners();
 });
 }
@override
 Future<void>deleteTransaction(id)async{
  final transactionBox=await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
  await transactionBox.delete(id);

   refresh();
  
 }
}