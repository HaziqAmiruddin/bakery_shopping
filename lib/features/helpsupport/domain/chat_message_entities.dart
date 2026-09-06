import 'package:equatable/equatable.dart';

enum ChatRole { user, model }

class ChatMessage extends Equatable {
  final ChatRole role;
  final String text;

  const ChatMessage({required this.role, required this.text});

  @override
  List<Object?> get props => [role, text];
}
