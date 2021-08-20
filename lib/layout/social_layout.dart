import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoka_chat_app/layout/cubit/cubit.dart';
import 'package:yoka_chat_app/layout/cubit/states.dart';
import 'package:yoka_chat_app/modules/login/cubit/cubit.dart';
import 'package:yoka_chat_app/modules/login/login_screen.dart';
import 'package:yoka_chat_app/shared/components/components.dart';
import 'package:yoka_chat_app/shared/components/constants.dart';
import 'package:yoka_chat_app/shared/network/local/cache_helper.dart';
import 'package:yoka_chat_app/shared/styles/icon_broken.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {

    @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) => SocialCubit.get(context)
        ..getUser()
        ..getPosts()
        ..getUsers());
    
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = SocialCubit.get(context);
          return Scaffold(
              appBar: AppBar(
                actions: cubit.titles[cubit.navIndex] == "settings"
                    ? [
                        PopupMenuButton(
                            offset: const Offset(-38.0, 30.0),
                            color: Colors.blue.shade700,
                            icon: const CircleAvatar(
                              radius: 30.0,
                              child: Icon(
                                IconBroken.Setting,
                                size: 25.0,
                              ),
                            ),
                            itemBuilder: (_) => [
                                  PopupMenuItem(
                                    height: 10.0,
                                    onTap: () async {
                                      await FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(uId)
                                          .update({"status": "Offline"});

                                      LoginCubit.get(context)
                                          .signOut()
                                          .then((value) {
                                        Cachehelper.deleteData(key: "uId").then((value) {
                                           SocialCubit.get(context).navIndex = 0;
                                           uId = null;
                                        navigateTo(context, LoginScreen());
                                        });
                                       
                                      });
                                    },
                                    padding: EdgeInsets.zero,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Icon(
                                          IconBroken.Logout,
                                          size: 30.0,
                                        ),
                                        SizedBox(
                                          width: 8.0,
                                        ),
                                        Text(
                                          "Log Out",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                        const SizedBox(
                          width: 10.0,
                        )
                      ]
                    :  [],
                elevation: 0.0,
                backgroundColor: Colors.transparent,
                title: coloredIcon(
                  Text(cubit.titles[cubit.navIndex],
                      style:const TextStyle(
                          fontSize: 28.0, fontWeight: FontWeight.w700)),
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                unselectedItemColor: Colors.grey,
                selectedItemColor: Colors.red.shade900,
                iconSize: 28.0,
                currentIndex: cubit.navIndex,
                onTap: (index) {
                  cubit.changeNavScreen(index);
                },
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(IconBroken.Home),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(IconBroken.Chat),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(IconBroken.Setting),
                    label: "",
                  ),
                ],
              ),
              body: cubit.navScreens[cubit.navIndex]);
        },
      ),
    );
  }
}
