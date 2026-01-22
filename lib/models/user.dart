import 'package:flutter_application_1/enums/enums.dart';

class User {
  final String name;
  final String email;
  final Currencies currency;

  const User({required this.name, required this.email, required this.currency});

  factory User.fromMap(Map<String, dynamic>? data) {
    return User(
      name: data?["name"],
      email: data?["email"],
      currency: Currencies.values.byName(data?["currency"]),
    );
  }

  @override
  String toString() {
    return "name: $name, email: $email, currency: $currency";
  }
}
