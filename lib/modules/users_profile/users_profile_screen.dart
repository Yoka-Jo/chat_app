import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoka_chat_app/layout/cubit/cubit.dart';
import 'package:yoka_chat_app/layout/cubit/states.dart';
import 'package:yoka_chat_app/models/user_model.dart';
import 'package:yoka_chat_app/shared/components/components.dart';

class UsersProfileScreen extends StatelessWidget {
  final UserModel? userModel;
  const UsersProfileScreen({Key? key, this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocialCubit, SocialStates>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: IconButton(
                padding: const EdgeInsets.only(left: 20.0),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                userImages(userModel!, context, fromProfile: true),
                Text(userModel!.name.toString(),
                    style: const TextStyle(
                        fontSize: 18.0, fontWeight: FontWeight.w600)),
                Text(userModel!.bio.toString(),
                    style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black45)),
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                            "${userModel!.name!.split(" ").first}'s Posts",
                            style: const TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold)),
                      ),
                      Builder(builder: (context) {
                        var posts = SocialCubit.get(context).posts;
                        return posts!
                                .where(
                                    (element) => element.uId == userModel!.uId)
                                .toList()
                                .isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, i) {
                                  if (posts[i].uId == userModel!.uId) {
                                    return defaultPost(
                                        SocialCubit.get(context), i,
                                        id: userModel!.uId);
                                  } else {
                                    return Container();
                                  }
                                },
                                itemCount: posts.length)
                            : Padding(
                                padding: const EdgeInsets.only(top: 50.0),
                                child: Center(
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
}
