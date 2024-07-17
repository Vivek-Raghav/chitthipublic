import 'dart:io';

import 'package:chitthi/colors.dart';
import 'package:chitthi/common/utils/utils.dart';
import 'package:chitthi/features/groups/controller/group_%20controller.dart';
import 'package:chitthi/features/groups/widgets/select_contacts_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectGroupContacts = StateProvider<List<Contact>>(
  (ref) => [],
);

class CreateGroupScreen extends ConsumerStatefulWidget {
  static const String routeName = '/create-group-screen';
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  TextEditingController groupNameController = TextEditingController();
  File? image;

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void createGroup() {
    if (groupNameController.text.trim().isNotEmpty) {
      ref.read(GroupControllerProvider).createGroup(
            context,
            groupNameController.text.trim(),
            image!,
            ref.read(
              selectGroupContacts,
            ),
          );
          ref.read(selectGroupContacts.notifier).update((state) => []);
          
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create group'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 20,
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
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 15, top: 15),
              child: TextField(
                controller: groupNameController,
                decoration: InputDecoration(hintText: 'Enter group name'),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Select contact',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
              ),
            ),
            const SelectContactsGroup()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createGroup,
        backgroundColor: tabColor,
        child: Icon(Icons.done),
      ),
    );
  }
}
