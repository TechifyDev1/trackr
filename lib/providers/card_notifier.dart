import 'package:flutter_application_1/models/card.dart';
import 'package:flutter_application_1/services/card_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

class CardNotifier extends StateNotifier<List<Card>?> {
  CardNotifier() : super(null) {
    _loadCards();
  }

  Future<void> _loadCards() async {
    final cards = await CardService.instance.getCards();
    state = cards;
  }
}

final cardsProvider = StateNotifierProvider<CardNotifier, List<Card>?>((ref) {
  return CardNotifier();
});

final cardsProvider2 = StreamProvider.autoDispose<List<Card>>((ref) {
  final cards = CardService.instance.watchCards();
  return cards;
});
