class Part {
  final String? text;
  final Map<String, dynamic>? functionCall; // Now a Map to include name/args
  final Map<String, dynamic>? functionResponse; // Added for the results

  Part({this.text, this.functionCall, this.functionResponse});

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part(
      text: json["text"],
      functionCall: json["functionCall"],
      functionResponse: json["functionResponse"],
    );
  }

  Map<String, dynamic> toJson() {
    if (text == null && functionCall == null && functionResponse == null) {
      throw StateError("Part must contain data");
    }

    final json = <String, dynamic>{};
    if (text != null && text!.isNotEmpty) json["text"] = text;
    if (functionCall != null) json["functionCall"] = functionCall;
    if (functionResponse != null) json["functionResponse"] = functionResponse;
    return json;
  }
}
