abstract class SocialStates {}

class SocialInitialState extends SocialStates{}

//getUser
class SocialGetUserLoadingState extends SocialStates{}

class SocialGetUserSuccessState extends SocialStates{}

class SocialGetUserErrorState extends SocialStates {
  final String error;
  SocialGetUserErrorState(this.error);
}

//get Users
class SocialGetAllUsersLoadingState extends SocialStates{}

class SocialGetAllUsersSuccessState extends SocialStates{}

class SocialGetAllUsersErrorState extends SocialStates {
  final String error;
  SocialGetAllUsersErrorState(this.error);
}

//search in users
class SocialGetAllFilteredUsersSuccessState extends SocialStates{}

//changeNavigationBar
class SocialChangeBottomNavState extends SocialStates{}

//create post
class SocialCreatePostLoadingState extends SocialStates{}

class SocialCreatePostSuccessState extends SocialStates{}

class SocialCreatePostErrorState extends SocialStates{}

//delete post
class SocialDeletePostLoadingState extends SocialStates{}

class SocialDeletePostSuccessState extends SocialStates{}

class SocialDeletePostErrorState extends SocialStates{}

//remove Image
class SocialRemoveImageSuccessState extends SocialStates{}

//get Posts
class SocialGetPostsLoadingState extends SocialStates{}

class SocialGetPostsSuccessState extends SocialStates{}

class SocialGetPostsErrorState extends SocialStates {
  final String error;
  SocialGetPostsErrorState(this.error);
}

//get post Image
class SocialGetPostImageLoadingState extends SocialStates{}

class SocialGetPostImageSuccessState extends SocialStates{}

class SocialGetPostImageErrorState extends SocialStates {
  final String error;
  SocialGetPostImageErrorState(this.error);
}

//add hashTag
class SocialAddHashTagSuccessState extends SocialStates{}

//remove hashTag
class SocialRemoveHashTagSuccessState extends SocialStates{}

//like Post

class SocialLikePostSuccessState extends SocialStates{}

class SocialLikePostErrorState extends SocialStates {
  final String error;
  SocialLikePostErrorState(
     this.error,
  );
}

//send Messages
class SocialSendMessageSuccessState extends SocialStates{}

class SocialSendMessageErrorState extends SocialStates {
  final String error;
  SocialSendMessageErrorState(this.error);
}

//get Messages
class SocialGetMessagesLoadingState extends SocialStates{}
class SocialGetMessagesSuccessState extends SocialStates{}

//delete Message
class SocialDeleteMessageSuccessState extends SocialStates{}

class SocialDeleteMessageErrorState extends SocialStates{}

//get user profileImage
class SocialGetProfileImageSuccessState extends SocialStates{}

class SocialGetProfileImageErrorState extends SocialStates{}

//get user profileImage
class SocialGetCoverImageSuccessState extends SocialStates{}

class SocialGetCoverImageErrorState extends SocialStates{}

//update user
class SocialUpdateUserLoadingState extends SocialStates{}

class SocialUpdateUserSuccessState extends SocialStates{}

class SocialUpdateUserErrorState extends SocialStates{}

//send Comments

class SocialSendCommentSuccessState extends SocialStates{}

class SocialSendCommentErrorState extends SocialStates{}

//get Comments
class SocialGetCommentSuccessState extends SocialStates{}

//delete Comment
class SocialDeleteCommentSuccessState extends SocialStates{}

class SocialDeleteCommentErrorState extends SocialStates{}

//get Image for chat
class SocialGetMessageForChatSuccessState extends SocialStates{}

class SocialDeleteMessageForChatSuccessState extends SocialStates{}

class SocialGetMessageForChatErrorState extends SocialStates{}
