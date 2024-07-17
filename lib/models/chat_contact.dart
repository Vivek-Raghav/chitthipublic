import 'package:cloud_firestore/cloud_firestore.dart';

class ChatContact {
  final String name;
  final String profilePic;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage;

  ChatContact(
      {required this.name,
      required this.profilePic,
      required this.contactId,
      required this.timeSent,
      required this.lastMessage});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'contactId': contactId,
      'timeSent': timeSent,
      'lastMessage': lastMessage,
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
        name: map['name'] ?? '',
        profilePic: map['profilePic'] ?? '',
        contactId: map['contactId'] ?? '',
        timeSent: DateTime.fromMillisecondsSinceEpoch((map['timeSent'] as Timestamp).millisecondsSinceEpoch),
        lastMessage: map['lastMessage'] ?? '');
  }
  // String toJson()=> json.encode(toMap());

  // factory ChatContact.fromJson(String source)=> ChatContact.fromMap(json)
}
