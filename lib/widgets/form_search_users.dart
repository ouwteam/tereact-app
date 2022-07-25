import 'package:flutter/material.dart';

class FormSearchUsers extends StatelessWidget {
  const FormSearchUsers({
    Key? key,
    required this.txtSearch,
  }) : super(key: key);

  final TextEditingController txtSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
