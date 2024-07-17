import 'package:chitthi/colors.dart';
import 'package:chitthi/features/chat/widgets/display_messageType.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../common/providers/message_reply_provider.dart';
import '../../../common/widgets/cancel_reply.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);

    return Container(
      padding: const EdgeInsets.only(top:10,left: 10, right: 10,bottom: 5),
      decoration: const BoxDecoration(
        color: lightbackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(25))
      ),
      child: Stack(
        children: [
          Center(
            child: DisplayMessageType(
            message: messageReply!.message,
            type: messageReply.messageEnum,
          ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 10,
                child: Icon(
                  Icons.close,
                  size: 14,
                ),
              ),
              onTap: () => cancelReply(ref),
            ),
          ),
          
        ],
      ),
    );
  }
}
