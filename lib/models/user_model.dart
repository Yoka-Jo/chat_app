class UserModel {
  String? email;
  String? name;
  String? phone;
  String? uId;
  String? image;
  String? coverImage;
  String? bio;
  UserModel({
    this.email,
    this.coverImage,
    this.name,
    this.phone,
    this.uId,
    this.image,
    this.bio
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    bio = json["bio"];
    email = json["email"];
    coverImage = json['coverImage'];
    name = json["name"];
    phone = json["phone"];
    uId = json["uId"];
    image = json["image"];
  }

  Map<String , dynamic> toMap(){
    return {
      "name": name,
      "bio": bio,
      "coverImage":coverImage,
      "email": email,
      "phone": phone,
      "uId": uId,
      "image": image,
    };
  }
}
