import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/card_details_page.dart';
import 'package:flutter_application_1/providers/card_notifier.dart';
import 'package:flutter_application_1/widgets/organisms/card_form.dart';
import 'package:flutter_application_1/widgets/organisms/custom_card.dart';
import 'package:flutter_application_1/providers/user_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardsPage extends ConsumerWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider2);

    return userAsync.when(
      loading: () => const CupertinoPageScaffold(
        backgroundColor: CupertinoColors.darkBackgroundGray,
        child: Center(child: CupertinoActivityIndicator()),
      ),
      error: (err, stack) => CupertinoPageScaffold(
        backgroundColor: CupertinoColors.darkBackgroundGray,
        child: Center(child: Text("Error: $err", textAlign: TextAlign.center)),
      ),
      data: (userData) {
        final cards = ref.watch(cardsProvider2);

        return CupertinoPageScaffold(
          backgroundColor: CupertinoColors.darkBackgroundGray,
          navigationBar: CupertinoNavigationBar(
            leading: CircleAvatar(
              backgroundImage:
                  userData.photoUrl != null && userData.photoUrl!.isNotEmpty
                  ? NetworkImage(userData.photoUrl!)
                  : const AssetImage("assets/images/9723582.jpg"),
            ),
            middle: const Text("Cards"),
            trailing: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    fullscreenDialog: true,
                    builder: (context) {
                      return const CardForm();
                    },
                  ),
                );
              },
              icon: const Icon(
                CupertinoIcons.plus,
                color: CupertinoColors.white,
              ),
              style: IconButton.styleFrom(
                backgroundColor: CupertinoColors.darkBackgroundGray,
              ),
              iconSize: 16,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: cards.when(
                data: (cardsData) {
                  if (cardsData.isEmpty) {
                    return Center(
                      child: Text("You do not currently have any card"),
                    );
                  }
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Your cards"),
                          Text(cardsData.length.toString()),
                        ],
                      ),
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.29,
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            children: List.generate(cardsData.length, (index) {
                              final card = cardsData[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) {
                                        return CardDetailsPage(card: card);
                                      },
                                    ),
                                  );
                                },
                                child: CustomCard(card: card),
                              );
                            }),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                error: (e, er) => Center(
                  child: Text("Error fetching your cards please try again $e"),
                ),
                loading: () =>
                    const Center(child: CupertinoActivityIndicator()),
              ),
            ),
          ),
        );
      },
    );
  }
}
