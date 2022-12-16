import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/pages/sign_up.dart';
import 'package:instagram/services/auth.dart';
import 'package:instagram/services/pref.dart';
import 'home_page.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController parolController = TextEditingController();

  bool isLoading = false;

  _signIn() {
    setState(() {
      isLoading = true;
    });
    String? email = emailController.text.trim();
    String? parol = parolController.text.trim();

    if (email.isEmpty || parol.isEmpty) {
      return;
    }

    AuthService.signIn(email, parol).then((user) {
      getUserId(user);
    });
  }

  getUserId(User? user) async {
    setState(() {
      isLoading = false;
    });
    if (user != null) {
      await Pref.saveUserId(user.uid);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
      print(user.uid);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Email yoki parol xato")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: parolController,
                  decoration: InputDecoration(labelText: "Parol"),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    _signIn();
                  },
                  child: const Text("Sign In"),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Ro'yxatdan o'tmaganmisz?"),
                    const SizedBox(
                      width: 5,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUp()));
                        },
                        child: const Text("Sign Up"))
                  ],
                )
              ],
            ),
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container()
        ],
      ),
    );
  }
}
