import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jarvis_ai/view/chat/widgets/chat_bubble_widget.dart';
import 'package:jarvis_ai/view_model/message_controller.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MessageController controller = Get.put(MessageController());
    final TextEditingController messageController = TextEditingController();
    final ScrollController scrollController = ScrollController();
    final RxBool hasText = false.obs;

    // Listen to text changes
    messageController.addListener(() {
      hasText.value = messageController.text.trim().isNotEmpty;
    });

    void scrollToBottom() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }

    void handleSend() {
      final text = messageController.text.trim();
      if (text.isEmpty) return;

      controller.sendMessage(text);
      messageController.clear();
      scrollToBottom();

      // Scroll again after a delay to account for typing indicator and response
      Future.delayed(const Duration(milliseconds: 100), scrollToBottom);
    }

    return Scaffold(
      backgroundColor: const Color(0xFF171212),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF171212),
        title: const Text(
          'Jarvix AI Assistant',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white, size: 30),
            onPressed: () {
              // Action for settings button
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                // Auto-scroll when messages change
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  scrollToBottom();
                });

                return ListView.separated(
                  controller: scrollController,
                  itemCount: controller.messages.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8.0),
                  itemBuilder: (context, index) {
                    final message = controller.messages[index];
                    return ChatBubble(message: message);
                  },
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: messageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                        onFieldSubmitted: (_) => handleSend(),
                      ),
                    ),
                    Obx(() {
                      return IconButton(
                        icon: Icon(
                          hasText.value ? Icons.send : Icons.mic,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (messageController.text.trim().isNotEmpty) {
                            handleSend();
                          } else {
                            // Action for voice recording
                            // TODO: Start voice recording
                          }
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}