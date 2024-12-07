import 'package:fire_base/firebase_adduser.dart';
import 'package:fire_base/firebase_getuser.dart';
import 'package:fire_base/firebase_getuser_realtime.dart';
import 'package:fire_base/firebase_login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
TextEditingController nameController = TextEditingController();

class FirebaseSignup extends StatefulWidget {
  const FirebaseSignup({super.key});

  @override
  State<FirebaseSignup> createState() => _FirebaseSignupState();
}

class _FirebaseSignupState extends State<FirebaseSignup> {
  registeruser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      print('User registered: ${userCredential.user?.email}');
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'User Registered!',
          message: '${userCredential.user?.email} has been added.',
          contentType: ContentType.success,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FirebaseLogin()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        const snackBar = SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Can not Register!',
            message: 'The account already exists for that email.',
            contentType: ContentType.failure,
          ),
        );
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
      } else if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else {
        print('Error: ${e.message}');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png',
                  height: 300, width: 200, fit: BoxFit.cover),
              // const SizedBox(height: 10),
              const Text('FireBase SignUp',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 50),
              SizedBox(
                width: 500,
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      obscureText: false,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                    // const SizedBox(
                    //     height: 10), // Add spacing between TextFields
                    // TextField(
                    //   controller: nameController,
                    //   obscureText: false,
                    //   decoration: const InputDecoration(
                    //     border: OutlineInputBorder(),
                    //     labelText: 'name',
                    //   ),
                    // ),
                    const SizedBox(
                        height: 10), // Add spacing between TextFields
                    TextField(
                      controller: passwordController,
                      obscureText: true, // To hide password text
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                    const SizedBox(height: 20), // Add spacing before the button
                    ElevatedButton(
                      onPressed: () async {
                        await registeruser();
                      }, // for login function
                      child: const Text('Register user'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const FirebaseLogin()));
                      }, // Call the login function
                      child: const Text('Already have an account? Login'),
                    ),
                    const SizedBox(height: 40),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          customButton(
                              screen: FirebaseAddUser(),
                              icon: Icons.person_add,
                              msg: 'Add User.',
                              clr: Colors.blue),
                          const SizedBox(height: 10),
                          customButton(
                              screen: GetFirebaseUser(),
                              icon: Icons.person_2_rounded,
                              msg: 'Future Builder Screen',
                              clr: Colors.green),
                          const SizedBox(height: 10),
                          customButton(
                              screen: UserInformation(),
                              icon: Icons.person_2_rounded,
                              msg: 'Stream Builder Screen',
                              clr: Colors.red),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget customButton({screen, icon, msg, clr}) {
    return Tooltip(
      message: msg,
      child: ElevatedButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => screen,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(15),
        ),
        child: Icon(
          icon,
          color: clr,
        ),
      ),
    );
  }
}
