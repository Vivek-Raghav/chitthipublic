// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chitthi/features/Calls/repository/call_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chitthi/features/auth/controller/auth_controller.dart';
import 'package:uuid/uuid.dart';
import '../../../models/call_model.dart';

final callControllerProvider = Provider((ref) {
  final callRepository = ref.read(callRepositoryProvider);
  return CallController(
    callRepository: callRepository,
    ref: ref,
    auth: FirebaseAuth.instance,
  );
});

class CallController {
  final CallRepository callRepository;
  final ProviderRef ref;
  final FirebaseAuth auth;

  CallController({
    required this.callRepository,
    required this.ref,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream => callRepository.callStream;

  void endCall(
    BuildContext context,
    String callerId,
    String receiverId,
  ) {
    callRepository.endCall(context, callerId, receiverId);
  }

  void makeCall(
    BuildContext context,
    String receiverName,
    String receiverUid,
    String recieverProfilePic,
    bool isGroupChat,
  ) {
    ref.read(userDataAuthProvider).whenData((value) {
      String callId = Uuid().v1();
      CallModel senderCallData = CallModel(
        callerId: auth.currentUser!.uid,
        callerName: value!.name,
        callerPic: value.profilePic,
        receiverId: receiverUid,
        receiverName: receiverName,
        receiverPic: recieverProfilePic,
        callId: callId,
        hasDialed: true,
      );
      CallModel receiverCallData = CallModel(
        callerId: auth.currentUser!.uid,
        callerName: value.name,
        callerPic: value.profilePic,
        receiverId: receiverUid,
        receiverName: receiverName,
        receiverPic: recieverProfilePic,
        callId: callId,
        hasDialed: false,
      );
      if (isGroupChat) {
        callRepository.createGroupCall(
            context, senderCallData, receiverCallData);
      } else {
        callRepository.createCall(context, senderCallData, receiverCallData);
      }
    });
  }
}
