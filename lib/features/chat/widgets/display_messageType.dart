import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chitthi/common/enums/message_enums.dart';
import 'package:chitthi/features/chat/widgets/video_player_item.dart';
import 'package:flutter/material.dart';

class DisplayMessageType extends StatelessWidget {
  final String message;
  final MessageEnum type;
  const DisplayMessageType(
      {super.key, required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    bool isPlay = false;
    AudioPlayer audioPlayer = AudioPlayer();
    return type == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(fontSize: 16),
          )
        : type == MessageEnum.audio
            ? StatefulBuilder(builder: (context, setState) {
                return IconButton(
                    constraints: const BoxConstraints(minWidth: 100),
                    onPressed: () async {
                      if (isPlay) {
                        await audioPlayer.pause();
                        setState(() {
                          isPlay = false;
                        });
                      } else {
                        await audioPlayer.play(UrlSource(message));
                        setState(() {
                          isPlay = true;
                        });
                      }
                    },
                    icon:
                        Icon(isPlay ? Icons.pause_circle : Icons.play_circle));
              })
            : type == MessageEnum.video
                ? VideoPlayerItem(videoUrl: message)
                : type == MessageEnum.gif
                    ? CachedNetworkImage(
                        imageUrl: message,
                        fit: BoxFit.cover,
                      )
                    : CachedNetworkImage(
                        imageUrl: message,
                        fit: BoxFit.cover,
                      );
  }
}
