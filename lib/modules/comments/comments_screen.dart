import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoka_chat_app/layout/cubit/cubit.dart';
import 'package:yoka_chat_app/layout/cubit/states.dart';
import 'package:yoka_chat_app/models/post_model.dart';
import 'package:yoka_chat_app/shared/components/components.dart';

class CommentsScreen extends StatelessWidget {
  final PostModel? post;
  final int? index;

  CommentsScreen({Key? key, this.post , this.index}) : super(key: key);
  var commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getComments(post!.postId!);
      return BlocBuilder<SocialCubit, SocialStates>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white60,
            body: Center(
              child: Dismissible(
                  direction: DismissDirection.vertical,
                  key: Key(post!.postId.toString()),
                  onDismissed: (_) => Navigator.of(context).pop(),
                  child: defaultComments(commentController, () {
                    SocialCubit.get(context)
                        .sendComment(post!.postId!, commentController.text);
                    commentController.clear();
                  }, SocialCubit.get(context) , post! , index!)),
            ),
          );
        },
      );
    });
  }
}
