// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:io';

import 'package:chitthi/common/enums/message_enums.dart';
import 'package:chitthi/common/providers/message_reply_provider.dart';
import 'package:chitthi/common/utils/utils.dart';
import 'package:chitthi/features/auth/controller/auth_controller.dart';
import 'package:chitthi/features/chat/repositories/chat_repository.dart';
import 'package:chitthi/models/chat_contact.dart';
import 'package:chitthi/models/group.dart';
import 'package:chitthi/models/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContact() {
    return chatRepository.getChatContacts();
  }

  Stream<List<GroupModel>> chatGroups() {
    return chatRepository.getChatGroups();
  }

  Stream<List<Message>> chatStream(String receiverUserId) {
    return chatRepository.getChatStream(receiverUserId);
  }

  Stream<List<Message>> groupChatStream(String groupId) {
    return chatRepository.getGroupChatStream(groupId);
  }

  void sendTextMessage(
    BuildContext context,
    String text,
    String receiverUserId,
    bool isGroupChat,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref
        .read(userDataAuthProvider)
        .whenData((value) => chatRepository.sendTextMessage(
              context: context,
              text: text,
              receiverUserId: receiverUserId,
              senderUser: value!,
              messageReply: messageReply,
              isGroupChat: isGroupChat,
            ));
  }

  void sendFileMessage(
    BuildContext context,
    File file,
    String receiverUserId,
    MessageEnum messageEnum,
    bool isGroupChat,
  ) {
    final messageReply = ref.read(messageReplyProvider);
    ref
        .read(userDataAuthProvider)
        .whenData((value) => chatRepository.sendFileMessage(
              context: context,
              file: file,
              ref: ref,
              messageEnum: messageEnum,
              receiverUserId: receiverUserId,
              senderUserData: value!,
              messageReply: messageReply,
              isGroupChat: isGroupChat,
            ));
  }

  void sendGifMessage(
    BuildContext context,
    String gifUrl,
    String receiverUserId,
    bool isGroupChat,
  ) {
    String jsonString = gifUrl;
    String? urlContent;
    final messageReply = ref.read(messageReplyProvider);
    try {
      Map<String, dynamic> parsedJson = json.decode(jsonString);
      urlContent = parsedJson['url'];
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
    String gifUrlPartIndex = urlContent!.split('-').last;
    String newGifUrlpart = "https://i.giphy.com/media/$gifUrlPartIndex/200.gif";

    ref
        .read(userDataAuthProvider)
        .whenData((value) => chatRepository.sendGifMessage(
              context: context,
              gifUrl: newGifUrlpart,
              receiverUserId: receiverUserId,
              senderUser: value!,
              messageReply: messageReply,
              isGroupChat: isGroupChat,
            ));
  }

  void setChatMessageSeen(
    BuildContext context,
    String receiverUserId,
    String messageId,
  ) {
    chatRepository.setChatMessageSeen(
      context,
      receiverUserId,
      messageId,
    );
  }
}
