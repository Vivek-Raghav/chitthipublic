import 'dart:io';
import 'package:chitthi/common/utils/utils.dart';
import 'package:chitthi/features/auth/controller/auth_controller.dart';
// import 'package:chitthi/features/auth/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserInformation extends ConsumerStatefulWidget {
  static const String routeName = '/user-information';
  const UserInformation({super.key});

  @override
  ConsumerState<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends ConsumerState<UserInformation> {
  final nameController = TextEditingController();
  File? image;
  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void storeUserData() async {
    String name = nameController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveUserDataToFirebase(context, name, image);
    }
    // ignore: avoid_print
    print("storing data in firebase");
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                          'https://cdn-icons-png.flaticon.com/512/149/149071.png?w=740&t=st=1681120648~exp=1681121248~hmac=56a628e508875fd33525770bcfb36322b69cd3106aa193b92796d6a066c34621',
                        ),
                      )
                    : CircleAvatar(
                        radius: 64, backgroundImage: FileImage(image!)),
                Positioned(
                  bottom: -10,
                  right: -10,
                  child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo)),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: size.width * 0.85,
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: "Enter Your name",
                    ),
                  ),
                ),
                IconButton(
                    onPressed: storeUserData, icon: const Icon(Icons.send))
              ],
            )
          ],
        ),
      )),
    );
  }
}
