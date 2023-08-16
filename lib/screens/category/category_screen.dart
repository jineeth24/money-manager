import 'package:flutter/material.dart';
import 'package:money_manager/db/category/category_db.dart';
import 'package:money_manager/screens/category/expense_category_list.dart';
import 'package:money_manager/screens/category/income_category_list.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with TickerProviderStateMixin{
late TabController _tabController;
@override
void initState() {
    _tabController=TabController(length: 2,vsync: this);
    CategoryDb.instance.refreshUI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          
          unselectedLabelColor: Colors.grey,
          controller: _tabController,
          tabs: const  [
          Tab(text: 'Income',),
          Tab(text: "Expense",)
        ]),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children:const [
            IncomeCategoryList(),
            ExpenseCategoryList(),
          ],
          ),
        ),
      ],
    );
    
  }
}