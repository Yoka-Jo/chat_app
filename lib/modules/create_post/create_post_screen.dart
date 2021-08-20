import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:yoka_chat_app/layout/cubit/cubit.dart';
import 'package:yoka_chat_app/layout/cubit/states.dart';
import 'package:yoka_chat_app/shared/components/components.dart';
import 'package:yoka_chat_app/shared/styles/icon_broken.dart';

class CreatePostScreen extends StatelessWidget {
  var textController = TextEditingController();
  var hashTagController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = SocialCubit.get(context);
        final userModel = cubit.userModel;
        return KeyboardSizeProvider(
          child: Scaffold(
              key: scaffoldKey,
              appBar: AppBar(
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                titleSpacing: -10.0,
                title: coloredIcon(const Text("Create Post",
                    style: TextStyle(
                        fontSize: 25.0, fontWeight: FontWeight.w700))),
                leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    )),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (cubit.postImage == null &&
                          textController.text.isNotEmpty) {
                        SocialCubit.get(context).createPost(
                            dateTime: DateTime.now().toString(),
                            text: textController.text);
                        Navigator.of(context).pop();
                      } else if (cubit.postImage != null) {
                        SocialCubit.get(context).uploadImageThenPost(
                          dateTime: DateTime.now().toString(),
                          text: textController.text,
                        );
                        Navigator.of(context).pop();
                      } else {
                        return;
                      }
                    },
                    child: const Text("Post",
                        style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue)),
                  ),
                  const SizedBox(
                    width: 10.0,
                  )
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        circleImage(
                            image: userModel!.image,
                            radius: 25.0,
                            isStatus: false),
                        const SizedBox(
                          width: 8.0,
                        ),
                        Expanded(
                          child: Text(userModel.name.toString(),
                              style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w600,
                                  height: 0.5)),
                        ),
                        coloredIcon(
                          IconButton(
                            onPressed: () {
                              cubit.getPostImage();
                            },
                            icon: const Icon(
                              IconBroken.Image,
                              size: 35.0,
                            ),
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: TextFormField(
                        minLines: null,
                        maxLines: null,
                        controller: textController,
                        decoration: InputDecoration(
                          hintText: 'what is on your mind, ' +
                              userModel.name.toString() +
                              '...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    if (SocialCubit.get(context).postImage != null)
                      Consumer<ScreenHeight>(builder: (context, _res, child) {
                        return !_res.isOpen
                            ? Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.topLeft,
                                children: [
                                    Container(
                                      height: 200.0,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          4.0,
                                        ),
                                        image: DecorationImage(
                                          image: FileImage(cubit.postImage!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                        top: -15,
                                        left: -15,
                                        child: IconButton(
                                            onPressed: () {
                                              cubit.clearPostImage();
                                            },
                                            icon: Icon(Icons.cancel_sharp,
                                                color: Colors.red.shade900,
                                                size: 30.0))),
                                  ])
                            : Container();
                      }),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: cubit.hashTagsList.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Wrap(
                                  spacing: 5,
                                  runSpacing: 5,
                                  children: cubit.hashTagsList.map((hashTag) {
                                    return Chip(
                                        backgroundColor: Colors.blue[100],
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(7),
                                        ),
                                        label: Text(hashTag,
                                            style: TextStyle(
                                                color: Colors.blue[900])),
                                        onDeleted: () {
                                          cubit.removeHashTag(hashTag);
                                        });
                                  }).toList()),
                            )
                          : Container(),
                    ),
                    TextButton(
                      onPressed: () {
                        scaffoldKey.currentState!
                            .showBottomSheet((context) => SizedBox(
                                  height: 150.0,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: TextField(
                                          controller: hashTagController,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 1.0,
                                                      color: Colors.black))),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          if (hashTagController
                                              .text.isNotEmpty) {
                                            cubit.addHashTag(
                                                hashTagController.text);
                                            hashTagController.clear();
                                            Navigator.of(context).pop();
                                          }
                                          return;
                                        },
                                        child: const Text(
                                          "ADD",
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ));
                      },
                      child: const Text(
                        "#tags",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }
}
