import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yoka_chat_app/layout/cubit/states.dart';
import 'package:yoka_chat_app/models/comment_model.dart';
import 'package:yoka_chat_app/models/message_model.dart';
import 'package:yoka_chat_app/models/post_model.dart';
import 'package:yoka_chat_app/models/user_model.dart';
import 'package:yoka_chat_app/modules/home/home_screen.dart';
import 'package:yoka_chat_app/modules/settings/settings_screen.dart';
import 'package:yoka_chat_app/modules/users/users_screen.dart';
import 'package:yoka_chat_app/shared/components/constants.dart';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());

  UserModel? userModel;

  static SocialCubit get(context) => BlocProvider.of(context);

//getUser
  void getUser() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection("users").doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data() ?? {});
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

//get All users
  List<UserModel>? users = [];
  void getUsers() {
    users = [];
    emit(SocialGetAllUsersLoadingState());
    FirebaseFirestore.instance.collection("users").get().then((value) {
      for (var element in value.docs) {
        users!.add(UserModel.fromJson(element.data()));
      }
      emit(SocialGetAllUsersSuccessState());
    }).catchError((error) {
      emit(SocialGetAllUsersErrorState(error.toString()));
    });
  }

//search in users
  List<UserModel> filteredUsers = [];
  void searchForAUser(String section) {
    filteredUsers = users!
        .where((element) => element.name!.toLowerCase().contains(section))
        .toList();
    emit(SocialGetAllFilteredUsersSuccessState());
  }

//get user profileImage
  File? profileImage;
  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(SocialGetProfileImageSuccessState());
    } else {
      emit(SocialGetProfileImageErrorState());
    }
  }

//get user coverImage
  File? coverImage;
  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(SocialGetCoverImageSuccessState());
    } else {
      emit(SocialGetCoverImageErrorState());
    }
  }

//void update profilePic
  void updateProfileImage(
      {bool updateAll = false, String? name, String? bio, String? phone}) {
    FirebaseStorage.instance
        .ref()
        .child("users/${Uri.file(profileImage!.path).pathSegments.last}")
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        if (updateAll) {
          updateCoverImage(
              name: name, bio: bio, phone: phone, profileImage: value);
        }
        if (!updateAll) {
          updateUser(name: name, bio: bio, phone: phone, profileImage: value);
        }
      }).catchError((error) {
        emit(SocialUpdateUserErrorState());
      });
    }).catchError((error) {
      emit(SocialUpdateUserErrorState());
    });
  }

//void update profilePic
  void updateCoverImage(
      {String? name, String? bio, String? phone, String? profileImage}) {
    FirebaseStorage.instance
        .ref()
        .child("users/${Uri.file(coverImage!.path).pathSegments.last}")
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUser(name: name, bio: bio, phone: phone, coverImage: value);
        emit(SocialUpdateUserSuccessState());
      }).catchError((error) {
        emit(SocialUpdateUserErrorState());
      });
    }).catchError((error) {
      emit(SocialUpdateUserErrorState());
    });
  }

//update User
  void updateUser(
      {String? name,
      String? bio,
      String? phone,
      String? profileImage,
      String? coverImage}) {
    UserModel model = UserModel(
        name: name!.isEmpty ? userModel!.name : name,
        bio: bio!.isEmpty ? userModel!.bio : bio,
        phone: phone!.isEmpty ? userModel!.phone : phone,
        email: userModel!.email,
        uId: userModel!.uId,
        image: profileImage ?? userModel!.image,
        coverImage: coverImage ?? userModel!.coverImage);
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      coverImage = null;
      profileImage = null;
      getUser();
    }).catchError((error) {
      emit(SocialUpdateUserErrorState());
    });
  }

//choose what to update
  Future<void> updateUserAndImage(
      {String? name, String? bio, String? phone}) async {
    emit(SocialUpdateUserLoadingState());
    if (profileImage != null && coverImage != null) {
      updateProfileImage(
        updateAll: true,
        name: name,
        bio: bio,
        phone: phone,
      );
    } else if (profileImage != null) {
      updateProfileImage(
        name: name,
        bio: bio,
        phone: phone,
      );
    } else if (coverImage != null) {
      updateCoverImage(
        name: name,
        bio: bio,
        phone: phone,
      );
    } else {
      updateUser(
        name: name,
        bio: bio,
        phone: phone,
      );
    }
  }

