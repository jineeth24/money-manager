import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';

class ExpenseCategoryList extends StatelessWidget {
  const ExpenseCategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CategoryDb().expenseListNotifier,
      builder: (context, newList, child) {
        return ListView.separated(
            itemBuilder: (ctx, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                      title: Text(" ${newList[index].name}"),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => CategoryDb.instance.deleteCategory(newList[index].id),
                      )),
                ),
              );
            },
            separatorBuilder: (ctx, index) {
              return const SizedBox(
                height: 10,
              );
            },
            itemCount: newList.length);
      },
    );
  }
}
