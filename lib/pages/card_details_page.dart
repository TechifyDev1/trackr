import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/enums/enums.dart';
import 'package:flutter_application_1/extensions.dart';
import 'package:flutter_application_1/models/card.dart';
import 'package:flutter_application_1/models/user.dart';
import 'package:flutter_application_1/pages/expense_detail_page.dart';
import 'package:flutter_application_1/providers/card_notifier.dart';
import 'package:flutter_application_1/providers/expense_notifier.dart';
import 'package:flutter_application_1/providers/user_notifier.dart';
import 'package:flutter_application_1/services/card_service.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter_application_1/widgets/molecules/expenses_list.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CardDetailsPage extends ConsumerStatefulWidget {
  final Card card;
  const CardDetailsPage({super.key, required this.card});

  @override
  ConsumerState<CardDetailsPage> createState() => _CardDetailsPageState();
}

class _CardDetailsPageState extends ConsumerState<CardDetailsPage> {
  bool loading = false;

  void archiveCard() async {
    try {
      setState(() {
        loading = true;
      });
      await CardService.instance.archiveCard(widget.card.docId!);
      if (mounted) {
        Utils.showDialog(
          context: context,
          message: "Card archived",
          severity: Severity.normal,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        Utils.showDialog(
          context: context,
          message: e.toString(),
          severity: Severity.high,
        );
      }
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void activateCard() async {
    try {
      setState(() {
        loading = true;
      });
      await CardService.instance.activate(widget.card.docId!);
      if (mounted) {
        Utils.showDialog(
          context: context,
          message: "Card activated",
          severity: Severity.normal,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      if (mounted) {
        Utils.showDialog(
          context: context,
          message: e.toString(),
          severity: Severity.high,
        );
      }
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final expensesAsync = ref.watch(expenseProvider);
    final user = ref.watch(userProvider2);
    User? userData;
    user.when(
      data: (data) {
        setState(() {
          userData = data;
        });
      },
      loading: () => debugPrint("Loading..."),
      error: (error, stackTrace) => debugPrint(error.toString()),
    );
    final formattedAmount = NumberFormat.currency(
      symbol: userData?.currency.currencyIcon,
      decimalDigits: 2,
    ).format(widget.card.balance);
    final cardsAsync = ref.watch(cardsProvider2);
    List<Card>? cards;
    cardsAsync.when(
      data: (data) {
        setState(() {
          cards = data;
        });
      },
      loading: () => debugPrint("Loading..."),
      error: (error, stackTrace) => debugPrint(error.toString()),
    );
    final currentCard = cards?.firstWhere((c) => c.docId == widget.card.docId);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text("Card details")),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(45, 153, 153, 153),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(68, 0, 0, 0),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              currentCard!.nickname,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (currentCard.archived == true) ...[
                              const SizedBox(width: 8),
                              Utils.archivedBadge(),
                            ],
                          ],
                        ),

                        const SizedBox(height: 8),

                        Text(
                          "Available balance",
                          style: TextStyle(
                            fontSize: 13,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                        const SizedBox(height: 6),

                        Text(
                          formattedAmount,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),

                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.creditcard,
                              size: 16,
                              color: CupertinoColors.systemGrey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${currentCard.bank} • ${currentCard.type} • ${currentCard.network}",
                              style: TextStyle(
                                fontSize: 14,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: CupertinoButton.filled(
                        color: CupertinoColors.activeOrange,
                        child: loading
                            ? CupertinoActivityIndicator()
                            : Text(
                                currentCard.archived == true
                                    ? "Activate"
                                    : "Archive",
                              ),
                        onPressed: () {
                          Utils.showConfirmationDialog(
                            context,
                            message: currentCard.archived == true
                                ? "Are you sure you want to activate this card?"
                                : "Are you sure you want to archive this card?",
                            severity: .medium,
                            action: () {
                              currentCard.archived == true
                                  ? activateCard()
                                  : archiveCard();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Text("Recent expenses"),
                SizedBox(height: 10),
                ...expensesAsync.when(
                  data: (expenses) {
                    final cardExpenses = expenses
                        .where((exp) => exp.cardDocId == currentCard.docId)
                        .toList();
                    if (cardExpenses.isEmpty) {
                      return const [
                        Center(
                          child: Text(
                            "No recent expenses",
                            style: TextStyle(color: CupertinoColors.systemGrey),
                          ),
                        ),
                      ];
                    }
                    return cardExpenses.map(
                      (exp) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) =>
                                  ExpenseDetailPage(expense: exp),
                            ),
                          );
                        },
                        child: ExpensesList(
                          title: exp.title,
                          subtitle: exp.category.name.capitalize(),
                          price: exp.amount,
                          transactionType: exp.type,
                        ),
                      ),
                    );
                  },
                  error: (e, er) {
                    debugPrint(e.toString());
                    debugPrint(er.toString());
                    return [
                      Center(child: Text("Error loading your recent expenses")),
                    ];
                  },
                  loading: () => [Center(child: CupertinoActivityIndicator())],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
