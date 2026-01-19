import 'package:flutter_application_1/models/insights/candidate.dart';

class GeminiResponse {
  final List<Candidate> candidates;

  GeminiResponse({required this.candidates});

  factory GeminiResponse.fromJson(Map<String, dynamic> json) {
    return GeminiResponse(
      candidates: (json["candidates"] as List)
          .map((c) => Candidate.fromJson(c))
          .toList(),
    );
  }
}
