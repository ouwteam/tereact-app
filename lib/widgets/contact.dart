import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:tereact/entities/contact.dart';
import 'package:tereact/providers/user_provider.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  late List<Contact> listContact;
  late UserProvider up;
  static const imgSrc =
      "https://ptipd.uinjambi.ac.id/wp-content/uploads/2014/03/U-member-4-263x263.jpg";
  @override
  void initState() {
    super.initState();
    up = Provider.of<UserProvider>(context, listen: false);

    listContact = [];
    for (var i = 0; i < 12; i++) {
      listContact.add(
        Contact(
          id: i,
          userId: 100,
          guestId: i,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          user: up.getUserData!,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Kontak"),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_outlined),
          )
        ],
      ),
      body: StickyGroupedListView<Contact, String>(
        padding: const EdgeInsets.all(10),
        addAutomaticKeepAlives: true,
        floatingHeader: true,
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        elements: listContact,
        groupBy: (item) {
          return item.user.name[0];
        },
        groupSeparatorBuilder: (item) {
          return Container(
            height: 20,
            margin: const EdgeInsets.all(5),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                item.user.name[0],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            ),
          );
        },
        itemBuilder: (context, item) {
          return Container(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundImage: CachedNetworkImageProvider(imgSrc),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: Text(item.user.name),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
