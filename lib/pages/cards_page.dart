import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/organisms/card_form.dart';
import 'package:flutter_application_1/widgets/organisms/custom_card.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final myCard = CardModel(
      id: "card_001",
      nickname: "GTBank Debit",
      type: "debit",
      network: "verve",
      last4: "1234",
      bank: "GTBank",
      currency: "NGN",
      createdAt: "2025-01-01",
      balance: 1233344.4,
    );
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.darkBackgroundGray,
      navigationBar: CupertinoNavigationBar(
        leading: CircleAvatar(
          backgroundImage: AssetImage("assets/images/qudus.png"),
        ),
        middle: const Text("Cards"),
        trailing: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                fullscreenDialog: true,
                builder: (context) {
                  return CardForm();
                },
              ),
            );
          },
          icon: Icon(CupertinoIcons.plus, color: CupertinoColors.white),
          style: IconButton.styleFrom(
            backgroundColor: CupertinoColors.darkBackgroundGray,
          ),
          iconSize: 16,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: .spaceBetween,
                children: [Text("Your cards"), Text("3")],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.29,
                child: ListView(
                  scrollDirection: .horizontal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  children: [
                    CustomCard(card: myCard),
                    CustomCard(card: myCard),
                    CustomCard(card: myCard),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
