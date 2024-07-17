import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../enums/message_enums.dart';

class MessageReply {
  final String message;
  final bool isMe;
  final MessageEnum messageEnum;

  MessageReply({required this.message,required this.isMe,required this.messageEnum});
}

class MessageReplyNotifier extends StateNotifier<MessageReply?> {
  MessageReplyNotifier() : super(null);
  void updateMessageReply({
    required String message,
    required MessageEnum messageType,
    required bool isMe,
  }) {
    state = MessageReply(
      message: message,
      messageEnum: messageType,
      isMe: isMe,
    );
  }

  void resetMessageReply(){
    state =null;
  }
}



final messageReplyProvider = StateNotifierProvider<MessageReplyNotifier,MessageReply?>((ref) => MessageReplyNotifier());


