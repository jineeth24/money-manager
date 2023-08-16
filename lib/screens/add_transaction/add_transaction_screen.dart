import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/db/transactions/transaction_db.dart';
import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/models/transaction/transaction_model.dart';


class AddTransactionScreen extends StatefulWidget {
  static const routeName = 'add-trasaction';
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
/*purpose
amount
date
income/expense
categorytype
*/
  DateTime? selectedDate;
  CategoryType? selectedCategoryType;
  String? categoryId;
  CategoryModel? selectedCategoryModel;
  final purpseEditingController = TextEditingController();
  final amountEditingContorller = TextEditingController();

  @override
  void initState() {
    selectedCategoryType = CategoryType.income;
    // categoryId=null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                controller: purpseEditingController,
                decoration: const InputDecoration(
                  label: Text("purpose"),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: amountEditingContorller,
                decoration: const InputDecoration(
                  label: Text("Amount"),
                  border: OutlineInputBorder(),
                ),
              ),
              //date

              TextButton.icon(
                onPressed: () async {
                  final tempSelecteDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );
                  if (tempSelecteDate == null) {
                    return;
                  } else {
                    setState(() {
                      selectedDate = tempSelecteDate;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(selectedDate == null
                    ? "select date"
                    : selectedDate.toString()),
              ),
              //if date selected

              //     income or expense//
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.income,
                        groupValue: selectedCategoryType,
                        onChanged: (currentCategory) {
                          setState(() {
                            selectedCategoryType = currentCategory;
                            categoryId = null;
                          });
                        },
                      ),
                      const Text("Income"),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: CategoryType.expense,
                        groupValue: selectedCategoryType,
                        onChanged: (currentCategory) {
                          setState(() {
                            selectedCategoryType = currentCategory;
                            categoryId = null;
                          });
                        },
                      ),
                      const Text("Expense"),
                    ],
                  ),
                ],
              ),

              //category type
              DropdownButton(
                hint: const Text("Select Category"),
                value: categoryId,
                items: (selectedCategoryType == CategoryType.income
                        ? CategoryDb().incomeListNotifier
                        : CategoryDb().expenseListNotifier)
                    .value
                    .map((e) {
                  return DropdownMenuItem(
                    value: e.id,
                     child: Text(e.name),
                     onTap: (){
                      selectedCategoryModel=e;
                     },
                     );
                }).toList(),
                onChanged: (selectedvalue) {
                  setState(() {
                    categoryId = selectedvalue;
                  });

                  // print(selectedvalue.toString());
                },
              ),
              //submit
              ElevatedButton(
                onPressed: () {
                  //add transaction
                  onSubmit();
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      )),
    );
  }

  Future<void> onSubmit() async {
    final purposeText = purpseEditingController.text;
    final amountText = amountEditingContorller.text;
    if (purposeText.isEmpty) {
      return;
    }
    if (amountText.isEmpty) {
      return;
    }
    if (selectedDate == null) {
      return;
    }
    if (categoryId == null) {
      return;
    }
    final paresedAmount = double.tryParse(amountText);
    if (paresedAmount == null) {
      return;
    }
    if(selectedCategoryModel==null){
      return;
    }

   final TransactionModel transaction= TransactionModel(
    id:DateTime.now().millisecondsSinceEpoch.toString() ,
      purpose: purposeText,
      amount: paresedAmount,
      date: selectedDate!,
      type: selectedCategoryType!,
      category: selectedCategoryModel!,
    );
    //add this model to db using a db function
    //addTransaction(transaction);
    TransactionDb.instance.addTransaction(transaction);
    Navigator.of(context).pop();
    TransactionDb.instance.refresh();

  }
}
