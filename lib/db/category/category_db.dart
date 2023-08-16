import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:money_manager/models/category/category_model.dart';

const CATEGORY_DB_NAME='category_db';

abstract class CategoryDbFunctions{
 Future< List<CategoryModel>> getCategories();
 Future<void> insertCategory(CategoryModel values);
 Future<void> deleteCategory(String categoryId);
}

class CategoryDb implements CategoryDbFunctions{

  CategoryDb._internal();
  static CategoryDb instance=CategoryDb._internal();
  factory CategoryDb(){
    return instance;
  }

 ValueNotifier<List<CategoryModel>> incomeListNotifier=ValueNotifier([]);
 ValueNotifier<List<CategoryModel>> expenseListNotifier=ValueNotifier([]);

  @override
  Future<void> insertCategory(CategoryModel value)async {
   final categoryBox= await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
   
    await categoryBox.put(value.id,value);
    refreshUI();
 
    
    
  }
  
  @override
  Future<List<CategoryModel>> getCategories() async{
   final categoryBox=await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
   return categoryBox.values.toList();

  }

  Future<void> refreshUI()async{
    final allCategory= await getCategories();
    incomeListNotifier.value.clear();
    expenseListNotifier.value.clear();
    //if category.type=income,store in incomelistnotifier,else store in expenselistnotifier
   await Future.forEach(allCategory, (CategoryModel category)  {
      if(category.type==CategoryType.income){
        incomeListNotifier.value.add(category);
      }
      else{
        expenseListNotifier.value.add(category);
      }
    },);
    incomeListNotifier.notifyListeners();
    expenseListNotifier.notifyListeners();
  }


  @override
  Future<void> deleteCategory(String categoryId)async{
    final categoryBox=await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
   await categoryBox.delete(categoryId);
   
    refreshUI();
  }

}