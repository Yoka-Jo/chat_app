import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoka_chat_app/layout/cubit/cubit.dart';
import 'package:yoka_chat_app/layout/cubit/states.dart';
import 'package:yoka_chat_app/models/user_model.dart';
import 'package:yoka_chat_app/modules/chat/chat_screen.dart';
import 'package:yoka_chat_app/shared/components/components.dart';
import 'package:yoka_chat_app/shared/components/constants.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> with WidgetsBindingObserver {
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
      //online
      setStatus("Online");
    } else {
      //offline
      setStatus("Offline");
    }
  }


  @override
  Widget build(BuildContext context) {

    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<UserModel>? users = SocialCubit.get(context).users!.where((element) => element.uId != uId).toList();
        return users  != null
            ? Column(
              children: [
                const SizedBox(height: 20.0),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 20.0),
                 child: TextField(
                    onChanged: (value) {
                      SocialCubit.get(context).searchForAUser(value);
                    },
                    decoration: InputDecoration(
                        fillColor: Colors.grey[300],
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey[100]!, width: 1)),
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                        ),
                        focusedBorder:  OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red.shade900, width: 1)),
                  ),
                             ),
               ),
                const SizedBox(height: 30.0),
                Expanded(
                  child: RefreshIndicator(
                    color: Colors.red.shade900,
                    onRefresh: ()async{
                      SocialCubit.get(context).getUsers();
                    },
                    child: ListView.separated(
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        itemBuilder: (context, index) => buildUserItem(
                          SocialCubit.get(context).filteredUsers.isEmpty ?users[index] : SocialCubit.get(context).filteredUsers[index]
                          , context),
                        separatorBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: myDivider(),
                        ),
                        itemCount: SocialCubit.get(context).filteredUsers.isEmpty ?users.length: SocialCubit.get(context).filteredUsers.length,
                      ),
                  ),
                ),
              ],
            )
            : const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buildUserItem(UserModel model, context) => InkWell(
        onTap: () {
          navigateTo(
            context,
            ChatScreen(
              friendData: model,
            ),
          );
        },
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(model.uId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 30.0,
                              backgroundImage: NetworkImage(model.image.toString()),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.name.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: model.name.toString() + " is ",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      TextSpan(
                                          text: snapshot.data!.get("status"),
                                          style: TextStyle(
                                              color: snapshot.data!
                                                          .get("status") ==
                                                      "Online"
                                                  ? Colors.green
                                                  : Colors.grey,
                                              fontWeight: FontWeight.bold)),
                                      const TextSpan(
                                          text: ' now.',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Icon(
                          Icons.brightness_1_rounded,
                          color: snapshot.data!.get("status") == "Online"
                              ? Colors.green
                              : Colors.grey,
                        )
                      ],
                    );
                  } else {
                    return Container();
                  }
                })),
      );
}
