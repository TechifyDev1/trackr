import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/pages/home_page.dart';

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
            return const Center(child: Text("Cards"));
          case 2:
            return const Center(child: Text("Settings"));
          default:
            return const HomePage();
        }
      },
    );
  }
}
