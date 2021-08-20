import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:yoka_chat_app/layout/cubit/cubit.dart';
import 'package:yoka_chat_app/models/post_model.dart';
import 'package:yoka_chat_app/models/user_model.dart';
import 'package:yoka_chat_app/modules/comments/comments_screen.dart';
import 'package:yoka_chat_app/modules/show_image/show_image_screen.dart';
import 'package:yoka_chat_app/modules/users_profile/users_profile_screen.dart';
import 'package:yoka_chat_app/shared/components/constants.dart';
import 'package:yoka_chat_app/shared/styles/icon_broken.dart';

class DefaultTextFormField extends StatelessWidget {
  final double formCurves;
  final double formborderThickness;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final String? hintText;
  final IconButton? suffixIcon;
  final Widget? prefixIcon;
  final bool isEnabled;
  final bool isTransparent;
  final bool? isObscured;
  final bool isHintSettings;
  final TextEditingController? textEditingController;
  final TextInputType? textInputType;

  const DefaultTextFormField({
    Key? key,
    this.validator,
    this.isHintSettings = false,
    this.isTransparent = false,
    this.formborderThickness = 2,
    this.formCurves = 25.0,
    this.prefixIcon,
    this.onSaved,
    this.hintText,
    this.suffixIcon,
    this.isEnabled = true,
    this.isObscured,
    this.textEditingController,
    this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(
          color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
      keyboardType: textInputType,
      obscureText: isObscured ?? false,
      controller: textEditingController,
      validator: validator,
      enabled: isEnabled,
      onSaved: onSaved,
      cursorColor: Colors.black,
      decoration: InputDecoration(
          filled: isTransparent,
          fillColor: !isTransparent ? Colors.grey.shade300 : null,
          errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1),
              borderRadius: BorderRadius.all(Radius.circular(formCurves))),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: !isTransparent
                      ? kOutlineInputBorderColor
                      : Colors.transparent,
                  width: formborderThickness),
              borderRadius: BorderRadius.all(Radius.circular(formCurves))),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10.0),
          suffixIcon: coloredIcon(suffixIcon),
          prefixIcon: coloredIcon(prefixIcon),
          hintText: hintText,
          hintStyle: TextStyle(
              color: !isHintSettings ? Colors.grey : Colors.black,
              fontSize: 15.0,
              fontWeight: isHintSettings ? FontWeight.bold : null),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: !isTransparent ? Colors.black : Colors.transparent,
                  width: formborderThickness),
              borderRadius: BorderRadius.all(Radius.circular(formCurves))),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: !isTransparent
                      ? kOutlineInputBorderColor
                      : Colors.transparent,
                  width: formborderThickness),
              borderRadius: BorderRadius.all(Radius.circular(formCurves)))),
    );
  }
}

Widget defaultButton({Widget? image}) => Container(
      height: 65,
      width: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color(0xffFF69B4),
      ),
      child: Container(
          height: 65,
          width: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.black54,
          ),
          child: Center(
            child: image,
          )),
    );

