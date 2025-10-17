import 'package:flutter/material.dart';
import 'package:jarvis_ai/core/constants/app_constants.dart';
import 'package:jarvis_ai/data/models/chat_bubble_model.dart';
import 'package:jarvis_ai/view/chat/widgets/chat_bubble_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onTextChanged() {
    setState(() {
      _isTyping = _messageController.text.trim().isNotEmpty;
    });
  }

  String _getAiResponse(String rawInput) {
    final input = rawInput.toLowerCase().trim();
    switch (input) {
      case 'hi':
      case 'hello':
        return 'Hello! How can I help you today?';
      case 'help':
        return 'Sure — tell me what you need help with.';
      case 'time':
      case 'date':
        final now = DateTime.now();
        return 'Current time is ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} on ${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      case 'name':
        return "I'm Jarvix — your AI assistant.";
      default:
        return 'Here\'s an answer to: "$rawInput"';
    }
  }

  Future<void> _handleSend() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Add user message
    setState(() {
      messages.add(ChatBubbleModel(message: text, isUser: true));
    });
    _messageController.clear();
    _scrollToBottom();

    // Add AI typing indicator (Lottie)
    setState(() {
      messages.add(ChatBubbleModel(message: '', isUser: false, isTyping: true));
    });
    final typingIndex = messages.length - 1;
    _scrollToBottom();

    // Simulate 3s thinking time
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final reply = _getAiResponse(text);
    setState(() {
      // Replace typing bubble with the AI response
      messages[typingIndex] = ChatBubbleModel(message: reply, isUser: false);
    });
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF171212),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF171212),
        title: const Text('Jarvix AI Assistant', style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500),),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white,size: 30,),
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
              child: ListView.separated(
                controller: _scrollController,
                itemCount: messages.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8.0),
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return ChatBubble(message: message);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                   color: Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
               
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _messageController,
                        
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                        //   focusedBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.all(Radius.circular(30)),
                        // ),
                        // enabledBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.all(Radius.circular(30)),
                        // ),
                        // errorBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.all(Radius.circular(30)),
                        // ),
                        // disabledBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.all(Radius.circular(30)),
                        // ),
                          hintText: 'Type your message...',
                          hintStyle: TextStyle(color: Colors.white54),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        _isTyping ? Icons.send : Icons.mic,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        if (_isTyping) {
                          _handleSend();
                        } else {
                          // Action for voice recording
                          // TODO: Start voice recording
                        }
                      },
                    ),
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