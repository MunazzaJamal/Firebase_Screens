import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Stream collectionStream =
    FirebaseFirestore.instance.collection('users').snapshots();

//Stream documentStream = FirebaseFirestore.instance.collection('users').doc('ABC123').snapshots();
class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('users').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Stream Builder Screen'),
      ),
      body: Streambuild(context),
    );
  }

  Widget Streambuild(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return ListTile(
              title: Text(data['name']),
              subtitle: Text(data['email']),
            );
          }).toList(),
        );
      },
    );
  }
}