class LogoButton extends StatelessWidget {
  final Function onTap;
  final String buttonText;
  const LogoButton({Key? key, required this.buttonText, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(1.5),
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(30)),
        ),
        child: Container(
          height: 58,
          width: 320,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            gradient: LinearGradient(colors: [
              kFirstGradientButtonColor,
              kSecondGradientButtonColor,
            ]),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Container()),
              Text(
                buttonText,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(1),
                        margin: const EdgeInsets.only(right: 10.0),
                        decoration: const BoxDecoration(
                            color: Colors.black, shape: BoxShape.circle),
                        height: 45,
                        width: 45,
                        child: FittedBox(
                          child: FloatingActionButton(
                            child: ShaderMask(
                              blendMode: BlendMode.srcIn,
                              shaderCallback: (Rect bounds) {
                                return ui.Gradient.linear(
                                  const Offset(10, 24.0),
                                  const Offset(28.0, 4.0),
                                  const [
                                    kFirstGradientButtonColor,
                                    kSecondGradientButtonColor,
                                  ],
                                );
                              },
                              child: const Icon(
                                Icons.add,
                                size: 35,
                              ),
                            ),
                            onPressed: () {},
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//0xff581845

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );

void navigateAndFinish(
  context,
  widget,
) =>
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      (route) {
        return false;
      },
    );

Widget myDivider() => Container(
      width: double.infinity,
      height: 1.0,
      color: Colors.grey[300],
    );

Widget circleImage(
        {String? image, double radius = 35, bool isStatus = false}) =>
    CircleAvatar(
      radius: radius + 4.0,
      backgroundColor: isStatus ? const Color(0xffe18b8b) : Colors.transparent,
      // Color(0xffcd3e3e) , Color(0xff862323)

      child: CircleAvatar(
        radius: radius + 1.5,
        backgroundColor: isStatus ? Colors.white : Colors.transparent,
        child: CircleAvatar(
          radius: radius,
          backgroundImage: NetworkImage(image ??
              "https://image.freepik.com/free-vector/laptop-with-program-code-isometric-icon-software-development-programming-applications-dark-neon_39422-971.jpg"),
        ),
      ),
    );

Widget toCreatePostButton({void Function()? onPressed}) => ClipRRect(
      borderRadius: BorderRadius.circular(20.0),
      child: MaterialButton(
        color: Colors.grey.shade300,
        clipBehavior: ui.Clip.antiAlias,
        onPressed: onPressed,
        height: 50,
        child: Row(
          children: [
            coloredIcon(Icons.search),
            const SizedBox(
              width: 10.0,
            ),
            const Text(
              "What's in your mind?",
              style: TextStyle(color: Colors.black38, fontSize: 15.0),
            )
          ],
        ),
      ),
    );

Widget coloredIcon(dynamic icon) => ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: (Rect bounds) {
      return ui.Gradient.linear(
          const Offset(10, 24.0),
          const Offset(28.0, 10.0),
          const [Color(0xffe59b9b), Color(0xff471313)]);
    },
    child: icon is IconData ? Icon(icon) : icon);

dynamic defaultSnackBar(context, {String? text}) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text ?? "" , textAlign: TextAlign.center,),
      backgroundColor: Colors.red.shade800,
    ));

