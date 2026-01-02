import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/models/card.dart';
import 'package:flutter_application_1/services/auth_service.dart';

class CardService {
  CardService._();
  static final instance = CardService._();
  final FirebaseFirestore db = AuthService.instance.db;

  Future<Map<String, dynamic>> saveCard(Card card) async {
    try {
      await db
          .collection("cards")
          .doc(AuthService.instance.uid)
          .collection("user_cards")
          .add(card.toMap());
      return {"status": "success", "message": "Card created successfully"};
    } on FirebaseException catch (e) {
      if (e.code == "unavailable") {
        throw "Network error";
      }
      if (e.code == "permission-denied") {
        throw "You are not allowed to create card";
      }
      throw "unexpected error occured";
    } catch (e) {
      if (kDebugMode) print(e);
      throw "unexpected error occured";
    }
  }

  Future<List<Card>> getCards() async {
    final res = await db
        .collection("cards")
        .doc(AuthService.instance.uid)
        .collection("user_cards")
        .get();
    return res.docs.map((doc) {
      return Card.fromMap(doc.data());
    }).toList();
  }

  Stream<List<Card>> watchCards() {
    return db
        .collection("cards")
        .doc(AuthService.instance.uid)
        .collection("user_cards")
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Card.fromMap(doc.data())).toList();
        });
  }
}