//createPost
  void createPost({
    required String dateTime,
    required String text,
    postImage,
    postImageName,
  }) {
    emit(SocialCreatePostLoadingState());
    PostModel postModel = PostModel(
      uId: userModel!.uId,
      name: userModel!.name,
      image: userModel!.image,
      dateTime: dateTime,
      text: text,
      tags: hashTagsList,
      postImage: postImage,
      postImageName: postImageName,
      coverImage: userModel!.coverImage,
    );
    clearPostImage();
    FirebaseFirestore.instance
        .collection('posts')
        .add(postModel.toMap())
        .then((value) {
      hashTagsList = [];
      getPosts();
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

//delete Post
/*
  List<String>? postsILiked = [];
  List<Map<String, int>>? numberOfLikes = [];
*/
  void deletePost({required String? postId}) {
    PostModel? backupPost =
        posts!.firstWhere((element) => element.postId == postId);

    int? indexOfPost = posts!.indexWhere((element) => element.postId == postId);

    int? indexOfPostNumberOfLikes =
        numberOfLikes!.indexWhere((element) => element.keys.contains(postId));

    posts!.removeAt(indexOfPost);
    numberOfLikes!.removeAt(indexOfPostNumberOfLikes);
    postsILiked!.remove(postId);

    emit(SocialDeletePostLoadingState());

    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .delete()
        .then((value) {
      if (backupPost!.postImage != null) {
        FirebaseStorage.instance
            .ref()
            .child("posts/${backupPost!.postImageName}")
            .delete()
            .then((value) {

          emit(SocialDeletePostSuccessState());
          return;
        }).catchError((error) {
          posts!.insert(indexOfPost!, backupPost!);
          postsILiked!.add(postId.toString());
          postsILiked!.insert(indexOfPostNumberOfLikes!, postId.toString());
          emit(SocialDeletePostErrorState());
        });
      }
      backupPost = indexOfPost = indexOfPostNumberOfLikes = null;
      if (posts!.isEmpty) {
        posts = null;
      }
      emit(SocialDeletePostSuccessState());
    }).catchError((error) {
      posts!.add(backupPost!);
      emit(SocialDeletePostErrorState());
    });
  }

//clear Post Image
  void clearPostImage() {
    postImage = null;
    emit(SocialRemoveImageSuccessState());
  }

//get posts and likes

  List<PostModel>? posts = [];
  List<String>? postsILiked = [];
  List<Map<String, int>>? numberOfLikes = [];
  String? test = "Posts";
  void getPosts() {
    posts = [];
    postsILiked = [];
    numberOfLikes = [];
    emit(SocialGetPostsLoadingState());
    FirebaseFirestore.instance.collection("posts").get().then((value) {
      if (value.docs.isEmpty) {
        posts = null;
        emit(SocialGetPostsErrorState("NO POSTS"));
        return;
      }
      for (var post in value.docs) {
        post.reference.collection("likes").get().then((value) {
          for (var like in value.docs) {
            if (like.id == uId) postsILiked!.add(post.id);
          }
          numberOfLikes!.add({post.id: value.docs.length});
          posts!.add(PostModel.fromJson(post.data(), post.id));
          emit(SocialGetPostsSuccessState());
        }).catchError((error) {
          emit(SocialGetPostsErrorState(error.toString()));
        });
      }
    }).catchError((error) {
      emit(SocialGetPostsErrorState(error.toString()));
    });
  }

//post Image then Post
  void uploadImageThenPost({required String dateTime, required String text}) {
    posts = [];
    postsILiked = [];
    numberOfLikes = [];
    emit(SocialCreatePostLoadingState());
    FirebaseStorage.instance
        .ref()
        .child("posts/${Uri.file(postImage!.path).pathSegments.last}")
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
            dateTime: dateTime,
            text: text,
            postImage: value,
            postImageName: Uri.file(postImage!.path).pathSegments.last);
      }).catchError((error) {
        emit(SocialCreatePostErrorState());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState());
    });
  }

//get post Image
  final picker = ImagePicker();
  File? postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialGetPostImageSuccessState());
    } else {
      emit(SocialGetPostImageErrorState("No Image Selected"));
    }
  }

//post hashtags
  List<String> hashTagsList = [];
  void addHashTag(String hashTag) {
    hashTagsList.add(hashTag);
    emit(SocialAddHashTagSuccessState());
  }

  //delete hashTag
  void removeHashTag(String hashTag) {
    hashTagsList.remove(hashTag);
    emit(SocialRemoveHashTagSuccessState());
  }

