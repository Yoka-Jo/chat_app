import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:yoka_chat_app/layout/cubit/cubit.dart';
import 'package:yoka_chat_app/layout/cubit/states.dart';
import 'package:yoka_chat_app/models/user_model.dart';
import 'package:yoka_chat_app/modules/show_image/show_image_screen.dart';
import 'package:yoka_chat_app/shared/components/components.dart';
import 'package:yoka_chat_app/shared/components/constants.dart';
import 'package:yoka_chat_app/shared/styles/icon_broken.dart';

class ChatScreen extends StatefulWidget {
  final UserModel? friendData;
  const ChatScreen({Key? key, this.friendData}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  var messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .update({"status": status});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else {
      setStatus("offline");
    }
  }

  selectImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Upload a photo'),
            children: [
              SimpleDialogOption(
                child: const Text(
                  'Choose an image From Gallery',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  SocialCubit.get(context).getChatImage(true);
                },
              ),
              SimpleDialogOption(
                child: const Text(
                  'Open camera',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.w600),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  SocialCubit.get(context).getChatImage(false);
                },
              ),
              SimpleDialogOption(
                child: const Text(
                  'Cancel',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uId)
            .collection("chat")
            .doc(widget.friendData!.uId)
            .collection("messages")
            .orderBy("time")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!.docs;
            return Scaffold(
                appBar: appBar(context, widget.friendData!.phone!),
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, i) => Align(
                            alignment: messages[i]["senderId"] == uId
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: InkWell(
                              enableFeedback: true,
                              onLongPress: () {
                                if (messages[i]["senderId"] == uId) {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            content: const Text(
                                                "You want to delete for..."),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    SocialCubit.get(context)
                                                        .deleteMessage(
                                                            widget
                                                                .friendData!.uId
                                                                .toString(),
                                                            messages[i]["time"]
                                                                .toString(),
                                                            false);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Me")),
                                              TextButton(
                                                  onPressed: () {
                                                    SocialCubit.get(context)
                                                        .deleteMessage(
                                                            widget
                                                                .friendData!.uId
                                                                .toString(),
                                                            messages[i]["time"]
                                                                .toString(),
                                                            true);

                                                    Navigator.of(context).pop();
                                                  },
                                                  child:
                                                      const Text("EveryOne")),
                                            ],
                                          ));
                                }
                                return;
                              },
                              child: Container(
                                padding:
                                    !messages[i]["message"]!.startsWith("https")
                                        ? const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 8.0)
                                        : EdgeInsets.zero,
                                decoration: BoxDecoration(
                                    color: messages[i]["message"]!
                                            .startsWith("https:")
                                        ? Colors.grey.shade300
                                        : (messages[i]["senderId"] == uId
                                            ? Colors.red.shade900
                                            : Colors.grey.shade300),
                                    borderRadius: BorderRadius.only(
                                        topRight: const Radius.circular(10.0),
                                        bottomRight:
                                            messages[i]["senderId"] == uId
                                                ? const Radius.circular(0.0)
                                                : const Radius.circular(10.0),
                                        topLeft: const Radius.circular(10.0),
                                        bottomLeft:
                                            messages[i]["senderId"] == uId
                                                ? const Radius.circular(10.0)
                                                : const Radius.circular(0.0))),
                                child: (!messages[i]["message"]!
                                        .startsWith("https:")
                                    ? Text(
                                        messages[i]["message"].toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color:
                                                messages[i]["senderId"] == uId
                                                    ? Colors.white
                                                    : Colors.black),
                                      )
                                    : InkWell(
                                      onTap: (){
                                        navigateTo(context, ShowImageScreen(messages[i]["message"].toString()));
                                      },
                                      child: Image.network(
                                          messages[i]["message"].toString(),
                                          height: 250,
                                          width: 250,
                                          fit: BoxFit.cover),
                                    )),
                              ),
                            ),
                          ),
                          separatorBuilder: (context, i) => const SizedBox(
                            height: 15.0,
                          ),
                          itemCount: messages.length,
                        ),
                      ),
                      const SizedBox(height: 20.0,),
                      BlocBuilder<SocialCubit, SocialStates>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (SocialCubit.get(context).imageForChat != null)
                                Stack(
                                    fit: StackFit.passthrough,
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        height: 150.0,
                                        width: 150.0,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            4.0,
                                          ),
                                          image: DecorationImage(
                                            image: FileImage(
                                                SocialCubit.get(context)
                                                    .imageForChat!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                          top: -15,
                                          left: 120,
                                          child: IconButton(
                                              onPressed: () {
                                                SocialCubit.get(context)
                                                    .clearChatImage();
                                              },
                                              icon: Icon(Icons.cancel_sharp,
                                                  color: Colors.red.shade900,
                                                  size: 30.0))),
                                    ]),
                              Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      15.0,
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: Row(children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0,
                                        ),
                                        child: TextFormField(
                                          controller: messageController,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText:
                                                'type your message here ...',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      height: 50.0,
                                      color: Colors.red.shade900,
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              selectImage(context);
                                            },
                                            child: const Icon(
                                              IconBroken.Image,
                                              size: 18.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 8.0,
                                          ),
                                          const VerticalDivider(
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(
                                            width: 8.0,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              if (SocialCubit.get(context)
                                                          .imageForChat !=
                                                      null &&
                                                  messageController
                                                      .text.isEmpty) {
                                                SocialCubit.get(context)
                                                    .sendImageInChat(widget
                                                        .friendData!.uId
                                                        .toString());
                                              } else if ((SocialCubit.get(
                                                              context)
                                                          .imageForChat !=
                                                      null &&
                                                  messageController
                                                      .text.isNotEmpty)) {
                                                SocialCubit.get(context)
                                                    .sendImageInChat(widget
                                                        .friendData!.uId
                                                        .toString())
                                                    .then((value) {
                                                  SocialCubit.get(context)
                                                      .sendMessage(
                                                    receiverId: widget
                                                        .friendData!.uId
                                                        .toString(),
                                                    message:
                                                        messageController.text,
                                                  );
                                                  messageController.clear();
                                                });
                                              } else if (SocialCubit.get(
                                                              context)
                                                          .imageForChat ==
                                                      null &&
                                                  messageController
                                                      .text.isNotEmpty) {
                                                SocialCubit.get(context)
                                                    .sendMessage(
                                                  receiverId: widget
                                                      .friendData!.uId
                                                      .toString(),
                                                  message:
                                                      messageController.text,
                                                );
                                                messageController.clear();
                                              }
                                              return;
                                            },
                                            child: const Icon(
                                              IconBroken.Send,
                                              size: 18.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ])),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ));
          } else {
            return Container(
                color: Colors.white,
                child: Center(
                    child: CircularProgressIndicator(
                  color: Colors.red.shade900,
                )));
          }
        });
  }

  PreferredSizeWidget? appBar(context, String number) => AppBar(
        titleSpacing: -10,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_outlined,
              color: Colors.black,
            )),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                navigateTo(context, ShowImageScreen(widget.friendData!.image));
              },
              child: circleImage(
                  isStatus: false,
                  radius: 20.0,
                  image: widget.friendData!.image),
            ),
            const SizedBox(
              width: 5.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.friendData!.name.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(widget.friendData!.uId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return Row(
                          children: [
                            Icon(
                              Icons.brightness_1_rounded,
                              color: snapshot.data!.get("status") == "Online"
                                  ? Colors.green
                                  : Colors.grey,
                              size: 10.0,
                            ),
                            const SizedBox(
                              width: 5.0,
                            ),
                            Text(snapshot.data!.get("status") == "Online"
                                ? "Online"
                                : "Offline")
                          ],
                        );
                      } else {
                        return Container();
                      }
                    })
              ],
            ),
          ],
        ),
        actions: [
          coloredIcon(
            IconButton(
              onPressed: () async {
                await FlutterPhoneDirectCaller.callNumber(number);
              },
              icon: const Icon(
                IconBroken.Calling,
                color: Colors.green,
                size: 30.0,
              ),
            ),
          ),
          const SizedBox(
            width: 20.0,
          )
        ],
      );
}
