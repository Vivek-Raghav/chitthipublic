class GroupModel {
  final String senderId;
  final String groupName;
  final String groupId;
  final String lastMessage;
  final String groupPic;
  final List<String> membersUID;
  final DateTime timeSent;

  GroupModel({
    required this.senderId,
    required this.groupName,
    required this.groupId,
    required this.lastMessage,
    required this.groupPic,
    required this.membersUID,
    required this.timeSent,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'groupName': groupName,
      'groupId': groupId,
      'lastMessage': lastMessage,
      'groupPic': groupPic,
      'membersUID': membersUID,
      'timeSent': timeSent.millisecondsSinceEpoch,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      senderId: map['senderId'] ?? '',
      groupName: map['groupName'] ?? '',
      groupId: map['groupId'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      groupPic: map['groupPic'] ?? '',
      membersUID: List<String>.from(map['membersUID']),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
    );
  }
}
