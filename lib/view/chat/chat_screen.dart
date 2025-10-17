import 'package:flutter/material.dart';
import 'package:jarvis_ai/core/constants/app_constants.dart';
import 'package:jarvis_ai/view/chat/widgets/chat_bubble_widget.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final TextEditingController _messageController = TextEditingController();
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
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _isTyping = _messageController.text.trim().isNotEmpty;
    });
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
            ListView.separated(

              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: messages.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8.0),
              itemBuilder: (context, index) {
                final message = messages[index];
                return ChatBubble(message: message);
              },
            ),
            Expanded(
              child: Container(
                // This container will hold the chat messages
                color: Color(0xFF1f1B1B1B),
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
                          // Action for send button
                          // TODO: Send message
                          _messageController.clear();
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