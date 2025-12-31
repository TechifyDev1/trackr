import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/pages/cards_page.dart';
import 'package:flutter_application_1/pages/expenses_page.dart';
import 'package:flutter_application_1/pages/home_page.dart';
import 'package:flutter_application_1/pages/settings_page.dart';

class RootTabs extends StatelessWidget {
  const RootTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        iconSize: 20,
        activeColor: CupertinoColors.white,
        height: MediaQuery.of(context).size.height * 0.08,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house_fill),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.money_dollar_circle_fill),
            label: "Expenses",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.creditcard),
            label: "Cards",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.settings),
            label: "Settings",
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return HomePage();
          case 1:
            return ExpensesPage();
          case 2:
            return CardsPage();
          case 3:
            return SettingsPage();
          default:
            return const HomePage();
        }
      },
    );
  }
}
