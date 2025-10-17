class ChatBubbleModel {
  final String message;
  final bool isUser;
  final bool isTyping;

  ChatBubbleModel({
    required this.message,
    required this.isUser,
    this.isTyping = false,
  });
}