import 'dart:io';
import 'package:chitthi/common/repositories/common_firebase_storage_repository.dart';
import 'package:chitthi/common/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../models/group.dart';

final groupRepositoryProvider = Provider(
  (ref) => GroupRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class GroupRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  GroupRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void createGroup(
    BuildContext context,
    String groupName,
    File profilePic,
    List<Contact> selectContact,
  ) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < selectContact.length; i++) {
        var userCollection = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: selectContact[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .get();
        if (userCollection.docs.isNotEmpty && userCollection.docs[0].exists) {
          uids.add(userCollection.docs[0].data()['uid']);
        }
      }



      var groupId = Uuid().v1();


      String profileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storageFileToFirebase('/group/$groupId', profilePic);
      GroupModel group = GroupModel(
        senderId: auth.currentUser!.uid,
        groupName: groupName,
        groupId: groupId,
        lastMessage: '',
        groupPic: profileUrl,
        membersUID: [auth.currentUser!.uid, ...uids],
        timeSent: DateTime.now(),
      );
      await firestore.collection('groups').doc(groupId).set(
            group.toMap(),
          );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