//like Post
  void likePost(String postId) {
    var editNumberOfLikes;
    var like = postsILiked!
        .firstWhere((element) => element == postId, orElse: () => "");

    if (like != "") {
      editNumberOfLikes =
          numberOfLikes!.firstWhere((element) => element.keys.contains(postId));
      editNumberOfLikes[postId] = editNumberOfLikes[postId] - 1;
      postsILiked!.removeWhere((element) => element == postId);
      FirebaseFirestore.instance
          .collection("posts")
          .doc(postId)
          .collection("likes")
          .doc(userModel!.uId)
          .delete()
          .then((value) {
        emit(SocialLikePostSuccessState());
      }).catchError((error) {
        emit(SocialLikePostErrorState(error.toString()));
      });
      return;
    }
    postsILiked!.add(postId);
    editNumberOfLikes =
        numberOfLikes!.firstWhere((element) => element.keys.contains(postId));
    editNumberOfLikes[postId] = editNumberOfLikes[postId] + 1;
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("likes")
        .doc(userModel!.uId)
        .set({"like": true}).then((value) {
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

//send message
  void sendMessage({
    required String message,
    required String receiverId,
  }) {
    String dateTime = DateTime.now().toString();
    late MessageModel model;
    //set user messages
    model = MessageModel(
        message: message,
        receiverId: receiverId,
        senderId: userModel!.uId,
        time: dateTime,
        withWhom: receiverId);
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.uId)
        .collection("chat")
        .doc(receiverId)
        .collection("messages")
        .doc(dateTime)
        .set(model.toMap())
        .then((value) => emit(SocialSendMessageSuccessState()))
        .catchError(
            (error) => emit(SocialSendMessageErrorState(error.toString())));
    //set receiver messages
    model = MessageModel(
        message: message,
        receiverId: receiverId,
        senderId: userModel!.uId,
        time: dateTime,
        withWhom: userModel!.uId);
    FirebaseFirestore.instance
        .collection("users")
        .doc(receiverId)
        .collection("chat")
        .doc(userModel!.uId)
        .collection("messages")
        .doc(dateTime)
        .set(model.toMap())
        .then((value) => emit(SocialSendMessageSuccessState()))
        .catchError(
            (error) => emit(SocialSendMessageErrorState(error.toString())));
  }

//get Chat's Image
  File? imageForChat;
  void getChatImage(bool fromGallery) async {
    final pickedFile = await picker.pickImage(
        source: fromGallery ? ImageSource.gallery : ImageSource.camera);
    if (pickedFile != null) {
      imageForChat = File(pickedFile.path);
      emit(SocialGetMessageForChatSuccessState());
    } else {
      emit(SocialGetMessageForChatErrorState());
    }
  }

//send Chat's Image
  Future<void> sendImageInChat(String receiverId) async {
    File? chatImage = imageForChat!;
    clearChatImage();

    FirebaseStorage.instance
        .ref()
        .child("imagesForChat/${Uri.file(chatImage.path).pathSegments.last}")
        .putFile(chatImage)
        .then((value) {
      chatImage = null;
      value.ref.getDownloadURL().then((value) {
        sendMessage(message: value, receiverId: receiverId);
      });
    });
  }

  //clear Chat's Image
  void clearChatImage() {
    imageForChat = null;
    emit(SocialDeleteMessageForChatSuccessState());
  }

//delete Message
  void deleteMessage(String friendId, String dateTime, bool deleteForEveryOne) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.uId)
        .collection("chat")
        .doc(friendId)
        .collection("messages")
        .doc(dateTime)
        .delete()
        .then((value) {
      if (deleteForEveryOne) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(friendId)
            .collection("chat")
            .doc(userModel!.uId)
            .collection("messages")
            .doc(dateTime)
            .delete()
            .then((value) {
          emit(SocialDeleteMessageSuccessState());
        }).catchError((error) {
          emit(SocialDeleteMessageErrorState());
        });
      } else {
        emit(SocialDeleteMessageSuccessState());
      }
    }).catchError((error) {
      emit(SocialDeleteMessageErrorState());
    });
  }

//send comments
  void sendComment(String postId, String comment) {
    CommentModel model = CommentModel(
        postId: postId,
        comment: comment,
        commentName: userModel!.name,
        commentTime: DateTime.now().toString(),
        commentImage: userModel!.image,
        userId: userModel!.uId);
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .add(model.toMap())
        .then((value) {
      emit(SocialSendCommentSuccessState());
    }).catchError((error) {
      emit(SocialSendCommentErrorState());
    });
  }

//get comments
  List<CommentModel> comments = [];

  void getComments(String postId) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .orderBy("commentTime", descending: true)
        .snapshots()
        .listen((event) {
      comments = [];
      for (var element in event.docs) {
        comments.add(CommentModel.fromJson(element.data(), element.id));
      }
      emit(SocialGetCommentSuccessState());
    });
  }

//delete comment
  void deleteComment(String postId, String commentId) {
    FirebaseFirestore.instance
        .collection("posts")
        .doc(postId)
        .collection("comments")
        .doc(commentId)
        .delete()
        .then((value) {
      emit(SocialDeleteCommentSuccessState());
    }).catchError((error) {
      emit(SocialDeleteCommentErrorState());
    });
  }

//change Nav
  List<Widget> navScreens = const [
    HomeScreen(),
    UsersScreen(),
    SettingsScreen(),
  ];

  List<String> titles = const ["Home", "Users", "settings"];
  int navIndex = 0;

  void changeNavScreen(int index) {
    navIndex = index;
    emit(SocialChangeBottomNavState());
  }
}
