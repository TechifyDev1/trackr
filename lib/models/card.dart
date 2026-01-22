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
  final String? docId;
  final bool? archived;

  const Card({
    required this.id,
    required this.nickname,
    required this.type,
    required this.network,
    required this.last4,
    required this.balance,
    required this.bank,
    required this.createdAt,
    this.docId,
    this.archived = false,
  });

  factory Card.fromMap(Map<String, dynamic>? card, String docId) {
    return Card(
      id: card?["id"],
      nickname: card?["nickname"],
      type: card?["type"],
      network: card?["network"],
      last4: card?["last4"],
      balance: (card?["balance"] as num).toDouble(),
      bank: card?["bank"],
      createdAt: (card?["createdAt"] as Timestamp).toDate(),
      docId: docId,
      archived: card?["archived"],
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
      "docId": docId,
      "archived": archived,
    };
  }

  @override
  String toString() {
    bool isArchived = archived == true;
    return "id: $id, nickname: $nickname, type: $type, network: $network, last 4 digit number of the card: $last4, balance: ${balance.toString()}, bank: $bank, createdAt: ${createdAt.toIso8601String()}, docId: $docId, archived: $isArchived.";
  }
}
