// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

import 'package:chitthi/common/enums/message_enums.dart';
import 'package:chitthi/features/chat/widgets/display_messageType.dart';
import 'package:chitthi/features/chat/widgets/message_clipper.dart';

import '../../../colors.dart';

class MyMessageCard extends StatelessWidget {
  final String message;
  final String date;
  final MessageEnum type;
  final VoidCallback leftSwipe;
  final String repliedText;
  final String username;
  final MessageEnum repliedMessageType;
  final bool isSeen;
  const MyMessageCard({
    Key? key,
    required this.message,
    required this.date,
    required this.type,
    required this.leftSwipe,
    required this.repliedText,
    required this.username,
    required this.repliedMessageType,
    required this.isSeen,
  }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    final isReplying = repliedText.isNotEmpty;
    print("repliedMessageType $repliedMessageType");
    return SwipeTo(
      onLeftSwipe: leftSwipe,
      child: Align(
        alignment: Alignment.centerRight,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 120),
            child: Card(
              elevation: 1,
              shape: MessageBubbleShape(tailPosition: TailPosition.right),
              // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              color: myMessageColor,
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Stack(
                children: [
                  Padding(
                      padding: type==MessageEnum.text ? const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 5,
                        bottom: 20,
                      ):const EdgeInsets.only(bottom: 25,left: 3,right: 3,top:3),
                      child: Column(
                        children: [
                          if (isReplying)...[
                          DisplayMessageType(
                            message: repliedText,
                            type: repliedMessageType,
                          ),
                        ],
                          DisplayMessageType(message: message, type: type),
                        ],
                      )),
                  Positioned(
                    bottom: 2,
                    right: 10,
                    child: Row(
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white60,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                         Icon(
                          isSeen ? Icons.done_all : Icons.done,
                          size: 20,
                          color: isSeen? Colors.blue : Colors.white60,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
