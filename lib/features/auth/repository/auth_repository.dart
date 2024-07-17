import 'dart:io';

import 'package:chitthi/common/repositories/common_firebase_storage_repository.dart';
import 'package:chitthi/common/utils/utils.dart';
import 'package:chitthi/features/auth/screens/user_information_screen.dart';
import 'package:chitthi/models/user_models.dart';
import 'package:chitthi/screens/mobile_layout_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/otp_screen.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    auth: FirebaseAuth.instance, firestore: FirebaseFirestore.instance));

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepository({required this.auth, required this.firestore});

  Future<UserModel?> getCurrentUserData() async {
    try {
      var userData =
          await firestore.collection('users').doc(auth.currentUser?.uid).get();

      UserModel? user;
      if (userData.data() != null) {
        user = UserModel.fromMap(userData.data()!);
      }
      return user;
    } catch (e) {
      throw e.toString();
    }
  }

//
// SignInWithPhone , Here we are creating an function to check whether the number is accpetable or there any error
//
  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      // ignore: avoid_print
      print('I am trying to sign in with phone number');
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: ((String verificationId, int? resendToken) async {
          // ignore: avoid_print
          print("OTP message has been sent successfully");
          Navigator.pushNamed(
            context,
            OTPScreen.routeName,
            arguments: verificationId,
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }
//
//
//

//
// here we are verifying the OTP we received from firebase and will check whether the user has entered a valid OTP
//
  void verifyOTP(
      {required BuildContext context,
      required String verificationId,
      required String userOTP}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      // ignore: avoid_print
      print(
          'Here I am veriifying otp and pushing the user to next page after that');
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
          context, UserInformation.routeName, (route) => false);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }
//
//
//

//
// Here we are saving the data which we will get from userInformation page and will set the data according to the users details in firebase
//

//
//
//
//
  void saveUserData({
    required String name,
    required File? profilePic,
    required ProviderRef ref,
    required BuildContext context,
  }) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoURL =
          'https://cdn-icons-png.flaticon.com/512/149/149071.png?w=740&t=st=1681120648~exp=1681121248~hmac=56a628e508875fd33525770bcfb36322b69cd3106aa193b92796d6a066c34621';
      if (profilePic != null) {
        ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storageFileToFirebase('profilePic/$uid', profilePic);
      }
      var user = UserModel(
          name: name,
          uid: uid,
          profilePic: photoURL,
          isOnline: true,
          phoneNumber: auth.currentUser!.phoneNumber!,
          groupId: []);
      firestore.collection('users').doc(uid).set(user.toMap());
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MobileLayoutScreen()),
          (route) => false);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  //
  //
  //
  Stream<UserModel> userData(String userID) {
    return firestore
        .collection('users')
        .doc(userID)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

  //
  //
  //
  //  State of app
  //
  //
  void setUserState(bool isOnline) async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .update({'isOnline': isOnline});
  }
}
