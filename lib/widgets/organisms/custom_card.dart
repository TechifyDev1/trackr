import 'package:flutter/cupertino.dart';

class CardModel {
  final String id;
  final String nickname;
  final String type;
  final String network;
  final String last4;
  final String bank;
  final String currency;
  final String createdAt;
  final double balance;

  CardModel({
    required this.id,
    required this.nickname,
    required this.type,
    required this.network,
    required this.last4,
    required this.bank,
    required this.currency,
    required this.createdAt,
    required this.balance,
  });
}

class CustomCard extends StatelessWidget {
  final CardModel card;

  const CustomCard({super.key, required this.card});

  Widget _buildNetworkLogo(String network) {
    // Placeholder: you can replace with actual images later
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
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.85,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [CupertinoColors.activeBlue, CupertinoColors.systemBlue],
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
          // Top row: Bank + Network
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                card.bank,
                style: const TextStyle(
                  color: CupertinoColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              _buildNetworkLogo(card.network),
            ],
          ),
          const SizedBox(height: 16),
          // Card nickname
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
                "${card.currency} ${card.balance.toStringAsFixed(2)}",
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
