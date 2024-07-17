import 'package:chitthi/common/enums/message_enums.dart';
import 'package:chitthi/features/chat/widgets/display_messageType.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../colors.dart';

class SenderMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback onRightSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;

  const SenderMessageCard(
      {Key? key,
      required this.message,
      required this.date,
      required this.type,
      required this.onRightSwipe,
      required this.repliedText,
      required this.username,
      required this.repliedMessageType,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;
    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
        alignment: Alignment.centerLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 120),
            child: Card(
              elevation: 1,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              color: senderMessageColor,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Stack(
                children: [
                  Padding(
                      padding: type == MessageEnum.text
                          ? const EdgeInsets.only(
                              left: 20,
                              right: 30,
                              top: 5,
                              bottom: 20,
                            )
                          : const EdgeInsets.only(
                              bottom: 25, left: 3, right: 3, top: 3),
                      child: Column(
                        children: [
                          if (isReplying) ...[
                            DisplayMessageType(
                              message: repliedText,
                              type: repliedMessageType,
                            ),
                          ],
                          DisplayMessageType(message: message, type: type),
                        ],
                      )),
                  Positioned(
                    bottom: 3,
                    right: 14,
                    child: Text(
                      date,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
