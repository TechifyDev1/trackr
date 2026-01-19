class AiResult {
  final String type;
  final String? text;
  final String? functionName;
  final Map<String, dynamic>? arguments;
  final String? rawCall;

  AiResult({
    required this.type,
    this.text,
    this.functionName,
    this.arguments,
    this.rawCall,
  });
}
