import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/enums/enums.dart';
import 'package:flutter_application_1/extensions.dart';
import 'package:flutter_application_1/models/card.dart';
import 'package:flutter_application_1/models/expense.dart';
import 'package:flutter_application_1/pages/ai_insight_page.dart';
import 'package:flutter_application_1/pages/edit_expense_form.dart';
import 'package:flutter_application_1/providers/card_notifier.dart';
import 'package:flutter_application_1/providers/user_notifier.dart';
import 'package:flutter_application_1/services/expense_service.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ExpenseDetailPage extends ConsumerStatefulWidget {
  final Expense expense;
  const ExpenseDetailPage({super.key, required this.expense});

  @override
  ConsumerState<ExpenseDetailPage> createState() => _ExpenseDetailPageState();
}

class _ExpenseDetailPageState extends ConsumerState<ExpenseDetailPage> {
  bool loading = false;
  bool isLoadingInsight = false;
  String insights = "";

  void deleteExpense(BuildContext context) async {
    if (loading) return;
    setState(() {
      loading = true;
    });
    try {
      await ExpenseService.instance.deleteExpense(expense: widget.expense);
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      debugPrint(e.toString());
      if (context.mounted) {
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

  void getInsights(BuildContext context) async {
    if (isLoadingInsight) return;
    setState(() {
      isLoadingInsight = true;
    });

    try {
      final res = await Utils.getInsight(widget.expense);
      setState(() {
        insights = res;
      });
      if (context.mounted) {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (_) => AiInsightPage(insights: insights)),
        );
      }
      setState(() {
        isLoadingInsight = false;
      });

      debugPrint(res);
    } catch (e) {
      if (context.mounted) {
        Utils.showDialog(
          context: context,
          message: "Error generating insights $e",
          severity: .high,
        );
      }
      setState(() {
        isLoadingInsight = false;
      });
      debugPrint(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          isLoadingInsight = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardAsync = ref.watch(cardsProvider2);
    // final cards = cardAsync.whenData((card) => card);
    final user = ref.watch(userProvider);

    List<Card> cardse = [];
    cardAsync.when(
      data: (cards) {
        cardse = cards;
      },
      error: (e, er) {
        debugPrint(e.toString());
      },
      loading: () => debugPrint("Loading...."),
    );
    Card usedCard = cardse.firstWhere(
      (card) => card.docId == widget.expense.cardDocId,
    );

    final formattedAmount = NumberFormat.currency(
      symbol: user?.currency.currencyIcon,
      decimalDigits: 2,
    ).format(widget.expense.amount);

    // print(usedCard.bank);

    // debugPrint(usedCard.toString());
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Expense Details'),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              // Amount
              Center(
                child: Column(
                  children: [
                    Text(
                      formattedAmount,
                      style: TextStyle(fontSize: 36, fontWeight: .bold),
                    ),
                    SizedBox(height: 6),
                    Text(
                      textAlign: .center,
                      '${widget.expense.title} • ${widget.expense.category.name}',
                      style: TextStyle(fontSize: 16, color: Color(0xFF8E8E93)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              GestureDetector(
                onTap: () {
                  getInsights(context);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: isLoadingInsight
                        ? const Color.fromARGB(255, 110, 60, 120)
                        : const Color.fromARGB(255, 88, 42, 94),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: isLoadingInsight
                        ? [
                            BoxShadow(
                              color: const Color.fromARGB(169, 255, 149, 0),
                              blurRadius: 16,
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                    border: Border.all(color: CupertinoColors.systemGrey4),
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Center(
                          child: isLoadingInsight
                              ? const CupertinoActivityIndicator(radius: 10)
                              : const Icon(
                                  CupertinoIcons.sparkles,
                                  color: CupertinoColors.activeOrange,
                                  size: 20,
                                ),
                        ),
                      ),

                      const SizedBox(width: 10),
                      Expanded(
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: isLoadingInsight ? 0.7 : 1,
                          child: Text(
                            isLoadingInsight
                                ? "Analyzing expense… please wait"
                                : "Get insight on this expense",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      if (!isLoadingInsight)
                        const Icon(
                          CupertinoIcons.chevron_right,
                          color: CupertinoColors.systemGrey,
                          size: 18,
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Info section
              _InfoRow(
                icon: CupertinoIcons.calendar,
                label: 'Date',
                value: DateFormat(
                  'EEEE, d yyyy hh:mm a',
                ).format(widget.expense.date),
              ),
              _InfoRow(
                icon: CupertinoIcons.creditcard,
                label: 'Payment',
                value: "${usedCard.bank}' ${usedCard.network}",
              ),
              _InfoRow(
                icon: CupertinoIcons.folder,
                label: 'Category',
                value: widget.expense.category.name.capitalize(),
              ),

              const SizedBox(height: 30),

              // Description
              const Text(
                'Note',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                widget.expense.notes,
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.systemGrey,
                ),
              ),

              const SizedBox(height: 40),

              // Actions
              Row(
                children: [
                  Expanded(
                    child: CupertinoButton(
                      padding: EdgeInsets.all(8),
                      color: CupertinoColors.systemGrey5,
                      onPressed: () {
                        Utils.showPagePopup(
                          context,
                          EditExpenseForm(expense: widget.expense),
                        );
                      },
                      child: const Text(
                        'Edit',
                        style: TextStyle(
                          color: CupertinoColors.extraLightBackgroundGray,
                          fontWeight: .bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CupertinoButton(
                      padding: .all(8),
                      color: CupertinoColors.systemRed,
                      onPressed: () {
                        Utils.showConfirmationDialog(
                          context,
                          message:
                              "Deleting this transaction will update your card balance, do you want to proceed?",
                          severity: .high,
                          action: () {
                            deleteExpense(context);
                          },
                        );
                      },
                      child: loading
                          ? CupertinoActivityIndicator()
                          : Text('Delete', style: TextStyle(fontWeight: .bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: CupertinoColors.systemGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.systemGrey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
