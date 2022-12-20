import 'package:flutter/material.dart';
import 'package:instagram/model/post.dart';
import 'package:instagram/pages/create_page.dart';
import 'package:instagram/services/auth.dart';
import 'package:instagram/services/pref.dart';
import 'package:instagram/services/rtdb.dart';

import 'sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = false;
  bool isLoading2 = false;

  List<PostModel> posts = [];

  _getPost() async {
    RTDB.getPost(await Pref.getUserId()).then((value) {
      setState(() {
        posts = value;
        isLoading = true;
      });
    });
  }

  _updatePosts() async {
    setState(() {
      isLoading2 = true;
    });
    Map? map = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => const CreatePage()));
    if (map != null) {
      _getPost();
      setState(() {
        isLoading2 = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getPost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Posts"),
        actions: [
          IconButton(
              onPressed: () {
                AuthService.logout().then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SignIn()));
                });
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _updatePosts();
        },
        child: const Icon(Icons.add),
      ),
      body: (isLoading)
          ? Container(
              margin: const EdgeInsets.all(20),
              child: ListView.builder(
                  itemCount: posts.length,
                  itemBuilder: ((context, index) => _postItem(posts[index]))),
            )
          : Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            ),
    );
  }
}

Widget _postItem(PostModel post) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: Colors.grey, borderRadius: BorderRadius.circular(20)),
    margin: const EdgeInsets.all(10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          post.title!,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          post.content!,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}
