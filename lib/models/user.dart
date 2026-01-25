import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:flutter_application_1/enums/enums.dart';

class User {
  final String name;
  final String email;
  final Currencies currency;
  final String? photoUrl;
  final String? provider;
  final DateTime? createdAt;

  const User({
    required this.name,
    required this.email,
    required this.currency,
    this.createdAt,
    this.photoUrl,
    this.provider,
  });

  factory User.fromMap(Map<String, dynamic>? data) {
    DateTime? parsedDate;
    var dateValue = data?["createdAt"];

    if (dateValue is Timestamp) {
      parsedDate = dateValue.toDate();
    } else if (dateValue is String) {
      parsedDate = DateTime.tryParse(dateValue);
    }

    return User(
      name: data?["name"] ?? "Trackr User",
      email: data?["email"] ?? "",
      currency: data?["currency"] != null
          ? (Currencies.values.any((e) => e.name == data!["currency"])
              ? Currencies.values.byName(data?["currency"])
              : Currencies.ngn)
          : Currencies.ngn,
      provider: data?["provider"],
      photoUrl: data?["photoUrl"],
      createdAt: parsedDate,
    );
  }

  @override
  String toString() {
    return "name: $name, email: $email, currency: $currency, provider: $provider, createdAt: $createdAt";
  }
}
