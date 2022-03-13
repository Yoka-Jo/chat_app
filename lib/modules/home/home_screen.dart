import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yoka_chat_app/layout/cubit/cubit.dart';
import 'package:yoka_chat_app/layout/cubit/states.dart';
import 'package:yoka_chat_app/modules/create_post/create_post_screen.dart';
import 'package:yoka_chat_app/shared/components/components.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.red.shade900,
      onRefresh: () async {
        SocialCubit.get(context).getPosts();
      },
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {
          if (state is SocialGetUserErrorState) {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            defaultSnackBar(context, text: state.error);
          }
        },
        builder: (context, state) {
          var cubit = SocialCubit.get(context);
          var userModel = cubit.userModel;
          return Scaffold(
            body: (cubit.userModel != null)
                ? SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Row(
                            children: [
                              circleImage(
                                  image: userModel!.image,
                                  radius: 25.0,
                                  isStatus: false),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Expanded(
                                child: toCreatePostButton(onPressed: () {
                                  navigateTo(context, const CreatePostScreen());
                                }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        cubit.posts == null
                            ? (ListView(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 150),
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
                                  ]))
                            : ((cubit.posts!.isNotEmpty &&
                                    cubit.numberOfLikes!.isNotEmpty)
                                ? (ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, i) => defaultPost(
                                        cubit, i,
                                        fromProfile: false),
                                    itemCount: cubit.posts!.length))
                                : (Padding(
                                    padding: const EdgeInsets.only(
                                        top: 200, bottom: 150),
                                    child: CircularProgressIndicator(
                                      color: Colors.red.shade800,
                                    ),
                                  )))
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: Colors.red.shade800,
                    ),
                  ),
          );
        },
      ),
    );
  }
}
