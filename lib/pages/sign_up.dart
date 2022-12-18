import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram/pages/sign_in.dart';
import 'package:instagram/services/auth.dart';
import 'package:instagram/services/pref.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController? nameController = TextEditingController();
  TextEditingController? emailController = TextEditingController();

  TextEditingController? passController = TextEditingController();

  TextEditingController? rePassController = TextEditingController();

  bool isLoading = false;

  _signUp() {
    String? name = nameController!.text.trim();
    String? email = emailController!.text.trim();
    String? parol = passController!.text.trim();
    String? rePass = rePassController!.text.trim();

    if (name.isEmpty || email.isEmpty || parol.isEmpty || rePass.isEmpty) {
      return;
    }

    if (parol != rePass) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    AuthService.signUp(email, parol).then((value) {
      _saveId(value);
      setState(() {
        isLoading = false;
      });
    });
  }

  _saveId(User? user) async {
    if (user != null) {
      await Pref.saveUserId(user.uid);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => SignIn()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Biron bir xato bo'ldi")));
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
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Name"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: "Email"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: passController,
                  decoration: InputDecoration(labelText: "Parol"),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: rePassController,
                  decoration: InputDecoration(labelText: "Qayta parol"),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    _signUp();
                  },
                  child: const Text("Sign Up"),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Ro'yxatdan o'tganmisiz?"),
                    const SizedBox(
                      width: 5,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => SignIn()));
                        },
                        child: const Text("Sign In"))
                  ],
                )
              ],
            ),
          ),
        
        isLoading? Center(child: CircularProgressIndicator(color: Colors.black,),):Container()
        
        ],
      ),
    );
  }
}
