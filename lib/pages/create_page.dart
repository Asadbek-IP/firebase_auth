import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:instagram/model/post.dart';
import 'package:instagram/services/pref.dart';
import 'package:instagram/services/rtdb.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  bool isLoading = false;

  _addPost() async {
    setState(() {
       isLoading = true;
    });
    String? title = titleController.text;
    String? content = contentController.text;

    PostModel post = PostModel(title, content, await Pref.getUserId());

   RTDB.addPost(post).then((value) {
    setState(() {
      isLoading = false;
    });
    Navigator.pop(context,{"info":"malumot yangillandi"});
   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Malumotlarni qo'shish")),
      body: Stack(
        children: [
          Container(
              margin: const EdgeInsets.all(30),
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: "Title"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: contentController,
                    decoration: InputDecoration(labelText: "Content"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _addPost();
                      },
                      child: const Text("Add Post"))
                ],
              )),
         isLoading ? Center(child: CircularProgressIndicator(),):Container()
        
        ],
      ),
    );
  }
}
