class CommentModel {
  String? comment;
  String? commentName;
  String? commentImage;
  String? commentTime;
  String? commentId;
  String? postId;
  String? userId;

  CommentModel({
    required this.comment,
    required this.commentName,
    required this.commentTime,
    required this.commentImage,
    required this.postId,
    required this.userId
  });

  CommentModel.fromJson(Map<String , dynamic> json , String? id){
      comment = json["comment"];
      commentName = json["commentName"];
      commentImage = json["commentImage"];
      commentTime = json["commentTime"];
      postId = json["postId"];
      userId = json["userId"];
      commentId = id!;
  }

  Map<String , dynamic> toMap(){
    return {
     "comment":comment,
     "commentName":commentName,
     "commentImage":commentImage,
     "commentTime":commentTime,
     "postId":postId,
     "userId":userId,
    };
  }
}
