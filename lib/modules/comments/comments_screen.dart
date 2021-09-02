import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoka_chat_app/layout/cubit/cubit.dart';
import 'package:yoka_chat_app/layout/cubit/states.dart';
import 'package:yoka_chat_app/models/post_model.dart';
import 'package:yoka_chat_app/shared/components/components.dart';

class CommentsScreen extends StatefulWidget {
  final PostModel? post;
  final int? index;

  CommentsScreen({Key? key, this.post , this.index}) : super(key: key);

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late TextEditingController commentController;

    @override
  void initState() {
    super.initState();
    commentController = TextEditingController();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getComments(widget.post!.postId!);
      return BlocBuilder<SocialCubit, SocialStates>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white60,
            body: Center(
              child: Dismissible(
                  direction: DismissDirection.vertical,
                  key: Key(widget.post!.postId.toString()),
                  onDismissed: (_) => Navigator.of(context).pop(),
                  child: defaultComments(commentController, () {
                    SocialCubit.get(context)
                        .sendComment(widget.post!.postId!, commentController.text);
                    commentController.clear();
                  }, SocialCubit.get(context) , widget.post! , widget.index!)),
            ),
          );
        },
      );
    });
  }
}
