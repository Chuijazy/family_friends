import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:family_friends/chat/model_chat.dart';
import 'package:family_friends/screens/const.dart';
import 'package:flutter/material.dart';

class Chat1Screen extends StatefulWidget {
  const Chat1Screen({super.key});

  @override
  State<Chat1Screen> createState() => _Chat1Screen();
}

class _Chat1Screen extends State<Chat1Screen> {
  TextEditingController text = TextEditingController();
  String senderName = 'chat 1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        title: const Text('Chat', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF675DFF),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              itemCount: Chat.length,
              itemBuilder:
                  (_, index) => BubbleSpecialThree(
                    isSender: Chat[index].sender_name == senderName,
                    text: Chat[index].text.toString(),
                    color:
                        Chat[index].sender_name == senderName
                            ? const Color(0xFF675DFF)
                            : Colors.white,
                    tail: true,
                    textStyle: TextStyle(
                      color:
                          Chat[index].sender_name == senderName
                              ? Colors.white
                              : Colors.black87,
                      fontSize: 16,
                    ),
                  ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 5,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: text,
                      decoration: const InputDecoration(
                        hintText: 'Введите сообщение',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF675DFF)),
                  onPressed: () {
                    if (text.text.isNotEmpty) {
                      setState(() {
                        Chat.add(
                          model_chat(text: text.text, sender_name: senderName),
                        );
                        text.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
