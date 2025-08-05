import 'package:flutter/material.dart';

class ChatMessage {
  final String id;
  final String text;
  final String senderId;
  final String senderName;
  final String senderAvatarUrl;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.senderAvatarUrl,
    required this.timestamp,
    required this.isMe,
  });
}

class ChatConversationModel extends ChangeNotifier {
  final List<ChatMessage> _messages = [];

  List<ChatMessage> get messages => _messages;

  void addMessage(ChatMessage message) {
    _messages.add(message);
    notifyListeners();
  }
}