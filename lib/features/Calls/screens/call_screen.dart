import 'package:chitthi/common/widgets/loader.dart';
import 'package:chitthi/config/config.dart';
import 'package:chitthi/features/Calls/controller/call_controller.dart';
import 'package:chitthi/models/call_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agora_uikit/agora_uikit.dart';

class CallScreen extends ConsumerStatefulWidget {
  final String channelId;
  final CallModel call;
  final bool isGroupChat;

  CallScreen({
    super.key,
    required this.channelId,
    required this.call,
    required this.isGroupChat,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  AgoraClient? agoraClient;
  String baseUrl = 'http://localhost:8080/';

  void initAgora() async {
    await agoraClient!.initialize();
  }

  @override
  void initState() {
    super.initState();
    agoraClient = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: AgoraConfig.appId,
        channelName: widget.channelId,
        tokenUrl: baseUrl,
      ),
    );
    initAgora();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calls'),
        centerTitle: true,
      ),
      body: agoraClient == null
          ? const Loader()
          : SafeArea(
              child: Stack(
                children: [
                  AgoraVideoViewer(
                    client: agoraClient!,
                    layoutType: Layout.floating,
                    enableHostControls:
                        true, // Add this to enable host controls
                  ),
                  AgoraVideoButtons(
                    client: agoraClient!,
                    addScreenSharing:
                        false, // Add this to enable screen sharing
                    disconnectButtonChild: IconButton(
                        onPressed: () async {
                          await agoraClient!.engine.leaveChannel();
                          ref.read(callControllerProvider).endCall(
                                context,
                                widget.call.callerId,
                                widget.call.receiverId,
                              );
                        },
                        icon: Icon(Icons.call_end)),
                  ),
                ],
              ),
            ),
    );
  }
}
