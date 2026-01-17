import 'package:flutter_application_1/models/content.dart';

class Candidate {
  final Content content;
  final String? finishReason;

  Candidate({required this.content, this.finishReason});

  factory Candidate.fromJson(Map<String, dynamic> json) {
    return Candidate(
      content: Content.fromJson(json["content"]),
      finishReason: json['finishReason'],
    );
  }
}
