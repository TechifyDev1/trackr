import 'package:flutter_application_1/models/chat/history.dart';

class Message {
  final String message;
  final List<History> history;

  Message({required this.message, required this.history});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      message: json["message"],
      history: (json["history"] as List)
          .map((item) => History.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "history": history.map((item) => item.toJson()).toList(),
    };
  }
}
