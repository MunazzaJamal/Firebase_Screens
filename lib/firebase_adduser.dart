import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_signup.dart';

class FirebaseAddUser extends StatefulWidget {
  const FirebaseAddUser({super.key});

  @override
  State<FirebaseAddUser> createState() => _FirebaseAddUserState();
}

class _FirebaseAddUserState extends State<FirebaseAddUser> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  addUser() async {
    await users
        .add({
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
        })
        .then(
          (value) => print('User Added'),
        )
        .catchError(
          (error) => print("Failed to add user: $error"),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('User Details'),
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              const Text('Enter User Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 10), // Add spacing between TextFields
              TextField(
                controller: nameController,
                obscureText: false,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'name',
                ),
              ),
              const SizedBox(height: 10), // Add spacing between TextFields
              TextField(
                controller: passwordController,
                obscureText: true, // To hide password text
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    addUser();
                  },
                  child: const Text('Add User..'))
            ],
          ),
        ),
      ),
    );
  }
}
