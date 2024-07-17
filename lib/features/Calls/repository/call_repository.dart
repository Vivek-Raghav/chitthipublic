import 'package:chitthi/common/utils/utils.dart';
import 'package:chitthi/features/Calls/screens/call_screen.dart';
import 'package:chitthi/models/call_model.dart';
import 'package:chitthi/models/group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final callRepositoryProvider = Provider(
  (ref) => CallRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
  ),
);

class CallRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CallRepository({
    required this.firestore,
    required this.auth,
  });

  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('call').doc(auth.currentUser!.uid).snapshots();

  void createCall(
    BuildContext context,
    CallModel senderCallData,
    CallModel receiverCallData,
  ) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());
      await firestore
          .collection('call')
          .doc(receiverCallData.receiverId)
          .set(receiverCallData.toMap());

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
            channelId: senderCallData.callId,
            call: senderCallData,
            isGroupChat: false,
          ),
        ),
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void createGroupCall(
    BuildContext context,
    CallModel senderCallData,
    CallModel receiverCallData,
  ) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());

      var groupData = await firestore
          .collection('groups')
          .doc(senderCallData.receiverId)
          .get();
      GroupModel groupModel = GroupModel.fromMap(groupData.data()!);

      for (var id in groupModel.membersUID) {
        await firestore.collection('call').doc(id).set(
              receiverCallData.toMap(),
            );
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return CallScreen(
            channelId: senderCallData.callId,
            call: senderCallData,
            isGroupChat: true);
      }));
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endCall(
    BuildContext context,
    String callerId,
    String receiverId,
  ) async {
    try {
      await firestore.collection('call').doc(callerId).delete();
      await firestore.collection('call').doc(receiverId).delete();

      Navigator.pop(context);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void endGroupCall(
    BuildContext context,
    String callerId,
    String receiverId,
  ) async {
    try {
      await firestore.collection('call').doc(callerId).delete();
      var groupSnapshot =
          await firestore.collection('groups').doc(receiverId).get();
      GroupModel group = GroupModel.fromMap(groupSnapshot.data()!);
      for (var id in group.membersUID) {
        await firestore.collection('call').doc(id).delete();
      }

      Navigator.pop(context);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
