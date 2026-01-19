import 'package:flutter_application_1/models/insights/part.dart';

class History {
  final String role;
  final List<Part> parts;

  History({required this.role, required this.parts});

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      role: json['role'] ?? '',
      parts: (json['parts'] as List)
          .map((item) => Part.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'role': role, 'parts': parts.map((e) => e.toJson()).toList()};
  }
}
