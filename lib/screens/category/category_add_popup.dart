import 'package:flutter/material.dart';

import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/models/category/category_model.dart';

ValueNotifier<CategoryType> selectedCategoryNotifier =
    ValueNotifier(CategoryType.income);

Future<void> showCategoryAddPopup(BuildContext context) async {
  final nameEditingController = TextEditingController();
  showDialog(
    context: context,
    builder: (ctx) {
      return SimpleDialog(
        title:const Text("add Category"),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: nameEditingController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text("category name"),
              ),
            ),
          ),
       const   Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                PopupRadioButton(
                  title: "Income",
                  type: CategoryType.income,
                ),
                PopupRadioButton(
                  title: "Expense",
                  type: CategoryType.expense,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
                onPressed: () {
                  final name = nameEditingController.text;
                  if (name.isEmpty) {
                    return;
                  }
                  final type = selectedCategoryNotifier.value;
                  final category = CategoryModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: name,
                      type: type);

                  CategoryDb().insertCategory(category);
                
                  Navigator.of(ctx).pop();
                },
                child: const Text("Add")),
          ),
        ],
      );
    },
  );
}

class PopupRadioButton extends StatelessWidget {
  final String title;
  final CategoryType type;

  //final CategoryType groupVal;

 const PopupRadioButton({super.key, required this.title, required this.type});
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: selectedCategoryNotifier,
          builder: (context, newcategory, child) => Radio(
              value: type,
              groupValue: newcategory,
              onChanged: (value) {
             
                if (value == null) {
                  return;
                }

                selectedCategoryNotifier.value = value;
                selectedCategoryNotifier.notifyListeners();
              }),
        ),
        Text(title),
      ],
    );
  }
}
