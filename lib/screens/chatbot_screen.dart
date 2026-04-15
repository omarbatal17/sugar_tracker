import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../hooks/app_translation.dart';
import '../state/app_state.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/chat_message.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final appState = context.read<AppState>();
    appState.sendMessage(text);
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final tr = AppTranslation(appState.language);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColors.dark : AppColors.light;
    final messages = appState.chatMessages;

    return Container(
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: palette.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          AppBar(
            title: Text(tr.t('chatbot')),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            foregroundColor: palette.text,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              if (messages.isNotEmpty)
                IconButton(
                  icon: const Icon(FeatherIcons.trash2, size: 18),
                  onPressed: () => appState.clearChat(),
                ),
              IconButton(
                icon: const Icon(FeatherIcons.x, size: 18),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Expanded(
            child: messages.isEmpty
                ? _EmptyChatState(palette: palette, tr: tr)
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      return _ChatBubble(
                        message: msg,
                        palette: palette,
                        theme: theme,
                      );
                    },
                  ),
          ),
          _ChatInput(
            controller: _controller,
            onSend: _sendMessage,
            palette: palette,
            theme: theme,
            tr: tr,
          ),
        ],
      ),
    );
  }
}

class _EmptyChatState extends StatelessWidget {
  final AppPalette palette;
  final AppTranslation tr;

  const _EmptyChatState({required this.palette, required this.tr});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: palette.primaryContainer.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: Icon(FeatherIcons.messageCircle, size: 64, color: palette.primary),
            ),
            const SizedBox(height: 24),
            Text(
              tr.t('chatbotWelcome'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: palette.text,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              tr.t('chatbotHint'),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: palette.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final AppPalette palette;
  final ThemeData theme;

  const _ChatBubble({
    required this.message,
    required this.palette,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final isBot = message.isBot;
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isBot ? palette.card : palette.primary,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isBot ? 4 : 20),
            bottomRight: Radius.circular(isBot ? 20 : 4),
          ),
          border: isBot ? Border.all(color: palette.border, width: 0.5) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isBot ? palette.text : palette.primaryForeground,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final AppPalette palette;
  final ThemeData theme;
  final AppTranslation tr;

  const _ChatInput({
    required this.controller,
    required this.onSend,
    required this.palette,
    required this.theme,
    required this.tr,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: palette.tabBar,
        border: Border(top: BorderSide(color: palette.border, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(color: palette.text),
              decoration: InputDecoration(
                hintText: tr.t('chatbotInputPlaceholder'),
                hintStyle: TextStyle(color: palette.textSecondary.withAlpha(150)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: palette.surfaceInput,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onSend,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: palette.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: palette.primary.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(FeatherIcons.send, size: 20, color: palette.primaryForeground),
            ),
          ),
        ],
      ),
    );
  }
}
