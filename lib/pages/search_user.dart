import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tereact/common/helper.dart';
import 'package:tereact/entities/user.dart';
import 'package:tereact/providers/user_provider.dart';

class SearchUserPage extends StatefulWidget {
  const SearchUserPage({Key? key}) : super(key: key);

  @override
  State<SearchUserPage> createState() => _SearchUserPageState();
}

class _SearchUserPageState extends State<SearchUserPage> {
  final txtSearch = TextEditingController();
  late UserProvider up;
  late Future<List<User>> futurInstance;

  Future<List<User>> handleSearchAction({bool clear = false}) async {
    if (clear) {
      return [];
    }

    try {
      final result =
          up.findUsers(context, user: up.getUserData!, search: txtSearch.text);
      return result;
    } catch (e) {
      final snack = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }

    return [];
  }

  @override
  void initState() {
    super.initState();
    Helper.authChecker(context);
    up = Provider.of<UserProvider>(context, listen: false);
    futurInstance = handleSearchAction();

    txtSearch.addListener(() {
      if (txtSearch.text.length < 3) {
        setState(() {
          futurInstance = handleSearchAction(clear: true);
        });
        return;
      }

      setState(() {
        futurInstance = handleSearchAction();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color.fromARGB(33, 158, 158, 158),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.search_outlined),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextFormField(
                  controller: txtSearch,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Cari dengan email/phone/nama",
                    hintStyle: TextStyle(fontSize: 11),
                  ),
                  cursorColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Batal",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      ),
      body: FutureBuilder(
        future: futurInstance,
        builder: (context, snapshot) {
          if (snapshot.hasData != true) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData && snapshot.data != null) {
            List<User> list = snapshot.data as List<User>;
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundImage:
                            CachedNetworkImageProvider(item.getAvatar()),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 12),
                        child: Text(item.name),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const Center(
            child: Text("Loading failed!"),
          );
        },
      ),
    );
  }
}
