class ChatMessage {
  final String id;
  final String text;
  final bool isBot;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isBot,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'isBot': isBot,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id'],
        text: json['text'],
        isBot: json['isBot'],
        timestamp: DateTime.parse(json['timestamp']),
      );
}
