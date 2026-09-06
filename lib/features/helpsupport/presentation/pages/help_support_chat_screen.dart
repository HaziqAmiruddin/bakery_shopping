import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopping_app/core/inject/injection.dart';
import 'package:shopping_app/core/theme/app_theme.dart';
import 'package:shopping_app/core/theme/dimens.dart';
import 'package:shopping_app/core/widgets/app_scaffold.dart';
import 'package:shopping_app/core/widgets/general_app_bar.dart';
import 'package:shopping_app/features/helpsupport/presentation/bloc/chat_cubit.dart';
import 'package:shopping_app/features/helpsupport/presentation/bloc/chat_state.dart';
import 'package:shopping_app/features/helpsupport/presentation/widgets/chat_bubble.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();

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

  void _send(BuildContext context) {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    context.read<SupportChatCubit>().sendMessage(text);
    _textController.clear();
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appColors = context.theme.appColors;
    final appTypography = context.theme.appTypography;

    return BlocProvider<SupportChatCubit>(
      create: (_) => getIt<SupportChatCubit>(),
      child: AppScaffold(
        appBar: GeneralAppBar(title: 'Help and Support'),
        body: BlocConsumer<SupportChatCubit, SupportChatState>(
          listener: (context, state) => _scrollToBottom(),
          builder: (context, state) {
            final chatState = state as SupportChatReady;

            return Column(
              children: [
                Expanded(
                  child: chatState.messages.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.all(Dimens.largePadding),
                            child: Text(
                              "Hi! Ask me anything about your order, delivery, "
                              "payment, or how to use the app.",
                              textAlign: TextAlign.center,
                              style: appTypography.bodyMedium.copyWith(
                                color: appColors.gray4,
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.all(Dimens.largePadding),
                          itemCount: chatState.messages.length,
                          itemBuilder: (context, index) {
                            final message = chatState.messages[index];
                            return ChatBubble(message: message);
                          },
                        ),
                ),
                if (chatState.isSending)
                  Padding(
                    padding: EdgeInsets.only(bottom: Dimens.padding),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimens.largePadding,
                        ),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(Dimens.largePadding),
                  child: Row(
                    spacing: Dimens.padding,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            hintText: 'Type your question...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                          onSubmitted: (_) => _send(context),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: appColors.primary),
                        onPressed: chatState.isSending
                            ? null
                            : () => _send(context),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
