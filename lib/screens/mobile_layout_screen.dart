import 'dart:io';

import 'package:chitthi/common/utils/utils.dart';
import 'package:chitthi/features/auth/controller/auth_controller.dart';
import 'package:chitthi/features/groups/screens/create_group_screen.dart';
import 'package:chitthi/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:chitthi/features/status/screens/confirm_status_screen.dart';
import 'package:chitthi/features/status/screens/status_contacts_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../colors.dart';
import '../features/Calls/screens/calls_pickup_screen.dart';
import '../features/chat/widgets/contacts_list.dart';

class MobileLayoutScreen extends ConsumerStatefulWidget {
  const MobileLayoutScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends ConsumerState<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String username = "";
  late TabController tabBarController;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        print('resume');
        ref.read(authControllerProvider).setUserState(true);
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
        print('pause');
        ref.read(authControllerProvider).setUserState(false);
        break;
      case AppLifecycleState.hidden:
        print('hidden');
        break;
    }
  }

  Future<void> fetchUsername() async {
    try {
      DocumentSnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      // ignore: avoid_print
      print('Here is the $uid');

      if (snapshot.exists) {
        var userData = snapshot.data() as Map<String, dynamic>;
        // ignore: unnecessary_null_comparison
        var name = userData != null
            ? userData["name"] ?? "Default Name"
            : "Default Name";
        // ignore: avoid_print
        setState(() {
          username = name;
        });
      }
    } catch (error) {
      // ignore: avoid_print
      print("Error fetching username: $error");
    }
  }

  @override
  void initState() {
    super.initState();
    tabBarController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addObserver(this);
    fetchUsername();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: appBarColor,
          centerTitle: false,
          title: const Text(
            "Messages",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search, color: iconColors),
              onPressed: () {},
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert_sharp, color: iconColors),
              color: darkbackgroundColor,
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () => Future(() => Navigator.pushNamed(
                        context,
                        CreateGroupScreen.routeName,
                      )),
                  child: Text('Create group'),
                ),
              ],
            )
          ],
          bottom: TabBar(
            controller: tabBarController,
            indicatorColor: tabColor,
            indicatorWeight: 4,
            labelColor: tabColor,
            unselectedLabelColor: Color.fromARGB(255, 222, 212, 212),
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: [
              Tab(
                text: 'CHATS',
              ),
              Tab(
                text: 'STATUS',
              ),
              Tab(
                text: 'CALLS',
              ),
            ],
          ),
        ),
        body: TabBarView(controller: tabBarController, children: [
          const ContactsList(),
          StatusContactScreen(),
          StatusContactScreen(),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (tabBarController.index == 0) {
              Navigator.pushNamed(context, SelectContactScreen.routeName);
            } else {
              File? pickedFile = await pickImageFromGallery(context);
              if (pickedFile != null) {
                Navigator.pushNamed(context, ConfirmStatusScreen.routeName,
                    arguments: pickedFile);
              }
            }
          },
          backgroundColor: lightbackgroundColor.withOpacity(0.3),
          child: const Icon(
            Icons.message,
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}
