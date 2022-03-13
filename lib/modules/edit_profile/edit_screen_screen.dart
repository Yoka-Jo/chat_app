import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoka_chat_app/layout/cubit/cubit.dart';
import 'package:yoka_chat_app/layout/cubit/states.dart';
import 'package:yoka_chat_app/shared/components/components.dart';
import 'package:yoka_chat_app/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameEditingController;

  late TextEditingController bioEditingController;

  late TextEditingController phoneEditingController;

  @override
  void initState() {
    super.initState();
    nameEditingController = TextEditingController();
    bioEditingController = TextEditingController();
    phoneEditingController = TextEditingController();
  }

  @override
  void dispose() {
    nameEditingController.dispose();
    bioEditingController.dispose();
    phoneEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocialCubit, SocialStates>(
      builder: (context, state) {
        final cubit = SocialCubit.get(context);
        final userModel = cubit.userModel!;
        return Scaffold(
          appBar: appBar(context, cubit),
          body: SingleChildScrollView(
            child: Column(
              children: [
                if (state is SocialUpdateUserLoadingState)
                  coloredIcon(const LinearProgressIndicator()),
                if (state is SocialUpdateUserLoadingState)
                  const SizedBox(
                    height: 10.0,
                  ),
                SizedBox(
                  height: 250,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: cubit.coverImage == null
                                      ? NetworkImage(
                                          userModel.coverImage.toString())
                                      : FileImage(cubit.coverImage!)
                                          as ImageProvider,
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      Stack(
                          alignment: AlignmentDirectional.bottomEnd,
                          children: [
                            CircleAvatar(
                              radius: 65,
                              backgroundImage: cubit.profileImage == null
                                  ? NetworkImage(userModel.image.toString())
                                  : FileImage(cubit.profileImage!)
                                      as ImageProvider,
                            ),
                            PopupMenuButton(
                                offset: const Offset(-38.0, 30.0),
                                color: Colors.red.shade900,
                                icon: const CircleAvatar(
                                  radius: 20.0,
                                  child: Icon(
                                    IconBroken.Camera,
                                    size: 20.0,
                                  ),
                                ),
                                itemBuilder: (_) => [
                                      PopupMenuItem(
                                        onTap: () {
                                          cubit.getProfileImage();
                                        },
                                        height: 10,
                                        padding: EdgeInsets.zero,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: const [
                                              SizedBox(
                                                width: 8.0,
                                              ),
                                              Icon(IconBroken.Upload,
                                                  color: Colors.blue),
                                              SizedBox(
                                                width: 8.0,
                                              ),
                                              Text(
                                                "Update profile picture",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      PopupMenuItem(
                                        onTap: () {
                                          cubit.getCoverImage();
                                        },
                                        height: 10,
                                        padding: EdgeInsets.zero,
                                        child: Row(
                                          children: const [
                                            SizedBox(
                                              width: 8.0,
                                            ),
                                            Icon(IconBroken.Upload,
                                                color: Colors.blue),
                                            SizedBox(
                                              width: 8.0,
                                            ),
                                            Text(
                                              "Update Cover picture",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ])
                          ]),
                    ],
                  ),
                ),
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
                Column(
                  children: [
                    DefaultTextFormField(
                        textEditingController: nameEditingController,
                        hintText: userModel.name.toString(),
                        textOpacity: 0.5,
                        formCurves: 0.0,
                        isHintSettings: true,
                        formborderThickness: 0.0,
                        isTransparent: true,
                        prefixIcon: const Icon(
                          IconBroken.Profile,
                          size: 30.0,
                        )),
                    const SizedBox(
                      height: 10.0,
                    ),
                    DefaultTextFormField(
                        textEditingController: bioEditingController,
                        hintText: userModel.bio.toString().isEmpty
                            ? "type here your bio"
                            : userModel.bio.toString(),
                        textOpacity: 0.5,
                        formCurves: 0.0,
                        isHintSettings:
                            userModel.bio.toString().isEmpty ? false : true,
                        formborderThickness: 0.0,
                        isTransparent: true,
                        prefixIcon: const Icon(
                          IconBroken.Info_Circle,
                          size: 30.0,
                        )),
                    const SizedBox(
                      height: 10.0,
                    ),
                    DefaultTextFormField(
                        textEditingController: phoneEditingController,
                        hintText: userModel.phone.toString(),
                        textOpacity: 0.5,
                        isHintSettings: true,
                        formCurves: 0.0,
                        formborderThickness: 0.0,
                        isTransparent: true,
                        prefixIcon: const Icon(
                          IconBroken.Call,
                          size: 30.0,
                        )),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget? appBar(context, SocialCubit cubit) => AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        titleSpacing: -10.0,
        title: coloredIcon(const Text("Edit User",
            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700))),
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
              if (nameEditingController.text.isNotEmpty ||
                  bioEditingController.text.isNotEmpty ||
                  phoneEditingController.text.isNotEmpty ||
                  cubit.coverImage != null ||
                  cubit.profileImage != null) {
                cubit
                    .updateUserAndImage(
                        name: nameEditingController.text,
                        bio: bioEditingController.text,
                        phone: phoneEditingController.text)
                    .then((value) {
                  Navigator.of(context).pop();
                });
              } else {
                return;
              }
            },
            child: const Text("Edit",
                style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue)),
          ),
          const SizedBox(
            width: 10.0,
          )
        ],
      );
}
