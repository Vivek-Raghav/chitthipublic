import 'dart:io';
import 'package:chitthi/common/repositories/common_firebase_storage_repository.dart';
import 'package:chitthi/common/utils/utils.dart';
import 'package:chitthi/models/user_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../models/status_model.dart';

final statusRepositoryProvider = Provider(
  (ref) => StatusRepository(
    firestore: FirebaseFirestore.instance,
    auth: FirebaseAuth.instance,
    ref: ref,
  ),
);

class StatusRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;
  StatusRepository({
    required this.firestore,
    required this.auth,
    required this.ref,
  });

  void uploadStatus({
    required String username,
    required String profilePic,
    required String phoneNumber,
    required File statusImage,
    required BuildContext context,
  }) async {
    try {
      var statusId = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imgUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storageFileToFirebase(
            '/status/$statusId$uid',
            statusImage,
          );
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      List<String> whoCanSee = [];
      for (int i = 0; i < contacts.length; i++) {
        var registerPhoneNumber = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .get();
        if (registerPhoneNumber.docs.isNotEmpty) {
          var userData = UserModel.fromMap(registerPhoneNumber.docs[0].data());
          whoCanSee.add(userData.uid);
        }
      }
      List<String> statusImageUrls = [];
      var snapshot = await firestore
          .collection('status')
          .where('uid', isEqualTo: auth.currentUser!.uid)
          .get();
      if (snapshot.docs.isNotEmpty) {
        Status status = Status.fromMap(snapshot.docs[0].data());
        statusImageUrls = status.photoUrl;
        statusImageUrls.add(imgUrl);
        await firestore
            .collection('status')
            .doc(snapshot.docs[0].id)
            .update({'photoUrl': statusImageUrls});
      } else {
        statusImageUrls = [imgUrl];
      }
      Status status = Status(
          uid: uid,
          username: username,
          phoneNumber: phoneNumber,
          photoUrl: statusImageUrls,
          createdAt: DateTime.now(),
          profilePic: profilePic,
          statusId: statusId,
          whoCanSee: whoCanSee);
      await firestore.collection('status').doc(statusId).set(status.toMap());
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  // Future<List<Status>> getStatus(BuildContext context) async {
  //   List<Status> statusData = [];
  //   // Status status = Status(uid: auth.currentUser!.uid, username: 'demo', phoneNumber: 'demo', photoUrl: ['https://firebasestorage.googleapis.com/v0/b/chatapp-chitthi.appspot.com/o/status%2F836a98e0-63d1-11ee-8b5f-976a3941f35a7hMylFHaUbbUEjVzR898rOzztyu1?alt=media&token=d9ca851f-a994-414d-913b-ac69ddd80776'], createdAt: DateTime.fromMicrosecondsSinceEpoch(24), profilePic: 'https://img.freepik.com/premium-vector/gray-avatar-icon-vector-illustration_276184-163.jpg', statusId: 'statusId', whoCanSee: []);
  //   // statusData.add(status);
  //   try {
  //     List<Contact> contacts = [];
  //     if (await FlutterContacts.requestPermission()) {
  //       contacts = await FlutterContacts.getContacts(withProperties: true);
  //     }
  //     for (int i = 0; i < contacts.length; i++) {
  //       var statusesSnapshot = await firestore
  //           .collection('status')
  //           .where(
  //             'phoneNumber',
  //             isEqualTo: contacts[i].phones[0].number.replaceAll(
  //                   ' ',
  //                   '',
  //                 ),
  //           )
  //           .where(
  //             'createdAt',
  //             isGreaterThan: DateTime.now()
  //                 .subtract(const Duration(hours: 24))
  //                 .millisecondsSinceEpoch,
  //           )
  //           .get();
  //           print('status data ${statusesSnapshot.docs}');
  //       for (var tempData in statusesSnapshot.docs) {
  //         print('yooooooooo');
  //         Status tempStatus = Status.fromMap(tempData.data());
  //         if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
  //           statusData.add(tempStatus);
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     if (kDebugMode) print(e);
  //     showSnackBar(context: context, content: e.toString());
  //   }
  //   return statusData;
  // }

  Future<List<Status>> getStatus(BuildContext context) async {
  List<Status> statusData = [];

  try {
    // Fetch the status of the currently authenticated user
    var ownStatusesSnapshot = await firestore
        .collection('status')
        .where('uid', isEqualTo: auth.currentUser!.uid)
        .where(
          'createdAt',
          isGreaterThan: DateTime.now().subtract(const Duration(hours: 24)).millisecondsSinceEpoch,
        )
        .get();

    for (var tempData in ownStatusesSnapshot.docs) {
      Status tempStatus = Status.fromMap(tempData.data());
      if (!statusData.contains(tempStatus)) { // Avoid duplicates
        statusData.add(tempStatus);
      }
    }

    List<Contact> contacts = [];    

    print("Requesting Contacts Permission...");
    if (await FlutterContacts.requestPermission()) {
      print("Permission granted. Fetching contacts...");
      contacts = await FlutterContacts.getContacts(withProperties: true);
    } else {
      print("Permission denied. Cannot fetch contacts.");
      showSnackBar(context: context, content: "Contacts permission denied");
      return statusData;
    }

    print("Total Contacts: ${contacts.length}");

    for (int i = 0; i < contacts.length; i++) {
      if (contacts[i].phones.isEmpty) {
        print("Contact at index $i does not have a phone number.");
        continue;
      }

      String cleanedPhoneNumber = contacts[i].phones[0].number.replaceAll(' ', '');

      print("Querying Firestore for number: $cleanedPhoneNumber");

      var statusesSnapshot = await firestore
          .collection('status')
          .where('phoneNumber', isEqualTo: cleanedPhoneNumber)
          .where(
            'createdAt',
            isGreaterThan: DateTime.now()
                .subtract(const Duration(hours: 24))
                .millisecondsSinceEpoch,
          )
          .get();

      print("Fetched ${statusesSnapshot.docs.length} statuses for number: $cleanedPhoneNumber");

      for (var tempData in statusesSnapshot.docs) {
        Status tempStatus = Status.fromMap(tempData.data());
        if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
          statusData.add(tempStatus);
        }
      }
    }
  } catch (e) {
    print("Error encountered: $e");
    showSnackBar(context: context, content: e.toString());
  }

  print("Total Statuses fetched: ${statusData.length}");

  return statusData;
}
}
