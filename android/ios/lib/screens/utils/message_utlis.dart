import 'dart:convert';
import 'package:flutter/services.dart';

class MessageUtils {
  static String getDailyMessage(String partnerName) {
    final dayOfYear = DateTime.now().day;
    final message = _messages[dayOfYear % _messages.length];
    return message.replaceAll('{{partner}}', partnerName);
  }

  static final List<String> _messages = [
    "{{partner}}, you make my world brighter every day.",
    "Thinking of you fills my heart with joy, {{partner}}.",
    "Every moment with you is precious, {{partner}}.",
    "Your smile is my favorite thing in the world, {{partner}}.",
    "I fall in love with you more each day, {{partner}}.",
    // Add 360 more messages here...
    "{{partner}}, you're the love of my life and my greatest blessing.",
  ];

  // Alternative method to load from JSON (uncomment if using JSON)
  /*
  static Future<String> getDailyMessageFromJson(String partnerName) async {
    final String response = await rootBundle.loadString('assets/messages.json');
    final data = await json.decode(response) as List;
    final dayOfYear = DateTime.now().day;
    final message = data[dayOfYear % data.length]['message'];
    return message.replaceAll('{{partner}}', partnerName);
  }
  */
}
