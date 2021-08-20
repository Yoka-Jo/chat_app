import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yoka_chat_app/models/user_model.dart';
import 'package:yoka_chat_app/modules/signup/cubit/states.dart';

class SignupCubit extends Cubit<SignupStates> {
  SignupCubit() : super(SignupInitialState());

  static SignupCubit get(context) => BlocProvider.of(context);

  void signup(
    context,
      {required String name,
      required String phone,
      required String email,
      required String password}) {
    emit(SignupLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createUser(context , name: name, phone: phone, email: email, uId: value.user!.uid);
    }).catchError((error) {
      emit(SignupErrorState(error.toString()));
    });
  }

  void createUser(
    context,
    {
    required String name,
    required String phone,
    required String email,
    required String uId,
  }) {
    UserModel model = UserModel(
        bio: "",
        coverImage:
            "https://image.freepik.com/free-vector/laptop-with-program-code-isometric-icon-software-development-programming-applications-dark-neon_39422-971.jpg",
        email: email,
        image:
            "https://image.freepik.com/free-photo/photo-attractive-bearded-young-man-with-cherful-expression-makes-okay-gesture-with-both-hands-likes-something-dressed-red-casual-t-shirt-poses-against-white-wall-gestures-indoor_273609-16239.jpg",
        name: name,
        phone: phone,
        uId: uId);
    FirebaseFirestore.instance
        .collection("users")
        .doc(uId)
        .set(model.toMap())
        .then((value) {
      emit(CreateUserAndSignupSuccessState(uid: uId));
    }).catchError((error) {
      emit(CreateUserErrorState(error: error.toString()));
    });
  }


  IconData suffix = Icons.visibility_off_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;
    emit(SignupChangePasswordVisibility());
  }
}
