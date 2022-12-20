import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:instagram/model/post.dart';

class RTDB {
  static final rtdb = FirebaseDatabase.instance.ref();

  static Future<Stream<DatabaseEvent>> addPost(PostModel post) async {
    rtdb.child("post").push().set(post.toMap());
    return rtdb.onChildAdded;
  }
  
  static Future<List<PostModel>> getPost(String? id) async {
    List<PostModel> posts = [];
    Query query = rtdb.ref.child("post").orderByChild("userId").equalTo(id);
    DatabaseEvent event = await query.once();

    var snapshot = event.snapshot;

    snapshot.children.forEach((element) {
      var jsonPost = jsonEncode(element.value);
      Map map = jsonDecode(jsonPost);
      PostModel post = PostModel.fromJson(map);
      posts.add(post);
    });

    return posts;
  }
}
