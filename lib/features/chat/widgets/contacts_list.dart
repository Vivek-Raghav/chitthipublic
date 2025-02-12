import 'package:chitthi/common/widgets/loader.dart';
import 'package:chitthi/features/chat/controller/chat_controller.dart';
import 'package:chitthi/models/chat_contact.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../colors.dart';
import '../../../models/group.dart';
import '../screens/mobile_chat_screen.dart';


class ContactsList extends ConsumerWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context , WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<GroupModel>>(
            stream: ref.watch(chatControllerProvider).chatGroups(),
          builder: (context , snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Loader();
            }
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var groupData = snapshot.data![index];
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        // 
                        // Here the user will select chatContact and it will open the details or inbox of both chats
                        // 
                      Navigator.pushNamed(context, MobileChatScreen.routeName,arguments: {
                        'name': groupData.groupName,
                        'uid': groupData.groupId,
                        'isGroupChat':true,
                        'profilePic': groupData.groupPic,

                      });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: ListTile(
                          title: Text(
                            groupData.groupName,
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6.0),
                            child: Text(
                              groupData.lastMessage,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              groupData.groupPic,
                            ),
                            radius: 30,
                          ),
                          trailing: Text(
                            DateFormat.Hm().format(groupData.timeSent),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(color: dividerColor, indent: 85),
                  ],
                );
              },
            );
          }
        ),
            StreamBuilder<List<ChatContact>>(
                stream: ref.watch(chatControllerProvider).chatContact(),
              builder: (context , snapshot) {
                print("contact ki list me ye hai data $snapshot");
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Loader();
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var chatContactData = snapshot.data![index];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () {
                            // 
                            // Here the user will select chatContact and it will open the details or inbox of both chats
                            // 
                          print('or main ab navigate karra hu user ki taraf ${chatContactData.name}');
                          Navigator.pushNamed(context, MobileChatScreen.routeName,arguments: {
                            'name': chatContactData.name,
                            'uid': chatContactData.contactId,
                            'isGroupChat':false,
                            'profilePic':chatContactData.profilePic
                          });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ListTile(
                              title: Text(
                                chatContactData.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  chatContactData.lastMessage,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ),
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  chatContactData.profilePic,
                                ),
                                radius: 30,
                              ),
                              trailing: Text(
                                DateFormat.Hm().format(chatContactData.timeSent),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Divider(color: dividerColor, indent: 85),
                      ],
                    );
                  },
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
