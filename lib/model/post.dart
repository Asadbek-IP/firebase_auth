class PostModel {
  String? title;
  String? content;
  String? userId;
  PostModel(this.title, this.content, this.userId);

  PostModel.fromJson(Map json) {
    title = json["title"];
    content = json["content"];
    userId = json["userId"];
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'userId': userId,
    };
  }
}
