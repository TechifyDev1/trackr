import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/auth_service.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.darkBackgroundGray,
      navigationBar: CupertinoNavigationBar(
        leading: CircleAvatar(
          backgroundImage: AssetImage("assets/images/qudus.png"),
        ),
        middle: const Text("Cards"),
        trailing: IconButton(
          onPressed: () {
            // AuthService.instance.logout();
          },
          icon: Icon(CupertinoIcons.plus, color: CupertinoColors.white),
          style: IconButton.styleFrom(
            backgroundColor: CupertinoColors.darkBackgroundGray,
          ),
          iconSize: 16,
        ),
      ),
      child: SafeArea(child: Placeholder()),
    );
  }
}
