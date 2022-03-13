import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoka_chat_app/layout/cubit/cubit.dart';
import 'package:yoka_chat_app/layout/cubit/states.dart';
import 'package:yoka_chat_app/models/post_model.dart';
import 'package:yoka_chat_app/models/user_model.dart';
import 'package:yoka_chat_app/modules/edit_profile/edit_screen_screen.dart';
import 'package:yoka_chat_app/shared/components/components.dart';
import 'package:yoka_chat_app/shared/components/constants.dart';
import 'package:yoka_chat_app/shared/styles/icon_broken.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final userModel = SocialCubit.get(context).userModel;
        return Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                userImages(userModel!, context),
                Text(userModel.name.toString(),
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.w600)),
                Text(userModel.bio.toString(),
                    style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black45)),
                const SizedBox(
                  height: 20.0,
                ),
                editUserData(context, "Click To Edit Your Profile.",
                    IconBroken.Edit, userModel),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text("My Posts",
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      Builder(builder: (context) {
                        List<PostModel>? posts = [];
                        if (SocialCubit.get(context).posts == null) {
                          posts = [];
                        } else {
                          posts = SocialCubit.get(context).posts;
                        }
                        return posts!
                                .where(
                                    (element) => element.uId == userModel.uId)
                                .isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, i) {
                                  if (posts![i].uId == uId) {
                                    return defaultPost(
                                        SocialCubit.get(context), i,
                                        id: userModel.uId);
                                  } else {
                                    return Container();
                                  }
                                },
                                itemCount: posts.length)
                            : Center(
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      "assets/images/not_found.svg",
                                      height: 150,
                                    ),
                                    const Text(
                                      "NO POSTS YET.",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget editUserData(
          context, String text, IconData icon, UserModel userModel) =>
      InkWell(
        onTap: () {
          navigateTo(context, const EditProfileScreen());
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: Colors.blue),
              ),
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(color: Colors.blue, fontSize: 15.0),
                ),
              ),
            ),
            const SizedBox(
              width: 2.0,
            ),
            Container(
                padding: const EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.5, color: Colors.blue),
                ),
                child: Icon(
                  icon,
                  color: Colors.blue,
                )),
          ],
        ),
      );
}
