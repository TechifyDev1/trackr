enum MessageType { user, ai, intent, thinking }
class UiMessage {
  final String message;
  final bool isUser;
  final MessageType type;

  UiMessage({
    required this.message,
    required this.isUser,
    this.type = MessageType.user,
  });

  UiMessage copyWith({String? message, bool? isUser, MessageType? type}) {
    return UiMessage(
      message: message ?? this.message,
      isUser: isUser ?? this.isUser,
      type: type ?? this.type,
    );
  }

  factory UiMessage.user(String message) =>
      UiMessage(message: message, isUser: true, type: MessageType.user);

  factory UiMessage.ai(String message) =>
      UiMessage(message: message, isUser: false, type: MessageType.ai);

  factory UiMessage.intent(String action) =>
      UiMessage(message: action, isUser: false, type: MessageType.intent);

  factory UiMessage.thinking() =>
      UiMessage(message: "Thinking...", isUser: false, type: MessageType.thinking);
}
