import 'package:flutter/material.dart';

class SearchUserPage extends StatelessWidget {
  const SearchUserPage({Key? key}) : super(key: key);

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
      body: const Center(
        child: Text("Search user page"),
      ),
    );
  }
}
