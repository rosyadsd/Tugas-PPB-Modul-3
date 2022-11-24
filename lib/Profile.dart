import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final List nama = [
    "Rosyad Shidqi Dikpimmas",
    "Rina Santika",
    "Muhammad Rofiul Anam",
    "Rifky Hernanda",
  ];
  final List nim = [
    "(21120120140161)",
    "(21120120120030)",
    "(21120120140135)",
    "(21120120130082)",
  ];

  ProfilePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Color.fromARGB(255, 0, 48, 144),
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
                title: Text(nama[index],
                    style: const TextStyle(color: Colors.black)),
                subtitle: Text(nim[index],
                    style: const TextStyle(color: Colors.black)),
                leading: CircleAvatar(
                  child: Text(nama[index][0],
                      style: const TextStyle(color: Colors.black)),
                )),
          );
        },
        itemCount: nama.length,
      ),
    );
  }
}
