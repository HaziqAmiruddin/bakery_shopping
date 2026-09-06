import 'package:flutter/material.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/utils/check_theme_status.dart';
import 'package:shopping_app/features/helpsupport/domain/chat_message_entities.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;
    final appColors = context.theme.appColors;
    final isDark = checkDarkMode(context);

    final bubbleColor = isUser
        ? appColors.primary
        : (isDark
              ? appColors.gray4.withValues(alpha: 0.25)
              : appColors.gray4.withValues(alpha: 0.15));

    final textColor = isUser
        ? Colors.white
        : (isDark ? Colors.white : Colors.black87);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: Dimens.padding),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(message.text, style: TextStyle(color: textColor)),
      ),
    );
  }
}
