import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/card_notifier.dart';
import 'package:flutter_application_1/widgets/organisms/card_form.dart';
import 'package:flutter_application_1/widgets/organisms/custom_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardsPage extends ConsumerWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(cardsProvider);
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
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [Text("Your cards"), Text(cards!.length.toString())],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.29,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  children: List.generate(cards.length, (index) {
                    final card = cards[index];
                    return CustomCard(card: card);
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
