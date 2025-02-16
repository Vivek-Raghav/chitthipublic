import 'package:chitthi/common/utils/utils.dart';
import 'package:chitthi/models/user_models.dart';
import 'package:chitthi/features/chat/screens/mobile_chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectContactRepositoryProvider = Provider(
    (ref) => SelectContactRepository(firestore: FirebaseFirestore.instance));

class SelectContactRepository {
  final FirebaseFirestore firestore;

  SelectContactRepository({required this.firestore});
  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    return contacts;
  }

  void selectContact(Contact selectContact, BuildContext context) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFound = false;
      for (var document in userCollection.docs) {
        var userData = UserModel.fromMap(document.data());
        String selectContactNum =
            selectContact.phones[0].number.replaceAll(' ', '');
        if (selectContactNum == userData.phoneNumber) {
          isFound = true;
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, MobileChatScreen.routeName,
              arguments: {'name': userData.name, 'uid': userData.uid,});
        }
      }
      if (!isFound) {
        // ignore: use_build_context_synchronously
        showSnackBar(
            context: context, content: 'This number don\'t exist on this');
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
