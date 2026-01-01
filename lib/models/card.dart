import 'package:cloud_firestore/cloud_firestore.dart';

class Card {
  final String id;
  final String nickname;
  final String type;
  final String network;
  final int last4;
  final String bank;
  final DateTime createdAt;
  final double balance;

  const Card({
    required this.id,
    required this.nickname,
    required this.type,
    required this.network,
    required this.last4,
    required this.balance,
    required this.bank,
    required this.createdAt,
  });

  factory Card.fromMap(Map<String, dynamic>? card) {
    return Card(
      id: card?["id"],
      nickname: card?["nickname"],
      type: card?["type"],
      network: card?["network"],
      last4: card?["last4"],
      balance: (card?["balance"] as num).toDouble(),
      bank: card?["bank"],
      createdAt: (card?["createdAt"] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "nickname": nickname,
      "type": type,
      "network": network,
      "last4": last4,
      "balance": balance,
      "bank": bank,
      "createdAt": createdAt,
    };
  }
}
