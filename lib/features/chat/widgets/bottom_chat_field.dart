// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:chitthi/common/enums/message_enums.dart';
import 'package:chitthi/common/providers/message_reply_provider.dart';
import 'package:chitthi/common/utils/utils.dart';
import 'package:chitthi/features/chat/widgets/message_reply_preview.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chitthi/features/chat/controller/chat_controller.dart';
// import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../colors.dart';
import '../../../common/widgets/cancel_reply.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String receiverUserId;
  final bool isGroupChat;
  const BottomChatField({
    super.key,
    required this.isGroupChat,
    required this.receiverUserId,
  });

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  bool isShowEmojiContainer = false;
  FocusNode focusNode = FocusNode();
  // FlutterSoundRecorder? _soundRecorder;
  bool isRecorderInit = false;
  bool isRecording = false;

  void sendTextMessage() async {
    print('controller me hai ye value ${_messageController.text.trim()}');
    if (isShowSendButton = true && _messageController.text != '') {
      ref.read(chatControllerProvider).sendTextMessage(
            context,
            _messageController.text.trim(),
            widget.receiverUserId,
            widget.isGroupChat,
          );
      setState(() {
        _messageController.text = "";
      });
    } else {
      var tempDir = await getTemporaryDirectory();
      var path = '${tempDir.path}/flutter_path.aac';
      if (!isRecorderInit) {
        return;
      }
      // if (isRecording) {
      //   await _soundRecorder!.stopRecorder();
      //   sendFileMessage(File(path), MessageEnum.audio);
      // } else {
      //   await _soundRecorder!.startRecorder(toFile: path);
      // }
      setState(() {
        isRecording = !isRecording;
      });
    }
    cancelReply(ref);
  }

  void sendFileMessage(File file, MessageEnum messageEnum) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.receiverUserId,
          messageEnum,
          widget.isGroupChat,
        );
  }

  void selectImage() async {
    File? file = await pickImageFromGallery(context);
    if (file != null) {
      sendFileMessage(file, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? file = await pickVideoFromGallery(context);
    if (file != null) {
      sendFileMessage(file, MessageEnum.video);
    }
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  void selectGif() async {
    final gif = await pickGif(context);
    if (gif != null) {
      // ignore: use_build_context_synchronously
      ref.read(chatControllerProvider).sendGifMessage(
            context,
            gif.toString(),
            widget.receiverUserId,
            widget.isGroupChat,
          );
    }
  }

  void openAudio() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      // throw RecordingPermissionException('Mic permission denied');
    }
    // await _soundRecorder!.openRecorder();
    isRecorderInit = true;
  }

  @override
  void initState() {
    // _soundRecorder = FlutterSoundRecorder();
    openAudio();
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    // _soundRecorder!.closeRecorder();
    isRecorderInit = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 7.0, top: 7),
      child: Column(
        children: [
          isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
          Row(
            children: [
              SizedBox(
                  child: Row(
                children: [
                  IconButton(
                    onPressed: toggleEmojiContainer,
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.grey,
                    ),
                  ),
                  IconButton(
                    onPressed: selectGif,
                    icon: const Icon(
                      Icons.gif,
                      size: 35,
                      color: Colors.grey,
                    ),
                  )
                ],
              )),
              Expanded(
                child: TextFormField(
                  // textAlign: TextAlign.center,
                  focusNode: focusNode,
                  controller: _messageController,
                  onChanged: (val) {
                    if (isShowEmojiContainer) {
                      hideEmojiContainer();
                    }
                    if (val.isNotEmpty) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    } else {
                      setState(() {
                        isShowSendButton = false;
                      });
                    }
                  },
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: darkbackgroundColor,
                    hintText: '  Type a message !',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.white),
                    // border: OutlineInputBorder(
                    //   borderRadius: BorderRadius.circular(20.0),
                    //   borderSide: const BorderSide(
                    //     width: 0.2,
                    //     style: BorderStyle.solid,
                    //   ),
                    // ),
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
              ),
              SizedBox(
                width: 100,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.photo_camera_back,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: selectVideo,
                      icon: const Icon(
                        Icons.video_camera_back,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                  foregroundColor: mobileChatBoxColor,
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: InkWell(
                      onTap: sendTextMessage,
                      child: Icon(
                        isShowSendButton
                            ? Icons.send
                            : isRecording
                                ? Icons.close
                                : Icons.mic,
                        color: primaryColor,
                      ))),
            ],
          ),
          isShowEmojiContainer
              ? SizedBox(
                  height: 310,
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      setState(() {
                        _messageController.text =
                            _messageController.text + emoji.emoji;
                      });

                      if (!isShowSendButton) {
                        setState(() {
                          isShowSendButton = true;
                        });
                      }
                    },
                  ))
              : const SizedBox(),
        ],
      ),
    );
  }
}
