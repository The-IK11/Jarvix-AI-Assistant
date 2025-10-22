import 'package:get/get.dart';
import 'package:jarvis_ai/core/network/api_services.dart';
import 'package:jarvis_ai/data/models/chat_bubble_model.dart';

class MessageController extends GetxController {
  // Observable list of messages
  var messages = <ChatBubbleModel>[].obs;
  
  // Typing state for showing Lottie loader
  var isTyping = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Add welcome messages on initialization
    _addWelcomeMessages();
  }

  void _addWelcomeMessages() {
    messages.addAll([
      ChatBubbleModel(message: "Welcome to Jarvix AI Assistant!", isUser: false),
      ChatBubbleModel(message: "How can I assist you today?", isUser: false),
    ]);
  }

  Future<void> sendMessage(String messageText) async {
    if (messageText.trim().isEmpty) return;

    // Add user message with timestamp
    final userMessage = ChatBubbleModel(
      message: messageText.trim(),
      isUser: true,
    );
    messages.add(userMessage);

    // Show typing indicator (Lottie loader)
    isTyping.value = true;
    final typingMessage = ChatBubbleModel(
      message: '',
      isUser: false,
      isTyping: true,
    );
    messages.add(typingMessage);
    final typingIndex = messages.length - 1;

    // Call API
    try {
      String reply = await ApiServices.getApiResponse(messageText);

      // Replace typing indicator with actual response
      messages[typingIndex] = ChatBubbleModel(
        message: reply,
        isUser: false,
        isTyping: false,
      );
    } catch (e) {
      // Replace typing indicator with error message
      messages[typingIndex] = ChatBubbleModel(
        message: "Sorry, I encountered an error: $e",
        isUser: false,
        isTyping: false,
      );
    } finally {
      isTyping.value = false;
    }
  }

  void clearMessages() {
    messages.clear();
    _addWelcomeMessages();
  }
}
