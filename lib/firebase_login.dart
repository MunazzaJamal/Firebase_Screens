import 'package:fire_base/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

//registered email: abc@gmail.com
//password: abc#@!

class FirebaseLogin extends StatefulWidget {
  const FirebaseLogin({super.key});

  @override
  State<FirebaseLogin> createState() => _FirebaseLoginState();
}

class _FirebaseLoginState extends State<FirebaseLogin> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  login() async {
    print("Email: ${emailController.text}");
    print("Password: ${passwordController.text}");
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      print('Login successful: ${credential.user?.email}');
      final snackBar = SnackBar(
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        content: AwesomeSnackbarContent(
          title: 'Login Successful!',
          message: 'Welcome ${credential.user?.email}',
          contentType: ContentType.success,
        ),
      );
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const Home()), // replace with your screen
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        print('No user found for that email.');
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Login Failed'),
              content: const Text('Wrong User email or password.'),
              actions: [
                TextButton(
                  onPressed: () {
                    // Close the dialog and allow user to try again
                    Navigator.of(context).pop();
                  },
                  child: const Text('Try Again'),
                ),
              ],
            );
          },
        );
      } else {
        print('Else condition: ${e.code}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Login Screen'),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png',
                height: 300, width: 200, fit: BoxFit.cover),
            const SizedBox(height: 10),
            const Text('FireBase Login',
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
                  const SizedBox(height: 10), // Add spacing between TextFields
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
                      await login();
                    }, // Call the login function
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
