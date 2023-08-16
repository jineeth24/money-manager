import 'package:flutter/material.dart';
import 'package:money_manager/screens/home/home_screen.dart';

class MoneyManagerBottomNavigation extends StatelessWidget {
  const MoneyManagerBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HomeScreen.selectedindexNotifier,
      builder: (context, updatedIndex, child) {
        return BottomNavigationBar(
            selectedItemColor: Colors.purple,
            currentIndex: updatedIndex,
            onTap: (newIndex) {
              HomeScreen.selectedindexNotifier.value = newIndex;
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Transactions",
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.category), label: 'Category'),
            ]);
      },
    );
  }
}