Widget defaultPost(SocialCubit cubit, int i,
        {bool fromProfile = true, String? id}) =>
    Builder(builder: (context) {
      List<PostModel>? posts = cubit.posts;
      List<String>? postsILiked = cubit.postsILiked;
      List<Map<String, int>>? numberOfLikes = cubit.numberOfLikes;
      UserModel user =
          cubit.users!.firstWhere((element) => element.uId == posts![i].uId);
      return Column(
        children: [
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            padding: const EdgeInsets.only(
              top: 10.0,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  spreadRadius: 3,
                  offset: Offset(0, 10),
                )
              ],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (user.uId !=
                                  uId) {
                                navigateTo(
                                    context,
                                    UsersProfileScreen(
                                      userModel: user,
                                    ));
                              }
                              return;
                            },
                            child: circleImage(
                                image: user.image
                                    .toString(),
                                radius: 25.0,
                                isStatus: false),
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Text(
                                    user.name
                                        .toString(),
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2)),
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.blue,
                                  size: 15.0,
                                ),
                              ]),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(posts![i].dateTime.toString().split(" ")[0],
                                  style: const TextStyle(
                                      fontSize: 12.0,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w600,
                                      height: 0.5)),
                            ],
                          ),
                          const Spacer(),
                          if (posts[i].uId == uId)
                            PopupMenuButton(
                                elevation: 10.0,
                                color: Colors.red.shade900,
                                icon: coloredIcon(
                                  const Icon(Icons.more_vert),
                                ),
                                itemBuilder: (_) => [
                                      PopupMenuItem(
                                        onTap: () {
                                          cubit.deletePost(
                                              postId: posts[i].postId);
                                        },
                                        height: 10,
                                        padding: EdgeInsets.zero,
                                        child: Row(
                                          children: [
                                            Icon(Icons.delete,
                                                color: Colors.teal.shade400),
                                            const Text(
                                              "Delete this post",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ])
                        ],
                      ),
                      if (posts[i].postImage == null)
                      const SizedBox(height: 15.0,),
                      Text(
                        posts[i].text.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14.0),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      if (posts[i].postImage != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: InkWell(
                            onTap: () {
                              navigateTo(context,
                                  ShowImageScreen(posts[i].postImage!));
                            },
                            child: Container(
                              height: 250.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  4.0,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(posts[i].postImage!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      if (posts[i].tags!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: posts[i]
                                  .tags!
                                  .map((hashTag) => Text("#" + hashTag,
                                      style:const TextStyle(
                                          color: Colors.blue,
                                          fontWeight: ui.FontWeight.bold)))
                                  .toList()),
                        ),
                      Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  cubit.likePost(posts[i].postId.toString());
                                },
                                child: Icon(
                                  IconBroken.Heart,
                                  color: postsILiked!
                                          .contains(posts[i].postId.toString())
                                      ? Colors.red
                                      : Colors.grey,
                                  size: 28.0,
                                ),
                              ),
                              Text(
                                "${numberOfLikes![i][posts[i].postId]}",
                                style: const TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          ))
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Container(
                  height: 50,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0)),
                      gradient: LinearGradient(
                          colors: [
                            // Color(0xffd4ebf2) , Color(0xfff7e3ed)

                            Color(0xffcd3e3e),

                            Color(0xff862323)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: InkWell(
                      onTap: () {
                        navigateTo(
                            context, CommentsScreen(post: posts[i], index: i));
                      },
                      child: Row(
                        children: const [
                          Icon(
                            IconBroken.Chat,
                            color: Colors.white,
                          ),
                          SizedBox(width: 75.0),
                          Text("Write a comment ....",
                              style: TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white70)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (i == posts.length - 1)
            const SizedBox(
              height: 150.0,
            )
        ],
      );
    });

Widget defaultComments(TextEditingController commentController,
        Function? onPressed, SocialCubit cubit, PostModel post, int? i) =>
    Builder(builder: (context) {
      var comments = cubit.comments
          .where((element) => element.postId == post.postId)
          .toList();
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: 551.0,
          margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          padding: const EdgeInsets.only(
            top: 10.0,
          ),
          decoration: BoxDecoration(
            color: Colors.white,

            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                spreadRadius: 3,
                offset: Offset(0, 10),
              )
            ],

            // color: Colors.black,

            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 16.0,
                              backgroundColor: Colors.black,
                              child: CircleAvatar(
                                  radius: 15.0,
                                  backgroundColor: Colors.red.shade500,
                                  child: Text(
                                    cubit.numberOfLikes![i!.toInt()]
                                            [post.postId]
                                        .toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0,
                                        color: Colors.white),
                                  )),
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            const Text(
                              "Likes",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            cubit.likePost(post.postId.toString());
                          },
                          icon: Icon(IconBroken.Heart),
                          color: cubit.postsILiked!
                                  .contains(post.postId.toString())
                              ? Colors.red
                              : Colors.grey,
                        )
                      ],
                    ),
                    myDivider(),
                    SizedBox(
                      height: 440.0,
                      child: ListView.separated(
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (context, i) => Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: InkWell(
                                  onLongPress: () {
                                    if (comments[i].userId == uId) {
                                      showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                                title: Text("Are you sure?"),
                                                content: Text(
                                                    "you are about to delete this comment"),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text("No")),
                                                  TextButton(
                                                      onPressed: () {
                                                        cubit.deleteComment(
                                                            post.postId
                                                                .toString(),
                                                            comments[i]
                                                                .commentId
                                                                .toString());
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text("Ok")),
                                                ],
                                              ));
                                    }
                                    return;
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      circleImage(
                                          radius: 20.0,
                                          image: comments[i].commentImage),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 8.0),
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade300,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(10.0)),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  comments[i]
                                                      .commentName
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black),
                                                ),
                                                const SizedBox(
                                                  height: 5.0,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    comments[i]
                                                        .comment
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            comments[i]
                                                .commentTime!
                                                .split(" ")[0]
                                                .toString(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black45),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          separatorBuilder: (context, i) => const SizedBox(
                                height: 10.0,
                              ),
                          itemCount: comments.length),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0))),
                child: Container(
                    margin: EdgeInsets.only(top: 1.0),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20.0),
                            bottomRight: Radius.circular(20.0))),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Row(children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                          ),
                          child: TextFormField(
                            controller: commentController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'type your message here ...',
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: 50.0,
                        color: Colors.red.shade900,
                        child: MaterialButton(
                          onPressed: () {
                            onPressed!();
                          },
                          minWidth: 1.0,
                          child: const Icon(
                            IconBroken.Send,
                            size: 16.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ])),
              )
            ],
          ),
        ),
      );
    });

Widget userImages(userModel, context, {bool fromProfile = false}) => SizedBox(
      height: fromProfile ? 300 : 250,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: InkWell(
              onTap: () {
                navigateTo(
                    context, ShowImageScreen(userModel.coverImage.toString()));
              },
              child: Container(
                height: fromProfile ? 240 : 200,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(userModel.coverImage.toString()),
                        fit: BoxFit.cover)),
              ),
            ),
          ),
          InkWell(
              onTap: () {
                navigateTo(context, ShowImageScreen(userModel.image));
              },
              child: circleImage(image: userModel.image, radius: 60.0)),
        ],
      ),
    );
