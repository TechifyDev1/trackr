import 'package:flutter_application_1/models/insights/part.dart';

class Content {
  final List<Part> parts;

  Content({required this.parts});

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      parts: (json["parts"] as List).map((p) => Part.fromJson(p)).toList(),
    );
  }
}
