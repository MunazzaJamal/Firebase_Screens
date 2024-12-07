import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetFirebaseUser extends StatefulWidget {
  const GetFirebaseUser({super.key});

  @override
  State<GetFirebaseUser> createState() => _GetFirebaseUserState();
}

class _GetFirebaseUserState extends State<GetFirebaseUser> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text(
            'FutureBuilder Screen',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        body: FutureBuilder(
          future: users.get(),
          builder: (context, snapShot) {
            if (snapShot.hasData) {
              return ListView.builder(
                itemCount: snapShot.data!.docs.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text("${snapShot.data!.docs[index]['name']}"),
                    subtitle: Text("${snapShot.data!.docs[index]['email']}"),
                  );
                },
              );
            }
            return const Center(child: RefreshProgressIndicator());
          },
        ));
  }
}
