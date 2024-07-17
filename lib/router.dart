import 'dart:io';

import 'package:chitthi/common/widgets/error.dart';
import 'package:chitthi/features/auth/screens/login_screen.dart';
import 'package:chitthi/features/auth/screens/user_information_screen.dart';
import 'package:chitthi/features/groups/screens/create_group_screen.dart';
import 'package:chitthi/features/select_contacts/screens/select_contacts_screen.dart';
import 'package:chitthi/features/chat/screens/mobile_chat_screen.dart';
import 'package:chitthi/features/status/screens/confirm_status_screen.dart';
import 'package:chitthi/features/status/screens/status_screen.dart';
import 'package:flutter/material.dart';
import 'features/auth/screens/otp_screen.dart';
import 'models/status_model.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      );
    case OTPScreen.routeName:
      final verificationId = routeSettings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
      );
    case UserInformation.routeName:
      // final verificationId = routeSettings.arguments as String;
      return MaterialPageRoute(
        builder: (context) => const UserInformation(),
      );
    case SelectContactScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const SelectContactScreen());
    case MobileChatScreen.routeName:
      final arguments = routeSettings.arguments as Map<String, dynamic>;
      final name = arguments['name'];
      final uid = arguments['uid'];
      final isGroupChat = arguments['isGroupChat'];
      final profilePic = arguments['profilePic'];
      return MaterialPageRoute(
          builder: (context) => MobileChatScreen(
                name: name,
                uid: uid,
                isGroupChat: isGroupChat,
                profilePic:profilePic
              ));
    case ConfirmStatusScreen.routeName:
      final file = routeSettings.arguments as File;
      return MaterialPageRoute(
          builder: (context) => ConfirmStatusScreen(
                file: file,
              ));
    case StatusScreen.routeName:
      final status = routeSettings.arguments as Status;
      return MaterialPageRoute(
          builder: (context) => StatusScreen(
                status: status,
              ));
    case CreateGroupScreen.routeName:
      // final status = routeSettings.arguments as Status;
      return MaterialPageRoute(
          builder: (context) => CreateGroupScreen(
                // status: status,
              ));
    default:
      return MaterialPageRoute(
          builder: (context) => const Scaffold(
                body: ErrorScreen(error: "This page doesn't exist"),
              ));
  }
}
