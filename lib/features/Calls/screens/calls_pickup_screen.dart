// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chitthi/features/Calls/controller/call_controller.dart';
import 'package:chitthi/features/Calls/screens/call_screen.dart';

import '../../../models/call_model.dart';

class CallPickUpScreen extends ConsumerWidget {
  final Widget scaffold;
  const CallPickUpScreen({
    required this.scaffold,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ref.watch(callControllerProvider).callStream,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.data() != null) {
          CallModel call = CallModel.fromMap(
            snapshot.data!.data() as Map<String, dynamic>,
          );

          if (!call.hasDialed) {
            return Scaffold(
              body: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Incoming Call',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    CircleAvatar(
                      backgroundImage: NetworkImage(call.callerPic),
                      radius: 60,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Text(
                      call.callerName,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            // await Agorclient!.engine.leaveChannel();
                            ref.read(callControllerProvider).endCall(
                                  context,
                                  call.callerId,
                                  call.receiverId,
                                );
                            Navigator.pop(context);
                          },
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Color.fromARGB(255, 84, 53, 50),
                            child: Center(
                              child: Icon(
                                Icons.call_end,
                                color: Color.fromARGB(255, 255, 17, 0),
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return CallScreen(
                                  channelId: call.callId,
                                  call: call,
                                  isGroupChat: false);
                            }));
                          },
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor:
                                const Color.fromARGB(255, 44, 84, 45),
                            child: Center(
                              child: InkWell(
                                child: Icon(
                                  Icons.call,
                                  color: Colors.greenAccent,
                                  size: 50,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        }
        return scaffold;
      },
    );
  }
}
