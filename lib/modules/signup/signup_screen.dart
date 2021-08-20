import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoka_chat_app/layout/cubit/cubit.dart';
import 'package:yoka_chat_app/layout/social_layout.dart';
import 'package:yoka_chat_app/modules/login/login_screen.dart';
import 'package:yoka_chat_app/modules/signup/cubit/cubit.dart';
import 'package:yoka_chat_app/modules/signup/cubit/states.dart';
import 'package:yoka_chat_app/shared/components/components.dart';
import 'package:yoka_chat_app/shared/components/constants.dart';
import 'package:yoka_chat_app/shared/network/local/cache_helper.dart';

class SignupScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SignupCubit(),
      child: BlocConsumer<SignupCubit, SignupStates>(
        listener: (context, state) {
          if (state is SignupErrorState) {
            defaultSnackBar(context, text: state.error.toString());
          } else if (state is CreateUserAndSignupSuccessState) {
            Cachehelper.saveData(key: "uId", value: state.uid).then((value) {
              uId = state.uid;
              navigateAndFinish(context, const SocialScreen());
            });
          }
        },
        builder: (context, state) {
          final cubit = SignupCubit.get(context);
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sign up",
                            style: Theme.of(context)
                                .appBarTheme
                                .textTheme
                                ?.headline1),
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Text("Sign up with one the following options:",
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(
                          height: 20.0,
                        ),
                        textFormField("Name:", nameController, (String? value) {
                          if (value!.isEmpty) {
                            return "Please enter your Name.";
                          }
                        }),
                        textFormField("Phone Number:", phoneController,
                            (String? value) {
                          if (value!.isEmpty) {
                            return "Please enter your Phone.";
                          }
                        }, textInputType: TextInputType.phone),
                        textFormField(
                          "Email",
                          emailController,
                          (String? value) {
                            if (value!.isEmpty) {
                              return "Please enter your Email.";
                            } else if (!value.contains("@")) {
                              return "Please enter a correct email!";
                            }
                          },
                        ),
                        textFormField(
                          "Password",
                          passwordController,
                          (String? value) {
                            if (value!.isEmpty) {
                              return "Please enter your password.";
                            } else if (value.length < 6) {
                              return "Your Password is too short!";
                            }
                          },
                          isObsecured: cubit.isPassword,
                          suffixIcon: IconButton(
                            onPressed: () {
                              cubit.changePasswordVisibility();
                            },
                            icon: Icon(cubit.suffix),
                          ),
                        ),
                        state is! SignupLoadingState
                            ? LogoButton(
                                buttonText: "Sign up",
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    cubit.signup(
                                      context,
                                      name: nameController.text,
                                      phone: phoneController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );
                                  }
                                })
                            : Center(
                                child: CircularProgressIndicator(
                                color: Colors.red.shade900,
                              )),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            InkWell(
                              onTap: () {
                                navigateTo(context, LoginScreen());
                              },
                              child: const Text("Log in",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget textFormField(String hintText, TextEditingController controller,
        String? Function(String?)? validator,
        {TextInputType? textInputType,
        IconButton? suffixIcon,
        bool? isObsecured}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hintText,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10.0,
        ),
        DefaultTextFormField(
          validator: validator,
          textInputType: textInputType,
          suffixIcon: suffixIcon ??
              IconButton(
                icon: Container(),
                onPressed: () {},
              ),
          isObscured: isObsecured ?? false,
          hintText: "Enter your $hintText...",
          textEditingController: controller,
        ),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
