import 'package:flutter/cupertino.dart';
import 'package:flutter_application_1/models/card.dart';
import 'package:flutter_application_1/providers/user_notifier.dart';
import 'package:flutter_application_1/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CustomCard extends ConsumerWidget {
  final Card card;

  const CustomCard({super.key, required this.card});

  Widget _buildNetworkLogo(String network) {
    IconData icon;
    switch (network.toLowerCase()) {
      case "visa":
        icon = CupertinoIcons.creditcard;
        break;
      case "mastercard":
        icon = CupertinoIcons.creditcard;
        break;
      case "verve":
        icon = CupertinoIcons.creditcard;
        break;
      default:
        icon = CupertinoIcons.creditcard;
    }
    return Icon(icon, color: CupertinoColors.white, size: 24);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    // final cards = ref.watch(cardsProvider2);
    final bal = card.balance;
    final formattedAmount = NumberFormat.currency(
      symbol: user!.currency.currencyIcon,
      decimalDigits: 2,
    ).format(bal);
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.85,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [CupertinoColors.black, Color.fromARGB(255, 40, 40, 41)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: CupertinoColors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card.bank,
                    style: const TextStyle(
                      color: CupertinoColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (card.archived == true) ...[
                    const SizedBox(height: 4),
                    Utils.archivedBadge(),
                  ],
                ],
              ),
              _buildNetworkLogo(card.network),
            ],
          ),

          const SizedBox(height: 16),
          Text(
            card.nickname,
            style: const TextStyle(
              color: CupertinoColors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          // Last 4 digits
          Text(
            "**** **** **** ${card.last4}",
            style: const TextStyle(
              color: CupertinoColors.white,
              fontSize: 18,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          // Balance row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Balance",
                style: TextStyle(color: CupertinoColors.white, fontSize: 14),
              ),
              Text(
                formattedAmount,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
