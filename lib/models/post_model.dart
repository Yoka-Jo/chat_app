class PostModel {
  String? name;
  String? image;
  String? dateTime;
  String? uId;
  String? text;
  String? postImage;
  String? postImageName;
  List<dynamic>? tags;
  String? postId;
  String? coverImage;

  PostModel({
    this.name,
    this.image,
    this.dateTime,
    this.uId,
    this.text,
    this.postImage,
    this.postImageName,
    this.tags,
    this.coverImage
  });

  PostModel.fromJson(Map<String, dynamic> json , String? jsonId) {
    name = json['name'];
    image = json['image'];
    dateTime = json['dateTime'];
    uId = json['uId'];
    text = json['text'];
    postImage = json['postImage'];
    postImageName = json['postImageName'];
    tags = json['tags'];
    coverImage = json['coverImage'];
   postId = jsonId!;
  }

  Map<String , dynamic> toMap(){
    return {
      "name": name,
      "image": image,
      "dateTime": dateTime,
      "uId": uId,
      "text": text,
      "postImage": postImage,
      "tags": tags,
      "postImageName": postImageName,
      "coverImage": coverImage,
    };
  }
}
