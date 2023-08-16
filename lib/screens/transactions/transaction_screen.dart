import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transactions/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryDb.instance.refreshUI();
    TransactionDb.instance.refresh();
    return ValueListenableBuilder(
      valueListenable: TransactionDb.instance.transactionListNotifier,
      builder:
          (BuildContext context, List<TransactionModel> newlist, Widget? _) {
        return ListView.separated(
            padding: const EdgeInsets.all(15),
            itemBuilder: (context, index) {
              final data = newlist[index];
              return Slidable(
                key: Key(data.id),
                startActionPane: ActionPane(
                  motion:const ScrollMotion(), 
                  children: [
                  SlidableAction(
                    onPressed: (ctx) {
                      TransactionDb.instance.deleteTransaction(data.id);
                     
                    },
                    icon: Icons.delete,
                  ),
                ]),
                child: Card(
                  elevation: 5,
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 40,
                      backgroundColor: (data.type == CategoryType.income
                          ? Colors.green
                          : Colors.red),
                      child: Text(
                        parseDate(data.date),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    title: Text("${data.amount}"),
                    subtitle: Text(data.purpose),
                    
                  ),
                ),
              );
            },
            separatorBuilder: (context, inde) {
              return const SizedBox(
                height: 10,
              );
            },
            itemCount: newlist.length);
      },
    );
  }

  String parseDate(DateTime date) {
    final tempdate = DateFormat.MMMd().format(date);
    final splitedDate = tempdate.split(' ');
    return "${splitedDate.last}\n${splitedDate.first}";

    // return "${date.day}\n${date.month}";
  }
}
