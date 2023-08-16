import 'package:flutter/material.dart';
//import 'package:money_manager/db/category/category_db.dart';
//import 'package:money_manager/models/category/category_model.dart';
import 'package:money_manager/screens/add_transaction/add_transaction_screen.dart';
import 'package:money_manager/screens/category/category_add_popup.dart';
import 'package:money_manager/screens/category/category_screen.dart';
import 'package:money_manager/screens/home/widgets/bottom_navigation.dart';
import 'package:money_manager/screens/transactions/transaction_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  static ValueNotifier<int> selectedindexNotifier = ValueNotifier(0);//of bottomNavbar,stores index of navBar item, to show transaction screen,or categoryscreen

  final pages = [
   const TransactionScreen(),
   const CategoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color.fromARGB(255, 152, 180, 153),
      appBar: AppBar(
        title:const Text("Money Manager"),
        centerTitle: true,
        backgroundColor:const Color.fromARGB(255, 11, 97, 168),
      ),
      bottomNavigationBar:const MoneyManagerBottomNavigation(),
      body: SafeArea(
        child: ValueListenableBuilder(
            valueListenable: selectedindexNotifier,
            builder: ((BuildContext context, int updatedIndex, Widget? child) {
              return pages[updatedIndex];
            })),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedindexNotifier.value == 0) {
           
            Navigator.of(context).pushNamed(AddTransactionScreen.routeName);
          } else {
          
            showCategoryAddPopup(context);
       
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
